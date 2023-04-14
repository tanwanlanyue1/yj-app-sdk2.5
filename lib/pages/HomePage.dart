import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scet_app/pages/mapModule/MapPage.dart';
import 'package:scet_app/pages/userModule/UserCenter.dart';
import 'package:scet_app/utils/tool/screen/Adapter.dart';
import 'package:scet_app/components/ToastWidget.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin{

  AnimationController? _ctrlAnimationCircle;

  PageController _pageController = PageController();

  bool _showAddModel = false;

  int _currentIndex = 0;
  int _PopTrue = 1;//记录返回次数 为3就是退出app
  List _pageViewList = [];

  void _initData() {
    _pageViewList = <StatefulWidget>[
      new MapPage(),
      new UserCenter()
    ];
  }

  // 生成Flow的数据
  List addArray = [
    {"name": "添加巡检", "icon": "assets/icon/add/maintenance.png", "path": "/add/xunjian"},
    {"name": "添加检修", "icon": "assets/icon/add/polling.png", "path": "/add/jianxiu"},
    {"name": "异常投诉", "icon": "assets/icon/add/complaints.png", "path": "/add/complaints"},
    {"name": "核查任务", "icon": "assets/icon/add/inspect_task.png", "path": "/task/inspect"},
    {"name": "监测任务", "icon": "assets/icon/add/monitor_task.png", "path": "/task/monitor"},
    {"name": "警情事件", "icon": "assets/icon/add/alarm_event.png", "path": "/alarm/industryCenter"},  //
  ];
  List<Widget> _buildFlowChildren() {
    return addArray.map((item) => Container(
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, item['path']);
        },
        child: Column(
          children: <Widget>[
            ClipOval(
              child: Container(
                width: Width(80.0),
                height: Width(80.0),
                child: Center(
                  child: Image.asset('${item['icon']}')
                )
              )
            ),
            Padding(
              padding: EdgeInsets.only(top: 5.0),
              child: Text(
                item['name'].toString(), 
                style: TextStyle(
                  color: Colors.white, 
                  fontSize: sp(24.0)
                )
              )
            ),
          ]
        )
      )
    )).toList();
  }

  @override
  void initState() {
    super.initState();
    _initData();
    _ctrlAnimationCircle = AnimationController(
      lowerBound: 0, 
      upperBound: 120, 
      duration: Duration(milliseconds: 300), 
      vsync: this
    );
    _ctrlAnimationCircle!.addListener(() => setState(() {}));
  }

  ///监听首页返回
  Future<bool> _onWillPop() {
    _PopTrue = _PopTrue + 1;
    ToastWidget.showToastMsg('再按一次退出园区预警');
    if(_PopTrue == 3 ) { pop(); }
    return Future.delayed(Duration(seconds: 2), () {
      _PopTrue = 1;
      return false;
    });
  }

  static Future<void> pop() async {
    await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

  @override
  void dispose() {
    _ctrlAnimationCircle!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: PageView.builder(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          itemCount: _pageViewList.length,
          itemBuilder: (context, index) => Stack(
            children: <Widget>[
              _pageViewList[index],
              Positioned(
                child: _showAddModel ? Opacity(
                  opacity: 0.8,
                  alwaysIncludeSemantics: true,
                  child: Container(
                    color: Color(0X99000000),
                    width: Adapt.screenW(),
                    height: Adapt.screenH()
                  )
                ) : Container()
              ),
              Positioned(
                child: Container(
                  width: Adapt.screenW(),
                  height: Adapt.screenH(),
                  child: Flow(
                    delegate: FlowAnimatedCircle(_ctrlAnimationCircle!.value),
                    children: _buildFlowChildren(),
                  ),
                )
              )
            ]
          )
        ),
        bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          child: Container(
            height: Height(Adapter.bottomBarHeight),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _buildItemMenu(
                  index: 0, 
                  commonImage: 'assets/icon/bottomMenu/tab_index.png', 
                  activeImage: 'assets/icon/bottomMenu/tab_index_active.png'
                ),
                _buildItemMenu(
                  index: -1, 
                  commonImage: 'assets/icon/bottomMenu/tab_add.png', 
                  activeImage: 'assets/icon/bottomMenu/tab_add_close.png'
                ),
                _buildItemMenu(
                  index: 1, 
                  commonImage: 'assets/icon/bottomMenu/tab_mine.png', 
                  activeImage: 'assets/icon/bottomMenu/tab_mine_active.png'
                ),
              ],
            ),
          ),
        )
      ),
    );

  }

  Widget _buildItemMenu({int? index, required String commonImage, required String activeImage}) {
    Widget menuItem = SizedBox();

    if (index != -1) {
      menuItem = GestureDetector(
        onTap: () {
          if (index != _currentIndex) {
            _ctrlAnimationCircle!.reverse();
            _pageController.jumpToPage(index!);
            setState(() {
              _showAddModel = false;
              _currentIndex = index;
            });
          }
        },
        child: Image.asset(
          _currentIndex == index ? activeImage : commonImage, 
          width: px(60.0),
          height: px(98.0),
          fit: BoxFit.cover
        )
      );
    } else {
      menuItem = GestureDetector(
        onTap: () {
          if(_ctrlAnimationCircle!.status == AnimationStatus.completed) {
            setState(() {
              _ctrlAnimationCircle!.reverse();
              Future.delayed(Duration(milliseconds: 300), (){
                setState(() {
                  _showAddModel = false;
                });
              });
            });
          } else {
            setState(() {
              _showAddModel = true;
              _ctrlAnimationCircle!.forward();
            });
          }
        },
        child: Image.asset(
          _showAddModel ? activeImage : commonImage, 
          width: px(76.0),
          height: px(76.0),
          fit: BoxFit.cover
        )
      );
    }
    return menuItem;
  }
}

class FlowAnimatedCircle extends FlowDelegate {
  final double radius;
  FlowAnimatedCircle(this.radius);

  @override
  void paintChildren(FlowPaintingContext context) {
    if (radius == 0) {
      return;
    }
    var height = context.size.height - 70;
    double x = 0, y = 0;
    for (int i = 0; i < context.childCount; i++) {
      x = radius * cos(i * pi / (context.childCount - 1)); 
      y = radius * sin(i * pi / (context.childCount - 1)) - height;
      context.paintChild(i, transform: Matrix4.translationValues(x, -y, 0));
    }
  }

  @override
  bool shouldRepaint(FlowDelegate oldDelegate) => true;
}