import 'package:flutter/material.dart';
import 'package:scet_app/pages/dataModule/StationLayout/Device.dart';
import 'package:scet_app/pages/dataModule/StationLayout/Matter.dart';
import 'package:scet_app/pages/dataModule/StationLayout/Record.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';

class StationDetails extends StatefulWidget {
  final arguments;
  StationDetails({this.arguments});

  @override
  _StationDetailsState createState() => _StationDetailsState();
}

class _StationDetailsState extends State<StationDetails> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  List _tabs = ["物质", "设备", "记录"];

  List<Widget>? _bodyList;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
    _bodyList= [
      Matter(stId: widget.arguments['stId']),
      Device(stId: widget.arguments['stId']),
      Record(stId: widget.arguments['stId']),
    ];
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _buildTabBarView()
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      toolbarHeight: px(148),
      title: Text(
        "${widget.arguments['stName']}",
        style: TextStyle(
          fontSize: sp(36.0)
        ),
      ),
      elevation: 0,
      centerTitle: true,
      bottom: _buildTabBar()
    );
  }

  ///构造 TabBar
  PreferredSizeWidget _buildTabBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(px(64.0)),
      child: Material(
        color: Colors.white,
        child: Container(
          height: px(64.0),
          child: TabBar(
              isScrollable: false,
              unselectedLabelColor: Color(0xff2E3033), //false 平分宽度，true 自适应宽度
              unselectedLabelStyle: TextStyle(fontSize: sp(26.0)),
              //设置tab选中文字的样式
              labelStyle: TextStyle(fontSize: sp(26), fontWeight: FontWeight.bold),
              labelColor: Color(0xff4D7CFF),
              indicatorColor: Color(0xff4D7CFF),
              indicatorPadding: EdgeInsets.only(
                left: px(5.0),
                right: px(5.0),
              ),
              //TabBarIndicatorSize.label跟文字等宽,TabBarIndicatorSize.tab跟每个tab等宽
              indicatorSize: TabBarIndicatorSize.label,
              controller: _tabController,
              tabs: _tabs.map((e) => Tab(text: e)).toList()),
        ),
      ),
    );
  }

  ///构造 TabBarView
  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: _bodyList!
    );
  }
}
