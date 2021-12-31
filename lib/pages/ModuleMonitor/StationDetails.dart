import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cs_app/api/Api.dart';
import 'package:cs_app/api/Request.dart';
import 'package:cs_app/pages/ModuleMonitor/Components/StationRecord.dart';
import 'package:cs_app/pages/ModuleMonitor/Components/StationDevice.dart';
import 'package:cs_app/pages/ModuleMonitor/Components/FactorsList.dart';
import 'package:cs_app/utils/screen/Adapter.dart';
import 'package:cs_app/utils/screen/screen.dart';

class StationDetails extends StatefulWidget {
  final data;
  StationDetails({this.data});
  
  _StationDetails createState() => _StationDetails();
}

class _StationDetails extends State<StationDetails> with SingleTickerProviderStateMixin {

  List _tabTitles = ['物质', '设备', '记录'];

  late TabController _tabController;

  // 获取站点设备
  List deviceList = [];
  void _getCurrentStationDevice({int? stId}) async {
    var response = await Request().get(Api.url['stationDevice']  + '/$stId');
    if(response['code'] == 200) {
      List data = response['data'];
      data.sort((a, b) {
        return int.parse(a['status'].toString()).compareTo(int.parse(b['status'].toString()));
      });
      setState(() {
        deviceList = data;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _tabTitles.length);
    _getCurrentStationDevice(stId: widget.data['stId']);
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
            '${widget.data['title']}', 
            style: TextStyle(
              color: Colors.white,
              fontSize: ScreenUtil().setSp(40.0)
            )
          ),
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add,  size: ScreenUtil().setSp(50.0)),
              tooltip: '设备检修',
              onPressed: () { 
                Navigator.pushNamed(context, '/upload/maintain', arguments: {
                  'stId': widget.data['stId'],
                  'deviceList': deviceList
                });
              }
            ),
          ],
        )
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: <Widget>[
            // tab栏目内容
            Container(
              height: ScreenUtil().setHeight(64.0),
              color: Colors.grey[100],
              child: DefaultTabController(
                length: _tabTitles.length,
                child: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.label,
                  isScrollable: false,
                  labelColor: Colors.blue,
                  labelStyle: TextStyle(
                    fontSize: ScreenUtil().setSp(30.0)
                  ),
                  unselectedLabelColor: Colors.grey,
                  indicatorPadding: EdgeInsets.only(bottom: 5.0),
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
                  FactorsList(stId: widget.data['stId']),
                  StationDevice(stId: widget.data['stId'], deviceList: deviceList),
                  StationRecord(stId: widget.data['stId'])
                ] 
              ),
            )
          ]
        ),
      )
    );
  }
}
