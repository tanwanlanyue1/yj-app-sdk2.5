import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:scet_app/components/Search.dart';
import 'package:scet_app/components/CasingPly.dart';
import 'package:scet_app/utils/api/Api.dart';
import 'package:scet_app/utils/api/Request.dart';
import 'package:scet_app/utils/tool/easyRefresh/easyRefreshs.dart';
import 'package:scet_app/utils/tool/screen/Adapter.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';
import 'dart:math' as math;

/// 页面状态
enum typeStatus {
  onRefresh, // 刷新
  onLoad // 加载
}

class MonitorStation extends StatefulWidget {
  @override
  _MonitorStationState createState() => _MonitorStationState();
}

class _MonitorStationState extends State<MonitorStation> {

  EasyRefreshController _controller = EasyRefreshController(); // 上拉组件控制器

  List stationList; // 站点信息
  List _searchList; // 搜索的数组

  _realStationInfo() async{
    var response = await Request().get(Api.url['realStationInfo']);
    if(response['code'] == 200) {
      List data = response['data'];
      _dataSwitch(data);
      _controller.resetLoadState();
      _controller.finishRefresh();
      _controller.finishLoad(noMore: true);
    }
  }

  // 抽离公共的数据转换部分
  _dataSwitch(List data){
    data.forEach((item) {
      Map weather = {};
      item['facInfo'].forEach((facItem) {
        switch (facItem['type']) {
          case 'ws': weather.addAll({facItem['type']: facItem['value']}); break;
          case 'wd': weather.addAll({facItem['type']: facItem['value'],'explain': facItem['explain']}); break;
          case 'temp': weather.addAll({facItem['type']: facItem['value']}); break;
          case 'rh': weather.addAll({facItem['type']: facItem['value']}); break;
          case 'ap': weather.addAll({facItem['type']: facItem['value']}); break;
        }
      });
      item['weather'] = weather;
    });
    _realFactorNumber(data);
  }

  _realFactorNumber(List stationData) async{
    var response = await Request().get(Api.url['realFactorNum']);
    if(response['code'] == 200) {
      List data = response['data'];
      stationData.forEach((station) {
        station['facSum'] = 0;
        data.forEach((items) {
          if(station['stId'] == items['stId']) {
            station['facSum'] = items['factorSum'];
          } 
        });
      });
      stationData.sort((a, b) {
        return int.parse(b['facSum'].toString()).compareTo(int.parse(a['facSum'].toString()));
      });
      this.setState(() {
        stationList = stationData;
        _searchList = stationData;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _realStationInfo();
  }

  //  文字改变触发搜索回调
  _search(String value){
    stationList =  _searchStrig(value.trim());
    setState(() {});
  }
  //搜索事件的处理
  List _searchStrig(value){
    List _newList = [];
    _searchList.forEach((item) {
      if((item['stName'].contains(value))){
        _newList.add(item);
      }
    });
    return _newList;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(Adapt.screenW(), px(Adapter.topBarHeight)),
        child: AppBar(
          title: Text(
            '监测站点', 
            style: TextStyle(
              color: Colors.white,
              fontSize: sp(Adapter.appBarFontSize)
            )
          ),
          elevation: 0,
          centerTitle: true
        ),
      ),
      body: Column(
        children: [
          Search(
            textFieldColor: Color(0xffEFF0F4),
            bgColor: Colors.white,
            search:(value){
              _search(value);
            }
          ),
          // 站点列表
          Expanded(
            child:  stationList == null 
            ?
              CasingPly.casingPly2()  // 骨架屏
            :
              Container(
                padding: EdgeInsets.fromLTRB(px(20.0), 0.0, px(20.0), px(0.0)),
                child: EasyRefresh.custom(
                  enableControlFinishRefresh: true,
                  enableControlFinishLoad: true,
                  topBouncing: true,
                  controller: _controller,
                  taskIndependence: false,
                  reverse: false,
                  // firstRefresh:true,
                  footer: null,
                  header: headers(),
                  onLoad:  null,
                  onRefresh: () async {
                    _realStationInfo();
                  },
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        Map data = stationList[index];
                        return InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/StationDetails',arguments: data);
                          },
                          child: _itemStationCard(data: data)
                        );
                      },
                      childCount: stationList.length),
                    ),
                    SliverPersistentHeader(
                      floating: false,//floating 与pinned 不能同时为true
                      pinned: true,
                      delegate: _SliverAppBarDelegate(
                        minHeight: px(100),
                        maxHeight: px(100),
                        child: Visibility(
                          visible: stationList.length > 0,
                          child: Container(
                            padding: EdgeInsets.only(top: px(24.0)),
                            child: Text(
                              '到底啦~',
                              style: TextStyle(
                                color: Color(0X99A1A6B3),
                                fontSize: sp(22.0)
                              ),
                              textAlign: TextAlign.center,
                            )
                          )
                        )
                      ),
                    )
                  ],
                ),
              )
          )
        ],
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  Widget _itemStationCard({Map data}) {
    return Card(
      color: Color(0XFFFFFFFF),
      margin: EdgeInsets.only(top: px(24.0)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(px(16.0)))
      ),
      child: Container(
        width: Adapt.screenW(),
        padding: EdgeInsets.fromLTRB(px(24.0), px(18.0), px(24.0), 0.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${data['stName']}',
                  style: TextStyle(
                    fontSize: sp(30.0),
                    color: Color(0XFF4D7CFF),
                    fontFamily: "M"
                  )
                ),
                Container(
                  width: px(100.0),
                  height: px(36.0),
                  margin: EdgeInsets.only(right: px(8.0)),
                  decoration: BoxDecoration(
                    color: data['status'] == 1 ? Color(0XFF668FFF) : Colors.red,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(px(12.0)), 
                      bottomRight: Radius.circular(px(12.0))
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${data['status'] == 0 ? '停用' : '正常'}',
                      style: TextStyle(
                        color: Color(0XFFFFFFFF), 
                        fontSize: sp(24.0),
                      ),
                      textAlign: TextAlign.center,
                    )
                  )
                )
              ]
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _itemWeatherData(value: '${data['weather']['temp'] ?? '-'}°', name: '气温', type: 1),
                      _itemWeatherData(value: '${data['weather']['explain'] ?? '-'}', name: '风向', type: 0),
                      _itemWeatherData(value: '${data['weather']['ws'] ?? '-'} m/s', name: '风速', type: 1),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(px(70.0),px(24.0), 0.0, 0.0),
                  width: px(200.0),
                  height: px(150.0),
                  padding: EdgeInsets.fromLTRB(px(20.0), px(10.0), 0.0, 0.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(px(10.0))),
                    image: DecorationImage(
                      image: AssetImage('assets/images/monitor/factor_bg.png'),
                      fit: BoxFit.fill,
                    )
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(text: '${data['facSum']}',
                          style: TextStyle(
                            fontSize: sp(46.0), 
                            color: Color(0XFFFFFFFF),
                            fontFamily: "B"
                          ),
                          children: <TextSpan>[
                            TextSpan(text: ' 种', 
                              style: TextStyle(
                                fontSize: sp(22.0),
                                fontFamily: "M"
                              )
                            )
                          ],
                        ),
                      ),
                      Text(
                        '监测物质',
                        style: TextStyle(
                          fontSize: sp(24.0),
                          color: Color(0XFFFFFFFF)
                        )
                      )
                    ]
                  )
                )
              ]
            )
          ]
        ),
      )
    );
  }

  Widget _itemWeatherData({String value, String name, int type}) {
    return Expanded(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${value.contains('m/s') ? value.replaceAll('m/s','') : value}',
                  style: TextStyle(
                    fontFamily: type == 0 ? "M" : 'B',
                    fontSize: type == 0 ? sp(30.0) : sp(38.0),
                    color: Color(0XFF2E2F33),
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                )
              ),
              if(value.contains('m/s')) Padding(
                padding: EdgeInsets.only(top: px(10),),
                child: Text(
                  'm/s',
                  style: TextStyle(
                    fontSize: sp(25.0),
                    fontFamily: "M",
                    color: Color(0XFF2E2F33),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top:px(8.0)),
            child: Text(
              '$name',
              style: TextStyle(
                fontSize: sp(24.0),
                color: Color(0XFFA8ABB3)
              )
            ),
          )
        ]
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}