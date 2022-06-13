import 'package:cs_app/components/SameTable.dart';
import 'package:cs_app/components/ToastWidget.dart';
import 'package:cs_app/utils/alarmLevel/warnLevel.dart';
import 'package:cs_app/utils/dateUtc/dateUtc.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cs_app/api/Api.dart';
import 'package:cs_app/api/Request.dart';
import 'package:cs_app/pages/ModuleAlarm/Components/AlarmCharts.dart';
import 'package:cs_app/utils/screen/Adapter.dart';
import 'package:cs_app/utils/screen/screen.dart';
import 'dart:developer';

class AlarmView extends StatefulWidget {
  final data;
  AlarmView({this.data});

  @override
  _AlarmViewState createState() => _AlarmViewState();
}

class _AlarmViewState extends State<AlarmView> {

  List _samePoint = [], _thresholds = [], _warning = [];
  Map dataAll = {};
  String _sourceCompany = '/';
  int kindIndex = 0;
  List kind = [];
  List _valueData=[];

  int _total = 10;
  int _pageNo = 0;

  List tableHeader = ["等级","范围","单位",];
  List sameHeader = ["站点","检测时间","浓度值",];
  List warningHeader = ["开始时间","截止时间","风向","浓度值",'警情级别','处理结果'];

  void _getSourceCompany() async {
    Map<String, dynamic> params = Map();
    params['stId'] = widget.data['stId'];
    params['CAS'] = widget.data['CAS'];

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
        // _samePoint = data;
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
      List valueList = [];
      for(var i = 0; i < response['data'].length; i++){
        valueList.add([DateTime.parse(response['data'][i]['time']).millisecondsSinceEpoch, response['data'][i]['value']]);
      }
      if(valueList.length > 0) {
        setState(() {
          _valueData = valueList;
        });
      }
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
              if(data[i]["ppmValue"] != null){
                list.add(["异常(1级)",  data[i]["ppmValue"], 'ppm']);
              }else{
                list.add(["异常(1级)",  data[i]["mgValue"], 'mg/m³']);
              }
            }
            break;
            case 2: {
              if(data[i]["ppmValue"] != null){
                list.add(["注意(2级)",  data[i]["ppmValue"], 'ppm']);
              }else{
                list.add(["注意(2级)",  data[i]["mgValue"], 'mg/m³']);
              }
            }
            break;
            case 3: {
              if(data[i]["ppmValue"] != null){
                list.add(["警告(3级)",  data[i]["ppmValue"], 'ppm']);
              }else{
                list.add(["警告(3级)",  data[i]["mgValue"], 'mg/m³']);
              }
            }
            break;
            case 4: {
              if(data[i]["ppmValue"] != null){
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
              if(data[i]["ppmValue"] != null){
                list.add(["1级",  data[i]["ppmValue"], 'ppm']);
              }else{
                list.add(["1级",  data[i]["mgValue"], 'mg/m³']);
              }
            } break;
            case 2: {
              if(data[i]["ppmValue"] != null){
                list.add(["2级",  data[i]["ppmValue"], 'ppm']);
              }else{
                list.add(["2级",  data[i]["mgValue"], 'mg/m³']);
              }
            } break;
            case 3: {
              if(data[i]["ppmValue"] != null){
                list.add(["3级",  data[i]["ppmValue"], 'ppm']);
              }else{
                list.add(["3级",  data[i]["mgValue"], 'mg/m³']);
              }
            } break;
            case 4: {
              if(data[i]["ppmValue"] != null){
                list.add(["4级",  data[i]["ppmValue"], 'ppm']);
              }else{
                list.add(["4级",  data[i]["mgValue"], 'mg/m³']);
              }
            } break;
            case 5: {
              if(data[i]["ppmValue"] != null){
                list.add(["5级",  data[i]["ppmValue"], 'ppm']);
              }else{
                list.add(["5级",  data[i]["mgValue"], 'mg/m³']);
              }
            } break;
          }
        }
      } break;
      case 'accidentHazardThresholds': {
        for (var i = 0; i < data.length; i++) {
          switch (data[i]["level"]) {
            case 1: {
              if(data[i]["ppmValue"] != null){
                list.add(["一般(1级)",  data[i]["ppmValue"], 'ppm']);
              }else{
                list.add(["一般(1级)",  data[i]["mgValue"], 'mg/m³']);
              }
            } break;
            case 2: {
              if(data[i]["ppmValue"] != null){
                list.add(["较大(2级)",  data[i]["ppmValue"], 'ppm']);
              }else{
                list.add(["较大(2级)",  data[i]["mgValue"], 'mg/m³']);
              }
            } break;
            case 3: {
              if(data[i]["ppmValue"] != null){
                list.add(["重大(3级)",  data[i]["ppmValue"], 'ppm']);
              }else{
                list.add(["重大(3级)",  data[i]["mgValue"], 'mg/m³']);
              }
            } break;
            case 4: {
              if(data[i]["ppmValue"] != null){
                list.add(["特别重大(4级)",  data[i]["ppmValue"], 'ppm']);
              }else{
                list.add(["特别重大(4级)",  data[i]["mgValue"], 'mg/m³']);
              }
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

  // 获取警情消息
  void _getRealTimeAlarm() async{
    Map<String, dynamic> params = Map();
    params['type'] = 'history';
    params['pageNo'] = _pageNo;
    params['pageSize'] = 10;
    params['status'] = jsonEncode([0,1]);
    params['startTime'] = DateTime.parse(widget.data['triggerTime']).add(Duration(hours: -1));
    params['endTime'] = widget.data['time'];
    params['facId'] = widget.data['facId'];
    params['devId'] = widget.data['devId'];
    var response = await Request().get(Api.url['table'], data: params);
    if(response['code'] == 200) {
      List data = response['data']["data"];
      _total = response['data']["total"];
      setState(() {});
      warningDispose(data);
    }
  }

  //警情信息处理
  warningDispose(List data){
    _warning = [];
    for(var i = 0; i < data.length; i++){
      print('==>${data[i]['weather']}');

      String status = '';

      if(data[i]['status'] == null || data[i]['status']  == 0){
        status = '未处理';
      } else if (data[i]['status'] == 1) {
        status = '已核实';
      } else if (data[i]['status'] == 2) {
        status = '误判';
      }

      _warning.add([
        // data[i]["facName"], // 物质
        dateUtc(data[i]['triggerTime']),//起终时间
        dateUtc(data[i]['time']), //起终时间
        data[i]['weather']["wdExpl"], //风向
        "${data[i]['value']}"+"${data[i]['unit']}", //浓度
        warnLevel(data[i]['warn']["level"]), //警情级别
        status, //处理结果
      ]);
    }
  }

  @override
  void initState() {
    super.initState();
    _getLatestData();
    // _getThresholds();
    _getSourceCompany();
    _getStationFactor();
    _pageNo = _pageNo + 1;
    _getRealTimeAlarm();
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
                  AlarmCharts(
                    data: widget.data,
                    sourceCompany: _sourceCompany,
                    valueData: _valueData,
                    factorData: dataAll,
                  ),
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
                  _warning.isNotEmpty ?
                  Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 5.0),
                    child: Text(
                      '预警信息：（${widget.data['facName']}）',
                      style: TextStyle(
                          fontSize: sp(24.0),
                          color: Color(0XFF707070)
                      ),
                    ),
                  ):
                  Container(),
                  _warning.isNotEmpty ?
                  SameTable(
                    tableHeader: warningHeader,
                    tableBody: _warning,
                    callBack: (){
                      int _warningTotal = _warning.length + ( _pageNo - 1) * 10;
                      if(_total > _warningTotal){
                        _pageNo = _pageNo + 1;
                        _getRealTimeAlarm();
                        setState(() {});
                      }else{
                        ToastWidget.showToastMsg('已经到达最后一页');
                      }
                    },
                    callPrevious: (){
                      if(_pageNo == 1){
                        ToastWidget.showToastMsg('已经到达第一页');
                      }else{
                        _pageNo = _pageNo - 1;
                        _getRealTimeAlarm();
                        setState(() {});
                      }
                    },
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
