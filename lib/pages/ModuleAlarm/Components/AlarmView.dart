import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scet_dz/api/Api.dart';
import 'package:scet_dz/api/Request.dart';
import 'package:scet_dz/components/SameTable.dart';
import 'package:scet_dz/components/ToastWidget.dart';
import 'package:scet_dz/pages/ModuleAlarm/Components/AlarmCharts.dart';
import 'package:scet_dz/utils/dateUtc/dateUtc.dart';
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
  Map dataAll = {};
  String _sourceCompany = '/';
  int kindIndex = 0;
  List kind = [];

  int _total = 10;
  int _pageNo = 0;

  List tableHeader = ["等级","范围","单位",];
  List sameHeader = ["站点","检测时间","浓度值",];

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
      setState(() {
        similarDispose(data);
      });
    }
  }
  // 获取浓度趋势
  void _getStationFactor() async {
    Map<String, dynamic> params = Map();
    params['stId'] = widget.data['stId'];
    params['facId'] = widget.data['facId'];
    params['startTime'] = DateTime.parse(widget.data['triggerTime']).add(Duration(hours: -1));
    params['endTime'] = widget.data['time'];
    var response = await Request().get(Api.url['alarmLine'], data: params);
    List list = [];
    if(response['code'] == 200) {
      dataAll = response["data"][0];
      List keys = [];
      keys.addAll(dataAll.keys);
      for (var item in keys) {
        switch (item) {
          case 'warningThresholds': {
            List dataDisposeList = dataDispose(dataAll['warningThresholds'], 'warningThresholds');
            list.add({ 'title': '预警', 'list': dataDisposeList });
          }
          break;
          case 'trendThresholds': {
            var dataDisposeList = dataDispose(dataAll['trendThresholds'], 'trendThresholds');
            list.add({ 'title': '趋势', 'list': dataDisposeList });
          }
          break;
          case 'stenchThresholds': {
            var dataDisposeList = dataDispose(dataAll["stenchThresholds"], 'stenchThresholds');
            list.add({ 'title': '恶臭', 'list': dataDisposeList });
          }
          break;
          case 'accidentHazardThresholds': {
            var dataDisposeList = dataDispose(dataAll["accidentHazardThresholds"], 'accidentHazardThresholds');
            list.add({ 'title': '事故危害', 'list':  dataDisposeList });
          }
          break;
          case 'sourceThresholds': {
            var dataOne = item.sourceThresholds[0];
            var mgValue = dataOne.containsKey('min') ? '<' + dataOne['min'] + ' ' + '>' + dataOne["max"] : '>' + dataOne["max"];
            list.add({ 'title': '固定污染源', 'list': [["超限值",mgValue,dataOne["unit"]] ]});
          }
          break;
        }
      }
    }
    _thresholds = list;
    kind = [];
    for(var i = 0;i<_thresholds.length;i++){
      kind.add(
          _thresholds[i]["title"]
      );
    }
    setState(() {});
  }
  // 数据处理
  dataDispose(data, type) {
    var list = [];
    switch (type) {
      case 'warningThresholds': {
        for (var i = 0; i < data.length; i++) {
          switch (data[i]["level"]) {
            case 1: {
              list.add(["异常(1级)",  data[i]["ppmValue"], 'ppm']);
            }
            break;
            case 2: {
              list.add(["注意(2级)",  data[i]["ppmValue"], 'ppm']);
            }
            break;
            case 3: {
              list.add(["警告(3级)",  data[i]["ppmValue"], 'ppm']);
            }
            break;
            case 4: {
              list.add(["高报(4级)",  data[i]["ppmValue"], 'ppm']);
            }
            break;
          }
        }
      }
      break;
      case 'trendThresholds': {
        for (var i = 0; i < data.length; i++) {
          switch (data[i]["level"]) {
            case 1: {
              if(data[i]["mgValue"] == null){
                list.add(["异常(1级)",  data[i]["ppmValue"], 'ppm']);
              }else{
                list.add(["异常(1级)",  data[i]["mgValue"], 'mg/m³']);
              }
            }
            break;
            case 2: {
              if(data[i]["mgValue"] == null){
                list.add(["注意(2级)",  data[i]["ppmValue"], 'ppm']);
              }else{
                list.add(["注意(2级)",  data[i]["mgValue"], 'mg/m³']);
              }
            }
            break;
            case 3: {
              if(data[i]["mgValue"] == null){
                list.add(["警告(3级)",  data[i]["ppmValue"], 'ppm']);
              }else{
                list.add(["警告(3级)",  data[i]["mgValue"], 'mg/m³']);
              }
            }
            break;
            case 4: {
              if(data[i]["mgValue"] == null){
                list.add(["高报(4级)",  data[i]["ppmValue"], 'ppm']);
              }else{
                list.add(["高报(4级)",  data[i]["mgValue"], 'mg/m³']);
              }
            }
            break;
          }
        }
      }
      break;
      case 'stenchThresholds': {
        for (var i = 0; i < data.length; i++) {
          switch (data[i]["level"]) {
            case 1: {
              list.add(["1级",  data[i]["mgValue"], 'mg/m³']);
            } break;
            case 2: {
              list.add(["2级",  data[i]["mgValue"], 'mg/m³']);
            } break;
            case 3: {
              list.add(["3级",  data[i]["mgValue"], 'mg/m³']);
            } break;
            case 4: {
              list.add(["4级",  data[i]["mgValue"], 'mg/m³']);
            } break;
            case 5: {
              list.add(["5级",  data[i]["mgValue"], 'mg/m³']);
            } break;
          }
        }
      } break;
      case 'accidentHazardThresholds': {
        for (var i = 0; i < data.length; i++) {
          switch (data[i]["level"]) {
            case 1: {
              list.add(["一般(1级)",  data[i]["mgValue"], 'mg/m³']);
            } break;
            case 2: {
              list.add(["较大(2级)",  data[i]["mgValue"], 'mg/m³']);
            } break;
            case 3: {
              list.add(["重大(3级)",  data[i]["mgValue"], 'mg/m³']);
            } break;
            case 4: {
              list.add(["特别重大(4级)",  data[i]["mgValue"], 'mg/m³']);
            } break;
          }
        }
      }
      break;
    }
    return list;
  }
  //同类点位的数据处理
  similarDispose(List data){
    for(var i = 0; i<data.length;i++){
      _samePoint.add([ data[i]["stName"],
        dateUtc(data[i]['time']),
        data[i]['value']+data[i]['unit'],]
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _getLatestData();
    // _getSourceCompany();
    _getStationFactor();
    _pageNo = _pageNo + 1;
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
                switchTitle(),
                _thresholds.isNotEmpty ?
                SameTable(
                  tableHeader: tableHeader,
                  tableBody: _thresholds[kindIndex]["list"],

                ):Container(),
                // 同类点位
                _samePoint.isNotEmpty ?
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 5.0),
                  child: Text(
                    '同类点位',
                    style: TextStyle(
                        fontSize: sp(24.0),
                        color: Color(0XFF707070)
                    ),
                  ),
                ):
                Container(),
                _samePoint.isNotEmpty ?
                SameTable(
                  tableHeader: sameHeader,
                  tableBody: _samePoint,
                ):
                Container(),
              ],
            ),
          ),
        ],
      )
    );
  }
  //选择类别
  Widget switchTitle() {
    return Row(
      children: List.generate(kind.length, (i) {
        return InkWell(
          child: Container(
            height: px(42),
            padding: EdgeInsets.only(left: px(20),right: px(20)),
            margin: EdgeInsets.only(left: px(24),bottom: px(20)),
            alignment: Alignment.center,
            child: Text(
              '${kind[i]}',
              style: TextStyle(
                  fontSize: sp(24),
                  color: kindIndex == i ? Colors.white:Color(0xff45474D),
                  fontFamily: "R"
              ),
            ),
            decoration: BoxDecoration(
                color: kindIndex == i ? Color(0xff4D7CFF):Color(0xff29A8ABB3),
                borderRadius: BorderRadius.all(Radius.circular(px(4)))
            ),
          ),
          onTap: (){
            kindIndex = i;
            setState(() {});
          },
        );
      }),
    );
  }
}
