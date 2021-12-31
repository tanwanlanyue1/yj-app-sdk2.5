import 'package:scet_dz/pages/ModuleUser/UpdateApp.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scet_dz/api/Api.dart';
import 'package:scet_dz/api/Request.dart';
import 'package:scet_dz/model/provider/provider_home.dart';
import 'package:scet_dz/pages/ModuleMap/components/AlarmInfo.dart';
import 'package:scet_dz/pages/ModuleMap/components/MapWidget.dart';
import 'package:scet_dz/pages/ModuleMap/components/RightMenu.dart';
import 'package:scet_dz/utils/screen/Adapter.dart';
import 'package:scet_dz/utils/screen/screen.dart';
import 'package:scet_dz/utils/storage/data_storageKey.dart';
import 'package:scet_dz/utils/storage/storage.dart';

class MapCenter extends StatefulWidget {
  @override
  _MapCenterState createState() => _MapCenterState();
}

class _MapCenterState extends State<MapCenter> with AutomaticKeepAliveClientMixin{
  
  // 重写状态函数
  @override
  bool get wantKeepAlive => true;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _commonMapType = false, _backPark = false;

  String _currentLayerType = 'station';
  int total = 0;

  // 获取警情消息
  List realAlarm = [];
  bool realAlarmState = false;
  void _getRealTimeAlarm() async{
    Map<String, dynamic> params = Map();
    params['type'] = 'realTime';
    params['pageNo'] = 1;
    params['pageSize'] = 10;
    var response = await Request().get(Api.url['table'], data: params);
    if(response['code'] == 200) {
      List data = response['data']['data'];
      total = response['data']['total'];
      realAlarm = data;
      setState(() {});
    }
  }

  // 站点接口
  _realStationInfo() async {
    var response = await Request().get(Api.url['realStationInfo']);
    if(response != null && response['code'] == 200){
      /** pc站點兼容操作**/
      response['data'].forEach((item){
        item['stId'] = item['oldId'];
      });
      //缓存站点数据
      StorageUtil().setJSON(StorageKey.RealStationInfo, response['data']);
      context.read<HomeModel>().getSiteList(response['data']);
      print('读取站点信息==>${StorageUtil().getJSON(StorageKey.RealStationInfo)}');
    }
  }

  @override
  void initState() {
    super.initState();
    // 获取警情消息
    _getRealTimeAlarm();
    // 获取站点数据
      _realStationInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
        appBar: _appBar(),
      endDrawer: _endDrawer(),
      body: Stack(
        children: <Widget>[
          // 地图
          MapWidget(
            commonMapType: _commonMapType,
            layerType: _currentLayerType,
            backPark: _backPark
          ),
          // 警情提示
          Visibility(
            visible: realAlarmState,
            child: Positioned(
              top: px(16.0),
              right: px(40.0),
              child: AlarmInfo(
              realAlarm: realAlarm,
              params: total,
            ),
            )
          ),
          Positioned(
            right: px(20.0),
            bottom: MediaQuery.of(context).size.height * 0.18,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      _scaffoldKey.currentState?.openEndDrawer();
                    },
                    child: Container(
                      height: px(75.0),
                      width: px(75.0),
                      child: Image.asset(
                        'lib/assets/images/switch_menu.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                // 返回园区
                GestureDetector(
                  child: ClipOval(
                    child: Container(
                      width: px(75.0),
                      height: px(75.0),
                      color: Color(0XFFFFFFFF),
                      child: Icon(Icons.reply,  size: sp(40.0), color: Color(0XFF1D7DFE),)
                    ),
                  ),
                  onTap: () {
                    this.setState(() {
                      _backPark = !_backPark;
                    });
                  },
                ),
              ],
            ),
          ),
          Positioned(
            child: UpdateApp()
          ),
        ],
      )
    );
  }
  //头部
  PreferredSizeWidget _appBar(){
    return PreferredSize(
      preferredSize: Size(Adapt.screenW(), px(Adapter.topBarHeight)),
      child: AppBar(
        title: Row(
          children: <Widget>[
            Container(
              height: px(50.0),
              width: px(50.0),
              child: Image.asset(
                'lib/assets/images/logo.png',
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 5.0),
              child: Text(
                  '刁镇园区预警',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: sp(40.0)
                  )
              ),
            )
          ],
        ),
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.notifications_active,
              size: sp(50.0),
              color: realAlarm.length > 0 ? Colors.red : Colors.white,
            ),
            tooltip: '警情消息',
            onPressed: () {
              this.setState(() {
                realAlarmState = !realAlarmState ? true : false;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.person, size: sp(50.0)),
            tooltip: '个人中心',
            onPressed: () {
              Navigator.pushNamed(context, '/mine');
            },
          )
        ],
      ),
    );
  }
  //抽屉
  Widget _endDrawer(){
    return RightMenu(
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
        }
    );
  }
}