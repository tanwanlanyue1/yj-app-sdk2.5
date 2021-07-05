import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scet_app/components/Search.dart';
import 'package:scet_app/model/provider/provider.dart';
import 'package:scet_app/pages/mapModule/components/BotttomDrag.dart';
import 'package:scet_app/pages/mapModule/components/MapWidget.dart';
import 'package:scet_app/pages/mapModule/components/RightMenu.dart';
import 'package:scet_app/pages/mapModule/components/WarnCard.dart';
import 'package:scet_app/utils/api/Api.dart';
import 'package:scet_app/utils/api/Request.dart';
import 'package:scet_app/utils/tool/colorTheme/colorTheme.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';
import 'package:scet_app/utils/tool/storage/data_storageKey.dart';
import 'package:scet_app/utils/tool/storage/storage.dart';

enum cardType { List, card }

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with AutomaticKeepAliveClientMixin {
  // 重写状态函数
  @override
  bool get wantKeepAlive => true;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _commonMapType = true, _backPark = false;

  String _currentLayerType = 'station';

  var _bottomType = cardType.List; //列表模式

  List _alarmData = [
    {
      'stName': '建新子站',
      'facName': '一个物质名称',
      'materials': '二氯甲烷',
      'value': '23.4563mg/m³',
      'warn': {'level': 1, 'thresholdValue': '1'},
      'eventStatus': '0',
      'time': '2019-02-01 13:00:00',
    },
    {
      'stName': '建新子站',
      'facName': '一个物质名称',
      'materials': '二氯甲烷',
      'value': '23.4563mg/m³',
      'warn': {'level': 1, 'thresholdValue': '1'},
      'eventStatus': '1',
      'time': '2019-02-01 13:00:00',
    },
    {
      'stName': '建新子站',
      'facName': '一个物质名称',
      'materials': '二氯甲烷',
      'value': '23.4563mg/m³',
      'warn': {'level': 2, 'thresholdValue': '1'},
      'eventStatus': '2',
      'time': '2019-02-01 13:00:00',
    },
  ]; //警情数据

  @override
  void initState() {
    super.initState();
    if (StorageUtil().getJSON(StorageKey.RealStationInfo) != null) {
      print('缓存中的站点==>${StorageUtil().getJSON(StorageKey.RealStationInfo)}');
      StorageUtil().getJSON(StorageKey.RealStationInfo);
      Future.microtask(() => context
          .read<HomeModel>()
          .getSiteList(StorageUtil().getJSON(StorageKey.RealStationInfo)));
    } else {
      _realStationInfo();
    }
  }

  // 站点接口
  _realStationInfo() async {
    var response = await Request().get(Api.url['realStationInfo']);
    if (response != null && response['code'] == 200) {
      //缓存站点数据
      StorageUtil().setJSON(StorageKey.RealStationInfo, response['data']);
      context.read<HomeModel>().getSiteList(response['data']);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        key: _scaffoldKey,
        endDrawer: RightMenu(
            commonMapType: _commonMapType,
            layerType: _currentLayerType,
            layerData: (index) {
              setState(() {
                _currentLayerType = index;
              });
            },
            mapType: (type) {
              this.setState(() {
                _commonMapType = type;
              });
            }),
        body: BottomDragWidget(
            key: BottomDragWidgetKey,
            body: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Container(
                width: px(750.0),
                height: Height(1234.0), //减首页导航100 用拉伸适配所有机型的剩余高度(px不拉伸会有空隙)
                color: Colors.brown,
                child: Stack(children: <Widget>[
                  // 地图
                  MapWidget(
                      commonMapType: _commonMapType,
                      layerType: _currentLayerType,
                      backPark: _backPark,
                      bottomDrag: BottomDragWidgetKey),
                  _taskNotification(),
                  _postions()
                ]),
              ),
            ),
            dragContainer: DragContainer(
              drawer: getListView(),
              defaultShowHeight: px(370.0),
              height: Height(1172.0),
            )));
  }

  //  首页顶部任务提醒
  Widget _taskNotification() {
    return Positioned(
        left: px(20.0),
        top: appTopPadding(context) + px(20.0),
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/MyBacklog');
          },
          child: Container(
            width: px(710.0),
            height: px(64.0),
            decoration: BoxDecoration(
                color: Color(0XFFFFFFFF),
                borderRadius: BorderRadius.circular(px(8.0))),
            padding: EdgeInsets.only(left: px(16.0)),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(right: px(22.0)),
                  child: Image.asset(
                    'assets/icon/other/task.png',
                    width: px(34),
                    height: px(40),
                  ),
                ),
                Text(
                  '您有3条任务需要处理',
                  style:
                      TextStyle(fontSize: sp(28.0), color: Color(0xff4D7CFF)),
                ),
                Spacer(),
                Icon(
                  Icons.keyboard_arrow_right,
                  size: px(50.0),
                  color: Color(0xff4D7CFF),
                )
              ],
            ),
          ),
        ));
  }

  //  首页定位按钮
  Widget _postions() {
    return Consumer<HomeModel>(
        builder: (context, homeModel, child) => Positioned(
              right: px(24.0),
              bottom: homeModel.showBottom ? px(370.0) : px(20.0),
              child: Container(
                width: px(170.0),
                height: px(300.0),
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.topRight,
                        child: Container(child: Builder(builder: (context) {
                          return GestureDetector(
                            child: Container(
                              width: px(74.0),
                              height: px(74.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(px(37.0)),
                              ),
                              child:
                                  Image.asset('assets/images/home/layer.png'),
                            ),
                            onTap: () {
                              Scaffold.of(context).openEndDrawer();
                            },
                          );
                        })),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () {
                            this.setState(() {
                              _backPark = !_backPark;
                            });
                          },
                          child: Container(
                            child: Container(
                              width: px(74.0),
                              height: px(74.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(px(37.0)),
                              ),
                              child:
                                  Image.asset('assets/icon/map/locations.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Visibility(
                          visible: homeModel.showBottom,
                          child: Container(
                            alignment: Alignment.topCenter,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (_bottomType == cardType.List) {
                                    _bottomType = cardType.card;
                                  } else {
                                    _bottomType = cardType.List;
                                  }
                                });
                              },
                              child: Container(
                                child: Container(
                                  width: px(170.0),
                                  height: px(48.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.circular(px(24.0)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.credit_card,
                                        size: sp(28.0),
                                        color: _bottomType == cardType.List
                                            ? Color(0xff4D7CFF)
                                            : Color(0xff848C99),
                                      ),
                                      Text(
                                        '  列表模式',
                                        style: TextStyle(
                                          fontSize: sp(20.0),
                                          color: _bottomType == cardType.List
                                              ? Color(0xff4D7CFF)
                                              : Color(0xff848C99),
                                          fontWeight:
                                              _bottomType == cardType.List
                                                  ? FontWeight.bold
                                                  : FontWeight.w500,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ));
  }

  // 上拉抽屉
  Widget getListView() {
    return Container(
      decoration: BoxDecoration(
        color: _bottomType == cardType.List
            ? Color(0xffffffff)
            : Color(0xffF2F4FA),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(px(25.0)),
            topRight: Radius.circular(px(25.0))),
      ),
      child: Column(
        children: <Widget>[_searchView(), Expanded(child: newListView())],
      ),
    );
  }

  // 上拉抽屉搜索部分
  Widget _searchView() {
    return Column(
      children: [
        Container(
          height: px(20.0),
          width: double.infinity,
          alignment: Alignment.bottomCenter,
          child: Container(
            width: px(60.0),
            height: px(8.0),
            decoration: BoxDecoration(
              color: Color(0xffDCDFE6),
              borderRadius: BorderRadius.circular(px(10.0)),
            ),
          ),
        ),
        Search(
          bgColor: _bottomType == cardType.List
              ? Color(0xffffffff)
              : Color(0xffF2F4FA),
          textFieldColor: _bottomType == cardType.List
              ? Color(0xffEFF0F4)
              : Color(0xffffffff),
          search: (value) {
            // print('==>$value');
          },
          hintText: '查找监测站点、企业',
        ),
      ],
    );
  }

  // 上拉内容部分
  Widget newListView() {
    return OverscrollNotificationWidget(
        child: Container(
      child: ListView.builder(
        padding: EdgeInsets.only(top: 0),
        itemBuilder: (BuildContext context, int index) {
          return _bottomType == cardType.List
              ? _typeList(index)
              : WarnCard(
                  data: _alarmData[index],
                ); // WarnCard 卡片模式
        },
        itemCount: _alarmData.length,
        physics: const ClampingScrollPhysics(),
      ),
    ));
  }

  // 列表模式
  Widget _typeList(int index) {
    return Container(
      height: px(100),
      margin: EdgeInsets.only(
        left: px(24),
        right: px(24),
      ),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: Color(0xffF5F6F7),
                  width: 1,
                  style: BorderStyle.solid))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                width: px(16),
                height: px(16),
                margin: EdgeInsets.only(right: px(12)),
                decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(px(8))),
              ),
              Text(
                '${_alarmData[index]['stName']} -- '
                '${_alarmData[index]['materials']}'
                '${_alarmData[index]['value']}'
                '超标${_alarmData[index]['warn']['thresholdValue']}倍',
                style: TextStyle(
                  color: Color(0xff2E3033),
                  fontSize: sp(28),
                ),
              ),
              Spacer(),
              GestureDetector(
                child: Icon(Icons.keyboard_arrow_right,
                    color: Color(0xff8A9099), size: sp(40)),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: px(28)),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(px(8))),
                child: Text(
                  '警告级 --${_alarmData[index]['warn']['level']}级 ',
                  style: TextStyle(
                    color: noticeColorTheme(_alarmData[index]['warn']['level']),
                    fontSize: sp(26),
                  ),
                ),
              ),
              Spacer(),
              GestureDetector(
                child: Text('${_alarmData[index]['time']}',
                    style:
                        TextStyle(fontSize: sp(24), color: Color(0xffC4C4C5))),
              ),
            ],
          )
        ],
      ),
    );
  }
}
