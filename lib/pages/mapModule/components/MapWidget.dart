import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:scet_app/model/provider/provider.dart';
import 'package:scet_app/utils/api/Api.dart';
import 'package:scet_app/utils/api/Request.dart';
import 'package:scet_app/utils/tool/gpsUtil/GpsUtil.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';
import 'package:provider/provider.dart';

class MapWidget extends StatefulWidget {
  final bool commonMapType;
  final bool? backPark;
  final String? layerType;
  final bottomDrag;
  MapWidget(
      {required this.commonMapType, this.backPark, this.layerType, this.bottomDrag});

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  FocusNode blankNode = FocusNode();

  MapController _mapController = MapController();

  LatLng _centerPoint = LatLng(38.3561794136, 117.5764233573);

  double _mapZoom = 12.5;

  var currentId;

  List<Marker> _markers = [];
  Color _markerColor = Color(0XFFFFFFFF);
  final PopupController _popupController = PopupController();

  void _switchLayer(String type) {
    _markers.clear();
    switch (type) {
      case 'station':
        print('初始站点坐标');
        break;
      case 'enterprise':
        _getEnterprise();
        break;
      case 'riskSource':
        _getRiskSource();
        break;
      case 'sensitive':
        _getSensitive();
        break;
      case 'wastePoint':
        _getWastePoint();
        break;
    }
  }

  // 获取园区范围
  List _polylines = [];
  void _getParkBorder() async {
    var response = await Request().get(Api.url['parkBorder']);
    if (response['code'] == 200) {
      List border = response['data']['features'][0]['geometry']['coordinates'];
      for (var i = 0; i < border.length; i++) {
        List itemData = border[i][0];
        List<LatLng> polylinesArray = [];
        for (var j = 0; j < itemData.length; j++) {
          List position =
              GpsUtil.gps84_To_Gcj02(itemData[j][1], itemData[j][0]);
          polylinesArray.add(LatLng(position[0], position[1]));
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
    // TODO: implement initState
    super.initState();
    _getParkBorder();
    _switchLayer(widget.layerType!);
  }

  @override
  void didUpdateWidget(MapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 切换图层
    String oldLayerIndex = oldWidget.layerType!;
    String newLayerIndex = widget.layerType!;
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
              widget.bottomDrag.currentState.setBottomState(false);
              FocusScope.of(context).requestFocus(blankNode);
            }
            ),
        layers: [
          TileLayerOptions(
            urlTemplate:
                'https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
            additionalOptions: {
              'accessToken':
                  'pk.eyJ1IjoibGVtb25zY2V0IiwiYSI6ImNramk3bGE5eDE3ZDUycm83aXMzajBzZGwifQ.MU0fybBa0127PbYREKzvDA',
              'id': 'mapbox.satellite',
            },
            tileProvider: CachedTileProvider(), //启用地图缓存
          ),
          PolylineLayerOptions(
            polylines: _polylines
                .map((item) => (Polyline(
                    points: item, strokeWidth: 2.0, color: Color(0XFF3093DA))))
                .toList(),
          ),
          widget.layerType == 'station' || _markers.length == 0
              ? MarkerLayerOptions(markers: _stationPointList())
              : MarkerClusterLayerOptions(
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
                )
        ]);
  }

  // 获取站点数据
  List<Marker> _stationPointList() {
    var _homeModel = Provider.of<HomeModel>(context, listen: true);
    List? data = _homeModel.siteList;
    return data !=null ? data.map((item) {
      // print('=0=${item['location']['latiude']}');
      // print('=1=${item['location']['longitude'] == ''} ');
      List position = GpsUtil.gps84_To_Gcj02(
          double.parse(item['location']['latiude'] == ''
              ? '0.0'
              : item['location']['latiude']),
          double.parse(item['location']['longitude'] == ''
              ? '0.0'
              : item['location']['longitude']));
      return commonMaker(
          latiude: position[0],
          longitude: position[1],
          icon: 'assets/icon/map/station.png',
          markerName: item['stName'],
          selected: item['stId'] == currentId,
          onTap: () {
            widget.bottomDrag.currentState.setBottomState(true);
            setState(() {
              currentId = item['stId'];
            });
          });
    }).toList():[];
  }

  // 获取企业
  void _getEnterprise() async {
    var response = await Request().get(Api.url['company']);
    if (response['code'] == 200) {
      List data = response['data']['features'];
      data.forEach((item) {
        List position = GpsUtil.gps84_To_Gcj02(
            item['geometry']['coordinates'][1],
            item['geometry']['coordinates'][0]);
        _markers.add(commonMaker(
            latiude: position[0],
            longitude: position[1],
            icon: 'assets/icon/map/enterprise.png',
            markerName: item['properties']['shortName'],
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

  // 获取风险物质
  void _getRiskSource() async {
    var response = await Request().get(Api.url['riskSource']);
    if (response['code'] == 200) {
      List data = response['data']['features'];
      data.forEach((item) {
        List position = GpsUtil.gps84_To_Gcj02(
            item['geometry']['coordinates'][1],
            item['geometry']['coordinates'][0]);
        _markers.add(commonMaker(
            latiude: position[0],
            longitude: position[1],
            icon: 'assets/icon/map/riskSource.png',
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
  void _getSensitive() async {
    var response = await Request().get(Api.url['sensitive']);
    if (response['code'] == 200) {
      List data = response['data']['features'];
      data.forEach((item) {
        List position = GpsUtil.gps84_To_Gcj02(
            item['geometry']['coordinates'][1],
            item['geometry']['coordinates'][0]);
        _markers.add(commonMaker(
            latiude: position[0],
            longitude: position[1],
            icon: 'assets/icon/map/locate.png',
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

  // 废气排口
  void _getWastePoint() async {
    var response = await Request().get(Api.url['wastePoint']);
    if (response['code'] == 200) {
      List data = response['data']['features'];
      data.forEach((item) {
        List position = GpsUtil.gps84_To_Gcj02(
            item['geometry']['coordinates'][1],
            item['geometry']['coordinates'][0]);
        _markers.add(commonMaker(
            latiude: position[0],
            longitude: position[1],
            icon: 'assets/icon/map/flue.png',
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
                            ? Color(0XFF45474D)
                            : Color(0XFFFFFFFF),
                        fontWeight: FontWeight.w600))
              ],
            )));
  }
}

//  使用CachedNetworkImageProvider 实现地图缓存
class CachedTileProvider extends TileProvider {
  const CachedTileProvider();
  @override
  ImageProvider getImage(Coords<num> coords, TileLayerOptions options) {
    return CachedNetworkImageProvider(
      getTileUrl(coords, options),
      //Now you can set options that determine how the image gets cached via whichever plugin you use.
    );
  }
}
