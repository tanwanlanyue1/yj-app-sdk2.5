import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scet_dz/components/ToastWidget.dart';
import 'package:scet_dz/pages/ModuleAlarm/AlarmCenter.dart';
import 'package:scet_dz/pages/ModuleInfo/InfoCenter.dart';
import 'package:scet_dz/pages/ModuleMap/MapCenter.dart';
import 'package:scet_dz/pages/ModuleMonitor/MonitorCenter.dart';
import 'package:scet_dz/utils/screen/Adapter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

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
    _pageList = [
      new MapCenter(),
      new AlarmCenter(),
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
      style: curIndex == _tabIndex 
        ? 
          TextStyle(color: Color(0XFF4D7CFF)) 
        : 
          TextStyle(color: Color(0XFFB9B9B9))
    );
  }

  // 获取BottomNavigationBarItem
  List<BottomNavigationBarItem> getBottomNavigationBarItem() {
    List<BottomNavigationBarItem> list = [];
    for (int i = 0; i < this.tabTitles.length; i++) {
      list.add(
        new BottomNavigationBarItem(
          icon: getTabIcon(i),
          // title: getTabTitle(i),
          label: tabTitles[i]
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
  void initState() {
    // TODO: implement initState
      _initData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(Adapter.designWidth, Adapter.designHeight),
        minTextAdapt: false,
        splitScreenMode: true,
        builder: (context, child) => WillPopScope(
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
                setState(() {
                  _tabIndex = index;
                });
              },
            )
        ),
      ));
  }
}