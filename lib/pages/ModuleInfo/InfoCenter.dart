import 'package:flutter/material.dart';
import 'package:cs_app/pages/ModuleInfo/Components/Report.dart';
import 'package:cs_app/pages/ModuleInfo/Components/StationInspection.dart';
import 'package:cs_app/utils/screen/Adapter.dart';
import 'package:cs_app/utils/screen/screen.dart';

class InfoCenter extends StatefulWidget {

  _InfoCenterState createState() => _InfoCenterState();
}

class _InfoCenterState extends State<InfoCenter> with SingleTickerProviderStateMixin{

  late TabController _tabController;
  
  List _tabTitles = ['报告', '巡检'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this,length: _tabTitles.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(Adapt.screenW(), px(Adapter.topBarHeight)),
        child: AppBar(
          title: Text(
            '信息中心', 
            style: TextStyle(
              color: Colors.white,
              fontSize: sp(40.0)
            )
          ),
          elevation: 0,
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add, size: sp(50.0),),
              tooltip: '添加巡检',
              onPressed: () { 
                Navigator.pushNamed(context, '/upload/inspection');
              }
            ),
          ]
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: <Widget>[
          Container(
            height: px(64.0),
            color: Colors.grey[100],
            child: DefaultTabController(
              length: _tabTitles.length,
              child: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorPadding: EdgeInsets.only(bottom: 5.0),
                isScrollable: false,
                labelColor: Colors.blue,
                labelStyle: TextStyle(
                  fontSize: sp(30.0)
                ),
                unselectedLabelColor: Colors.grey,
                tabs: _tabTitles.map((item) {
                  return Tab(text: item);
                }).toList()
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                Report(),
                StationInspection()
              ] 
            ),
          )
        ]
      ),
    );
  }
}