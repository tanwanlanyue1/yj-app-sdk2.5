import 'package:cs_app/model/data/data_jpush.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cs_app/components/ToastWidget.dart';
import 'package:cs_app/pages/ModuleAlarm/AlarmCenter.dart';
import 'package:cs_app/pages/ModuleInfo/InfoCenter.dart';
import 'package:cs_app/pages/ModuleMap/MapCenter.dart';
import 'package:cs_app/pages/ModuleMonitor/MonitorCenter.dart';
import 'package:cs_app/utils/screen/Adapter.dart';

class HomePage extends StatefulWidget {
  final Map? arguments;
  HomePage({this.arguments});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.arguments !=null && widget.arguments?['index'] != null ){
      _tabIndex = widget.arguments?['index'];
      _pageController = PageController(initialPage: _tabIndex,);
    }
    _initData();
    JpushData.isNotificationEnabled(context);
  }
  var _pageController = PageController();
  int _tabIndex = 0;  // 默认索引第一个tab 
  
  List tabTitles = ['首页', '预警', '监测', '信息'];   // 菜单文案  
 
  List tabIcons = [
    [
      Icon(Icons.map, size: 20.0,color: Color(0XFFB9B9B9)),
      Icon(Icons.map, size: 20.0,color: Color(0XFF4D7CFF)),
    ],
    [
      Icon(Icons.notifications_active, size: 20.0,color: Color(0XFFB9B9B9)),
      Icon(Icons.notifications_active, size: 20.0,color: Color(0XFF4D7CFF)),
    ],
    [
      Icon(Icons.show_chart, size: 20.0,color: Color(0XFFB9B9B9)),
      Icon(Icons.show_chart, size: 20.0,color: Color(0XFF4D7CFF)),
    ],
    [
      Icon(Icons.date_range, size: 20.0,color: Color(0XFFB9B9B9)),
      Icon(Icons.date_range, size: 20.0,color: Color(0XFF4D7CFF)),
    ]
  ];

  List<StatefulWidget> _pageList = [];
  void _initData() {
    int index1 = 0;
    if(widget.arguments !=null && widget.arguments?['index1'] != null  ){
      index1 = widget.arguments?['index1'];
    }
    _pageList = [
      new MapCenter(),
      new AlarmCenter(index:index1),
      new MonitorCenter(),
      new InfoCenter(),
    ];
  }

  // 获取图标
  Icon getTabIcon(int curIndex) {
    if (curIndex == _tabIndex) {
      return tabIcons[curIndex][1];
    }
    return tabIcons[curIndex][0];
  }

  // 获取标题文本
  Text getTabTitle(int curIndex) {
    return new Text(
      tabTitles[curIndex],
      style: curIndex == _tabIndex ? TextStyle(color: Color(0XFF4D7CFF)) : TextStyle(color: Color(0XFFB9B9B9))
    );
  }

  // 获取BottomNavigationBarItem
  List<BottomNavigationBarItem> getBottomNavigationBarItem() {
    List<BottomNavigationBarItem> list = [];
    for (int i = 0; i < this.tabTitles.length; i++) {
      list.add(
        new BottomNavigationBarItem(
          icon: getTabIcon(i),
          title: getTabTitle(i)
        )
      );
    }
    return list;
  }

  // 监听首页返回
  int _popTrue = 0;
  Future<bool> _onWillPop() {
    _popTrue = _popTrue+1;
    ToastWidget.showToastMsg('再按一次退出园区预警');
    if( _popTrue ==3 ) { pop(); }
    return Future.delayed(Duration(seconds: 2), () {
      _popTrue = 1;
      setState(() {});
      return false;
    });
  }
  static Future<void> pop() async {
    await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(BoxConstraints(maxWidth: MediaQuery.of(context).size.width, maxHeight: MediaQuery.of(context).size.height), designSize: Size(Adapter.designWidth, Adapter.designHeight), orientation: Orientation.portrait);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: PageView.builder(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          itemCount: _pageList.length,
          itemBuilder: (context, index) => _pageList[index]
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: getBottomNavigationBarItem(),
          type: BottomNavigationBarType.fixed,
          currentIndex: _tabIndex,
          onTap: (index) {
            _pageController.jumpToPage(index);
            setState(() {_tabIndex = index;});
          },
        )
      ),
    );
  }
}