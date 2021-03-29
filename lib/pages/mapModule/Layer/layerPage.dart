import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:scet_app/pages/mapModule/Layer/danger.dart';
import 'package:scet_app/pages/mapModule/Layer/effluent.dart';
import 'package:scet_app/pages/mapModule/Layer/flue.dart';
import 'package:scet_app/pages/mapModule/Layer/sensitive.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';

class LayerPage extends StatefulWidget {
  final Map arguments;
  LayerPage({this.arguments});

  @override
  _LayerPageState createState() => _LayerPageState();
}

class _LayerPageState extends State<LayerPage> with SingleTickerProviderStateMixin {

  TabController tabController;

  List _tabs = ["风险物质", "敏感点位","废气排口", "废水排口"];

  List<Widget> _bodyList = [
    Dangers(),
    Sensitive(),
    Effluent(),
    Flue(),
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: _tabs.length,
      vsync: this,
      initialIndex: widget.arguments['index']);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  //当整个页面dispose时，记得把控制器也dispose掉，释放内存
  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //设置选项卡
      appBar: _appBar(),
      //设置选项卡对应的page
      body: buildBodyView(),
    );
  }
  ///选项卡
  Widget _appBar(){
    return  AppBar(
      //设置选项卡
      title: buildTabBar(),
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.white,
      leading:GestureDetector(
        onTap: () { Navigator.pop(context); },
        child: Icon(Icons.keyboard_arrow_left,color: Color(0xff4D7CFF),size: px(60)),
      )
    );
  }

  ///头部选项卡
  buildBodyView() {
    Widget tabBarBodyView = TabBarView(
      controller: tabController,
      physics:NeverScrollableScrollPhysics(),
      children:_bodyList
    );
    return tabBarBodyView;
  }

  ///构造 TabBar
  buildTabBar() {
    Widget tabBar = TabBar(
      //tabs 的长度超出屏幕宽度后，TabBar，是否可滚动
      //设置为false tab 将平分宽度，为true tab 将会自适应宽度
      isScrollable: true,
      //设置tab未选中得样式
      unselectedLabelColor: Color(0xff5C6066),
      unselectedLabelStyle: TextStyle(fontSize: sp(28)),
      //设置tab选中文字的样式
      labelStyle: TextStyle(fontSize: sp(30), fontWeight: FontWeight.bold),
      labelColor: Color(0xff4D7CFF),
      //指示器设置
      indicatorColor: Color(0xff4D7CFF),
      indicatorPadding: EdgeInsets.only(left: px(10), right: px(10), bottom: px(10)),
      //设置自定义tab的指示器，CustomUnderlineTabIndicator
      //indicatorWight 设置指示器厚度
      //indicatorSize  设置指示器大小计算方式
      ///指示器大小计算方式，TabBarIndicatorSize.label跟文字等宽,TabBarIndicatorSize.tab跟每个tab等宽
      indicatorSize: TabBarIndicatorSize.label,
      controller: tabController,
      tabs: _tabs.map((e) => Tab(text: e)).toList()
    );

    return tabBar;
  }
}
