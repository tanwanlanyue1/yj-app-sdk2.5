import 'package:flutter/material.dart';
import 'package:scet_dz/api/Api.dart';
import 'package:scet_dz/api/Request.dart';
import 'package:scet_dz/pages/ModuleAlarm/Components/AlarmCharts.dart';
import 'package:scet_dz/pages/ModuleAlarm/Components/SamePointTable.dart';
import 'package:scet_dz/pages/ModuleAlarm/Components/ThresholdsTable.dart';
import 'package:scet_dz/utils/screen/Adapter.dart';
import 'package:scet_dz/utils/screen/screen.dart';

class AlarmView extends StatefulWidget {
  final data;
  AlarmView({this.data});
  
  @override
  _AlarmViewState createState() => _AlarmViewState();
}

class _AlarmViewState extends State<AlarmView> {
  
  List _samePoint = [], _thresholds = [];

  String _sourceCompany = '/';

  void _getSourceCompany() async {
    Map<String, dynamic> params = Map();
    params['stId'] = widget.data['stId'];
    params['CAS'] = widget.data['cAS'];

    var response = await Request().get(Api.url['sitesAround'], data: params);
    if(response['code'] == 200) {
      List result = response['data'];
      if(result.length > 0) {
        var data = result.map((item) {
          return item['name'];
        }).join('、');
        this.setState(() {
          _sourceCompany = data;
        });
      }
    }
  }

  // 获取同类点位
  void _getLatestData() async {
    Map<String, dynamic> params = Map();
    params['facId'] = widget.data['facId'];
    params['time'] = widget.data['time'];
    var response = await Request().get(Api.url['samePoint'], data: params);
    if(response['code'] == 200) {
      List data = [];
      response['data'].forEach((item) {
        if(item['stId'] != widget.data['stId']) {
          data.add(item);
        }
      });
      this.setState(() {
        _samePoint = data;
      });
    }
  }

  // 获取物质阈值
  void _getThresholds() async {
    Map<String, dynamic> params = Map();
    params['stId'] = widget.data['stId'];
    params['devId'] = widget.data['devId'];
    params['facId'] = widget.data['facId'];
    print(params);
    var response = await Request().get(Api.url['factorThresholds'], data: params);
    if(response['code'] == 200) {
      List data = [];
      print(response['data']);
      // response['data'].forEach((item) {
      //   switch(item['level']) {
      //     case 1: data.add({'level': '异常级', 'range': '${item['min']}~${item['max']}' , 'unit': 'mg/m³'}); break;
      //     case 2: data.add({'level': '注意级', 'range': '${item['min']}~${item['max']}' , 'unit': 'mg/m³'}); break;
      //     case 3: data.add({'level': '警告级', 'range': '${item['min']}~${item['max']}' , 'unit': 'mg/m³'}); break;
      //     case 4: data.add({'level': '高报级', 'range': '>${item['min']}' , 'unit': 'mg/m³'}); break;
      //   }
      // });
      this.setState(() {
        _thresholds = data;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getLatestData();
    // _getThresholds();
    _getSourceCompany();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(Adapt.screenW(), px(Adapter.topBarHeight)),
        child: AppBar(
          title: Text(
            '因子警情数据', 
            style: TextStyle(
              color: Colors.white,
              fontSize: sp(40.0)
            )
          ),
          elevation: 0,
          centerTitle: true
        ),
      ),
      body: ListView(
        children: <Widget>[
           Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 10.0
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // 视图
                AlarmCharts(data: widget.data, sourceCompany: _sourceCompany),
                // 阈值
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 5.0),
                  child: Text(
                    '物质阈值',
                    style: TextStyle(
                      fontSize: sp(24.0),
                      color: Color(0XFF707070)
                    ),
                  ),
                ),
                ThresholdsTable(thresholds: _thresholds),
                // 同类点位
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 5.0),
                  child: Text(
                    '同类点位',
                    style: TextStyle(
                      fontSize: sp(24.0),
                      color: Color(0XFF707070)
                    ),
                  ),
                ),
                SamePointTable(samePoint: _samePoint),
              ],
            ),
          ),
        ],
      )
    );
  }
}
