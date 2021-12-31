import 'package:flutter/material.dart';
import 'package:cs_app/pages/ModuleMonitor/Components/RecordMaintain.dart';
import 'package:cs_app/pages/ModuleMonitor/Components/RecordInspection.dart';
import 'package:cs_app/utils/screen/screen.dart';

class StationRecord extends StatefulWidget{
  final int? stId;
  StationRecord({Key? key, this.stId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _StationRecord();
  }
}
class _StationRecord extends State<StationRecord> with SingleTickerProviderStateMixin{

  List _tabTitles = ['检修记录', '巡检记录'];
  
  late TabController _tabController;

  int index = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _tabTitles.length)..addListener(() {
      setState(() {
        index = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: px(20.0)),
        child: Column(
          children: <Widget>[
            Container(
              height: px(64.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(6.0)),
                border: Border.all(color: Colors.black, width: 0.2,),
              ),
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: DefaultTabController(
                length: _tabTitles.length,
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: index == 0 
                    ? BorderRadius.only(
                        topLeft: Radius.circular(6.0), 
                        bottomLeft: Radius.circular(6.0)
                      ) 
                    : BorderRadius.only(
                        topRight: Radius.circular(6.0), 
                        bottomRight: Radius.circular(6.0)
                      )
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  isScrollable: false,
                  labelColor: Colors.white,
                  labelStyle: TextStyle(
                    color: Colors.white,
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
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  RecordMaintain(stId: widget.stId),
                  RecordInspection(stId: widget.stId)
                ] 
              ),
            )
          ],
        ),
      ),
    );
  }
}
