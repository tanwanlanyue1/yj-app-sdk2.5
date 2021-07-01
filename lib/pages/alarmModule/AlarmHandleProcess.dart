import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scet_app/components/ToastWidget.dart';
import 'package:scet_app/pages/alarmModule/components/handleProcess/BasicInformation.dart';
import 'package:scet_app/pages/alarmModule/components/handleProcess/DataAnalysis.dart';
import 'package:scet_app/pages/alarmModule/components/handleProcess/DataSource.dart';
import 'package:scet_app/pages/alarmModule/components/handleProcess/InspectTask.dart';
import 'package:scet_app/pages/alarmModule/components/handleProcess/MonitorTask.dart';
import 'package:scet_app/pages/alarmModule/components/handleProcess/MsdsSuggest.dart';
import 'package:scet_app/pages/alarmModule/components/handleProcess/AttachmentReport.dart';
import 'package:scet_app/utils/api/Api.dart';
import 'package:scet_app/utils/api/Request.dart';
import 'package:scet_app/utils/tool/dateUtc/dateUtc.dart';
import 'package:scet_app/utils/tool/screen/Adapter.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';

class AlarmHandleProcess extends StatefulWidget {
  final Map  data;
  AlarmHandleProcess({this.data});
  @override
  _AlarmHandleProcessState createState() => _AlarmHandleProcessState();
}

class _AlarmHandleProcessState extends State<AlarmHandleProcess> with SingleTickerProviderStateMixin {

  TabController _tabController;

  List _tabTitles = ['基础信息', 'MSDS建议', '数据核查及分析', '来源误判-溯源清单', '核查任务', '监测任务', '附件报告'];

  int tabIndex;
  Map _baseInfo;// 事件基础信息
  List _dataPlural = [],_valueData = []; // 数据核查及分析
  var _windData; // 数据核查及分析
  String _lineChartsName, _lineChartsUnit, _dataConclusion, _windConclusion; // 数据核查及分析
  Map _traceSourceData; // 溯源清单

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this,length: _tabTitles.length);

    if(widget.data == null ) {
      ToastWidget.showToastMsg('暂无数据');
      Navigator.pop(context);
    } else {
      _getEventInfo();
    }
  }

  // 事件基础信息
  void _getEventInfo() async{
    Map<String, String> _data = Map();
    _data['code'] = widget.data['eventCode'];
    var response = await Request().get(Api.url['eventDetails'], data: _data);
    print( widget.data);
    if(response['code'] == 200){
      if(response['data'] == null ) {
        ToastWidget.showToastMsg('暂无数据');
        Navigator.pop(context);
        return;
      }
      var result = response['data'];
      List listData = [{"stId": widget.data['stId'], "facId": widget.data['facId'], "devId": widget.data['devId']}];
      var startTime =  DateTime.parse(dateUtc(result['runupTime'])).add(Duration(hours: -1));
      var endTime = result['endTime'] != null ? dateUtc(result['endTime']) : DateTime.now().toString();
      _dataPlurals(json.encode(listData), startTime, endTime);
      _baseInfo = response['data'];
      setState(() { });
    }
  }

  /// 数据核查分析
  void _dataPlurals(var dataList, DateTime startTime, String endTime) async{
    Map<String, dynamic> _data = Map();
    _data['dataList'] = dataList;
    _data['startTime'] = startTime;
    _data['endTime'] = endTime;
    var response = await Request().get(Api.url['dataPlural'], data: _data);
    if(response['code'] == 200){
      var result = response['data'];
      if(result.length > 0) {
        _traceSource(result[0]['wdStat']);
        List lineCharts = [];
        result[0]['dataList'].forEach((item) {
          lineCharts.add([DateTime.parse(item['time']).millisecondsSinceEpoch, item['judgmentValue']]);
        });

        var maxData = result[0]['maxData'];
        String monitorResult = "事故点${dateUtc(maxData['warn']['time'])}时，"
            + "最高浓度达${maxData['judgmentValue']}${maxData['judgmentUnit']}，"
            + "最高级别达${maxData['warn']['level']}级，"
            + " 超限${maxData['warn']['thresholdValue']}倍。";
        String weatherResult= "${dateUtc(startTime.toString())}~${endTime}时间段内，主导风向为—${result[0]['mainWdExpl']}风，风向次数为${result[0]['mainWdNumber']}次";

        this.setState(() {
          _valueData = lineCharts;
          _dataConclusion = monitorResult;
          _windConclusion = weatherResult;
          _lineChartsName = result[0]['facName'];
          _lineChartsUnit = result[0]['dataList'][0]['judgmentUnit'];
          _windData = result[0]['wdStat'];
        });
      }
      setState(() { });
    }
  }
  /// 溯源清单
  void _traceSource(wdStat) async{
    Map<String, dynamic> _data = Map();
    _data['stId'] = widget.data['stId'];
    _data['code'] = widget.data['eventCode'];
    _data['CAS'] = widget.data['cAS'];
    _data['wdStat'] = json.encode(wdStat);
    var response = await Request().get(Api.url['traceSource'], data: _data);
    if(response['code'] == 200){
      _traceSourceData = response['data'];
      // 1
      setState(() { });
    }
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
            '警情处理流程', 
            style: TextStyle(
              color: Colors.white,
              fontSize: sp(Adapter.appBarFontSize)
            )
          ),
          elevation: 0,
          centerTitle: true
        ),
      ),
      body: Container(
        color: Color(0XFFF2F4FA),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: <Widget>[
            // tab栏目内容
            Container(
              height: px(64.0),
              color: Color(0XFFFFFFFF),
              child: DefaultTabController(
                length: _tabTitles.length,
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: Color(0XFF0066FF),
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorPadding: EdgeInsets.zero,
                  isScrollable: true,
                  labelColor: Color(0XFF4D7CFF),
                  labelStyle: TextStyle(
                    fontSize: sp(26.0)
                  ),
                  unselectedLabelColor: Color(0XFF2E3033),
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
                  BasicInformation(
                      data:widget.data,
                      baseInfo:_baseInfo
                  ),
                  MsdsSuggest(
                      data:widget.data
                  ),
                  DataAnalysis(
                      data:widget.data,
                      baseInfo:_baseInfo,
                      windData:_windData,
                      dataPlural:_dataPlural,
                      valueData:_valueData,
                      lineChartsName:_lineChartsName,
                      lineChartsUnit:_lineChartsUnit,
                      dataConclusion:_dataConclusion,
                      windConclusion:_windConclusion,
                  ),
                  DataSource(
                      data:widget.data,
                      traceSource: _traceSourceData,
                  ),
                  InspectTask(
                    data:widget.data,
                  ),
                  MonitorTask(
                    data:widget.data,
                  ),
                  AttachmentReport()
                ] 
              ),
            )
          ]
        ),
      ),
    );
  }

}