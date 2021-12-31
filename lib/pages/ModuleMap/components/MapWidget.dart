import 'package:scet_dz/utils/storage/data_storageKey.dart';
import 'package:scet_dz/utils/storage/storage.dart';
import 'package:scet_dz/components/ToastWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:scet_dz/api/Api.dart';
import 'package:scet_dz/api/Request.dart';
import 'package:scet_dz/model/provider/provider_home.dart';
import 'package:scet_dz/utils/screen/screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MapWidget extends StatefulWidget {
  final bool commonMapType;
  final bool? backPark;
  final String layerType;
  MapWidget({required this.commonMapType, this.backPark,required this.layerType});

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  FocusNode blankNode = FocusNode();

  MapController _mapController = MapController();
  // 119.563522,37.015781
  LatLng _centerPoint = LatLng(36.897795, 117.456403);

  double _mapZoom = 13.5;

  var currentId;

  List<Marker> _markers = [];
  Color _markerColor = Color(0XFFFFFFFF);
  void _switchLayer(String type) {
    _markers.clear();
    switch (type) {
      case 'station': _realStationInfo();break;
      case 'enterprise':_getEnterprise();break;
      case 'dangerFactors':_getDangerFactors();break;
      case 'sensitivePoint':_getSensitivePoint();break;
      case 'monitorDevice':_getMonitorDevice();break;
    }
  }
  // 站点接口
  _realStationInfo() async {
    var response = await Request().get(Api.url['realStationInfo']);
    if (response != null && response['code'] == 200) {
      response['data'].forEach((item) {
        item['stId'] = item['oldId'];
      });
      //缓存站点数据
      StorageUtil().setJSON(StorageKey.RealStationInfo, response['data']);
      context.read<HomeModel>().getSiteList(response['data']);
    }
  }
// 获取园区范围
  List _polylines = [];
  void _getParkBorder() async {
    var response = await Request().get(Api.url['parkBorder']);
    if (response['code'] == 200) {
      List border = response['data']['features'][0]['geometry']['coordinates'];
      for (var i = 0; i < border.length; i++) {
        List itemData = [];
        if (border[i].length == 1) {
          itemData = border[0];
        } else {
          itemData = border[i];
        }
        List<LatLng> polylinesArray = [];
        for (var j = 0; j < itemData.length; j++) {
          polylinesArray.add(LatLng(itemData[j][1], itemData[j][0]));
        }
        _polylines.add(polylinesArray);
      }
      this.setState(() {
        _polylines = _polylines;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getParkBorder();
    _switchLayer(widget.layerType);
  }

  @override
  void didUpdateWidget(MapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 切换图层
    String oldLayerIndex = oldWidget.layerType;
    String newLayerIndex = widget.layerType;
    if (newLayerIndex != oldLayerIndex) {
      _switchLayer(newLayerIndex);
    }
    // 移动到园区范围
    if (oldWidget.backPark != widget.backPark) {
      _mapController.move(_centerPoint, _mapZoom);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
        mapController: _mapController,
        options: MapOptions(
            center: _centerPoint,
            zoom: _mapZoom,
            plugins: [
              MarkerClusterPlugin(),
            ],
            onTap: (_,val) {
              FocusScope.of(context).requestFocus(blankNode);
            }),
        layers: [
          TileLayerOptions(
            urlTemplate: widget.commonMapType
                ? 'https://cz.scet.com.cn:1443/carto/t/map/{z}/{x}/{y}/tile.png'
                : 'https://api.tiles.mapbox.com/v4/mapbox.satellite/{z}/{x}/{y}@2x.png?access_token={accessToken}',
            additionalOptions: {
              'accessToken':
                  'pk.eyJ1IjoiaWdhdXJhYiIsImEiOiJjazFhOWlkN2QwYzA5M2RyNWFvenYzOTV0In0.lzjuSBZC6LcOy_oRENLKCg',
            },
            tileProvider: CachedTileProvider(),
          ),
          PolylineLayerOptions(
            polylines: _polylines
                .map((item) => (Polyline(
                    points: item, strokeWidth: 2.0, color: Color(0XFF3093DA))))
                .toList(),
          ),
          _markers.length == 0 ?
          _markerLayerOptions() :
          _markerClusterLayerOptions()
        ]);
  }
  // 获取站点数据
  _markerLayerOptions(){
    List data = context.watch<HomeModel>().siteList;
    return MarkerLayerOptions(
        markers: widget.layerType != 'station' ? []:
        data.where((item)=>item['longitude'] != null).toList().map((item) {
          return commonMaker(
            latiude: double.parse(item['latitude'].toString()),
            longitude: double.parse(item['longitude'].toString()),
            icon: 'lib/assets/icon/map/station.png',
            markerName: item['stName'],
            selected: item['stId'] == currentId,
             onTap: () {
               setState(() {
                currentId = item['stId'];
              });
              Navigator.pushNamed(context, '/station/details',arguments: {'stId': item['stId'], 'title': item['stName']});
          });
    }).toList());
  }

  // 获取企业
  void _getEnterprise() async {
    var response = await Request().get(Api.url['company']);
    if (response['code'] == 200) {
      List data = response['data']['features'];
      if (data.length == 0) {
        ToastWidget.showToastMsg('未获取到企业数据');
      }
      data.forEach((item) {
        _markers.add(commonMaker(
            latiude: item['geometry']['coordinates'][1],
            longitude: item['geometry']['coordinates'][0],
            icon: 'lib/assets/icon/map/enterprise.png',
            markerName: item['properties']['shortName'] == null
                ? item['properties']['name']
                : item['properties']['shortName'],
            selected: item['properties']['id'] == currentId,
            onTap: () {
              setState(() {
                currentId = item['properties']['id'];
              });
            }));
        setState(() {
          _markerColor = Color(0XFF00B4EB);
          _markers = _markers;
        });
      });
    }
  }
  //渲染企业
  _markerClusterLayerOptions(){
    return MarkerClusterLayerOptions(
      maxClusterRadius: 80,
      size: Size(px(40.0), px(40.0)),
      fitBoundsOptions: FitBoundsOptions(
        padding: EdgeInsets.all(px(100.0)),
      ),
      markers: _markers,
      polygonOptions: PolygonOptions(
          borderColor: Colors.blueAccent,
          color: Colors.black12,
          borderStrokeWidth: 3),
      builder: (context, markers) {
        return ClipOval(
            child: Container(
                color: _markerColor,
                child: Center(
                    child: Text('${markers.length}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: sp(22.0))))));
      },
    );
  }
  // 获取风险物质
  void _getDangerFactors() async {
    var response = await Request().get(Api.url['riskSource']);
    if (response['code'] == 200) {
      List data = response['data']['features'];
      if (data.length == 0) {
        ToastWidget.showToastMsg('未获取到风险物质数据');
      }
      data.forEach((item) {
        _markers.add(commonMaker(
            latiude: item['geometry']['coordinates'][1],
            longitude: item['geometry']['coordinates'][0],
            icon: 'lib/assets/icon/map/riskSource.png',
            markerName: item['properties']['name'],
            selected: item['properties']['id'] == currentId,
            onTap: () {
              setState(() {
                currentId = item['properties']['id'];
              });
            }));
        setState(() {
          _markerColor = Color(0XFFFF7029);
          _markers = _markers;
        });
      });
    }
  }

  // 获取敏感点
  void _getSensitivePoint() async {
    var response = await Request().get(Api.url['sensitive']);
    if (response['code'] == 200) {
      List data = response['data']['features'];
      if (data.length == 0) {
        ToastWidget.showToastMsg('未获取到敏感点数据');
      }
      data.forEach((item) {
        _markers.add(commonMaker(
            latiude: item['geometry']['coordinates'][1],
            longitude: item['geometry']['coordinates'][0],
            icon: 'lib/assets/icon/map/locate.png',
            markerName: item['properties']['name'],
            selected: item['properties']['id'] == currentId,
            onTap: () {
              setState(() {
                currentId = item['properties']['id'];
              });
            }));
        setState(() {
          _markerColor = Color(0XFF00b081);
          _markers = _markers;
        });
      });
    }
  }

  // 监测设备
  void _getMonitorDevice() async {
    var response = await Request().get(Api.url['monitorDevice']);
    if (response['code'] == 200) {
      List data = response['data']['features'];
      if (data.length == 0) {
        ToastWidget.showToastMsg('未获取到监测设备数据');
      }
      data.forEach((item) {
        _markers.add(commonMaker(
            latiude: item['geometry']['coordinates'][1],
            longitude: item['geometry']['coordinates'][0],
            icon: 'lib/assets/icon/map/flue.png',
            markerName: item['properties']['name'],
            selected: item['properties']['id'] == currentId,
            onTap: () {
              setState(() {
                currentId = item['properties']['id'];
              });
            }));
        setState(() {
          _markerColor = Color(0XFF633D99);
          _markers = _markers;
        });
      });
    }
  }

  Marker commonMaker({
    required double latiude,
    required double longitude,
    required String icon,
    String? markerName,
    required bool selected,
    Function? onTap,
  }) {
    return Marker(
        height: px(160.0),
        width: px(160.0),
        anchorPos: AnchorPos.align(AnchorAlign.center),
        point: LatLng(latiude, longitude),
        builder: (ctx) => GestureDetector(
            onTap: (){
              onTap?.call();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: selected ? px(54.0) : px(42.0),
                  height: selected ? px(68.0) : px(52.0),
                  child: Image.asset(icon, fit: BoxFit.cover),
                ),
                Text('$markerName',
                    style: TextStyle(
                        fontSize: sp(26.0),
                        color: widget.commonMapType
                            ? Color(0XFFFFFFFF)
                            : Color(0XFFFFFFFF),
                        fontWeight: FontWeight.w600))
              ],
            )));
  }
}

/// 使用CachedNetworkImageProvider 实现地图缓存
class CachedTileProvider extends TileProvider {
  const CachedTileProvider();
  @override
  ImageProvider getImage(Coords<num> coords, TileLayerOptions options) {
    return CachedNetworkImageProvider(
      getTileUrl(coords, options),
    );
  }
}
