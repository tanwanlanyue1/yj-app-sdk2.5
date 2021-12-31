import 'package:flutter/material.dart';
import 'package:scet_dz/pages/ModuleAlarm/Components/HistoryAlarm.dart';
import 'package:scet_dz/pages/ModuleAlarm/Components/RealTimeAlarm.dart';
import 'package:scet_dz/pages/ModuleAlarm/Components/StationCount.dart';
import 'package:scet_dz/utils/screen/Adapter.dart';
import 'package:scet_dz/utils/screen/screen.dart';

class AlarmCenter extends StatefulWidget {
  _AlarmCenterState createState() => _AlarmCenterState();
}

class _AlarmCenterState extends State<AlarmCenter> with SingleTickerProviderStateMixin{

  List _tabTitles = ['站点', '实时', '历史'];
  
  late TabController _tabController;

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
            '预警中心', 
            style: TextStyle(
              color: Colors.white,
              fontSize: sp(40.0)
            )
          ),
          elevation: 0,
          centerTitle: true
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: <Widget>[
            // tab栏目内容
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
                  StationCount(),
                  RealTimeAlarm(),
                  HistoryAlarm()
                ] 
              ),
            )
          ]
        ),
      ),
    );
  }
}