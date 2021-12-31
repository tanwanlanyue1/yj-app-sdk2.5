import 'package:cs_app/components/ToastWidget.dart';
import 'package:cs_app/model/data/data_global.dart';
import 'package:cs_app/model/data/data_jpush.dart';
import 'package:cs_app/pages/ModuleUser/UpdateApp.dart';
import 'package:flutter/material.dart';
import 'package:cs_app/api/Api.dart';
import 'package:cs_app/api/Request.dart';
import 'package:cs_app/pages/ModuleMap/components/AlarmInfo.dart';
import 'package:cs_app/pages/ModuleMap/components/MapWidget.dart';
import 'package:cs_app/pages/ModuleMap/components/RightMenu.dart';
import 'package:cs_app/utils/screen/Adapter.dart';
import 'package:cs_app/utils/screen/screen.dart';
import 'package:cs_app/utils/storage/data_storageKey.dart';
import 'package:cs_app/utils/storage/storage.dart';

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

  List iconList = [
    {'icon':'lib/assets/icon/map/one.png','name':'一级警情'},
    {'icon':'lib/assets/icon/map/two.png','name':'二级警情'},
    {'icon':'lib/assets/icon/map/three.png','name':'三级警情'},
    {'icon':'lib/assets/icon/map/four.png','name':'四级警情'},
  ];

  // 获取警情消息
  void _getRealTimeAlarm() async{
    var response = await Request().get(Api.url['realtimeAlarm']);
    if(response['code'] == 200) {
      List data = response['data'];
      showAlarm(data);
    }
  }

  // 是否开启警情推送
  void _openPush() async{
    if(Global.showAlarm == true){
      JpushData.deleteTags(['app']);
      JpushData.stopPush();
      ToastWidget.showToastMsg('已关闭告警消息推送通知');
      Global.changeShowAlarm(show: false);
    }else{
      JpushData.resumePush();
      Future.microtask(() {
        Future.delayed(Duration(milliseconds: 1000), () {
          JpushData.setTags(['app']);
        });
      });
      ToastWidget.showToastMsg('已开启告警消息推送通知');
      Global.changeShowAlarm(show: true);
    }
    setState(() {});
  }
  
  @override
  void initState() {
    super.initState();
    // 获取警情消息
    if(!Global.showAlarmToast){ _getRealTimeAlarm();}
  }

  //告警消息推送
  showAlarm(List realAlarm){
    if (StorageUtil().getBool(StorageKey.showAlarm) == true) {
      Global.showAlarmToast = true;
      Future.microtask(() {
        showDialog<Null>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return GestureDetector(
                onTap: () {Navigator.pop(context);},
                child: Material(
                  color: Color.fromRGBO(0, 0, 0, 0.5),
                  child:  AlarmInfo(realAlarm),
                )
            );},
        );
      });
    }
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
          if(_currentLayerType == 'station') Positioned(
            left: px(20.0),
            bottom: px(20.0),
            child: Column(
              children: iconList.map((item){
                 return Row(
                    children: [
                      SizedBox(
                        width: px(45.0),
                        height: px(55.0),
                        child: Image.asset(item['icon'], fit: BoxFit.cover),
                      ),
                      Text('：${item['name']}',style: TextStyle(color: Colors.white,fontSize: sp(27)),),
                    ],
                  );
              }).toList()
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
                    '长寿园区预警',
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
            GestureDetector(
                onDoubleTap: _openPush,
                child: IconButton(
                  icon: Icon(
                    Icons.notifications_active,
                    size: sp(50.0),
                    color: Global.showAlarm  == true ? Colors.red : Colors.white,
                  ),
                  tooltip: '警情消息',
                  onPressed:(){}
                )
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
          _currentLayerType = index;
          setState(() {});
        },
        mapType: (type) {
          _commonMapType = type;
          setState(() {});
        }
    );
  }
}