import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scet_app/components/ToastWidget.dart';
import 'package:scet_app/components/LineCharts.dart';
import 'package:scet_app/pages/alarmModule/components/WidgetCheck.dart';
import 'package:scet_app/pages/alarmModule/components/handleProcess/RoseCharts.dart';
import 'package:scet_app/utils/api/Api.dart';
import 'package:scet_app/utils/api/Request.dart';
import 'package:scet_app/utils/tool/dateUtc/dateUtc.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';

class DataAnalysis extends StatefulWidget {
  final Map? data;
  final Map? baseInfo;
  final windData;
  final List? dataPlural;
  final List? valueData;
  final String? lineChartsName, lineChartsUnit, dataConclusion, windConclusion;
  DataAnalysis({
    this.data,
    this.baseInfo,
    this.windData,
    this.dataPlural,
    this.valueData,
    this.lineChartsName,
    this.lineChartsUnit,
    this.dataConclusion,
    this.windConclusion,
  });
  @override
  _DataAnalysisState createState() => _DataAnalysisState();
}

class _DataAnalysisState extends State<DataAnalysis> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  List _switchData = [
    {"name": "数据过滤情况", "state": true},
    {"name": "站点环境情况", "state": true},
    {"name": "仪器环境情况", "state": true},
    {"name": "网络环境情况", "state": true},
  ];

  // 数据核查及分析
  List? _dataPlural = [], _valueData = [];
  var _windData;
  String? _lineChartsName, _lineChartsUnit, _dataConclusion, _windConclusion;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dataPlural =widget.dataPlural;
    _valueData =widget.valueData;
    _windData =widget.windData;
    _lineChartsName =widget.lineChartsName;
    _lineChartsUnit =widget.lineChartsUnit;
    _dataConclusion =widget.dataConclusion;
    _windConclusion =widget.windConclusion;

    if(widget.baseInfo !=null){
      _switchData[0]['state'] =  widget.baseInfo!['dataFiltering'] == 1 ? false : true;
      _switchData[1]['state'] =  widget.baseInfo!['siteEnvironment'] == 1 ? false : true;
      _switchData[2]['state'] =  widget.baseInfo!['instrumentEnvironment'] == 1 ? false : true;
      _switchData[3]['state'] =  widget.baseInfo!['networkEnvironment'] == 1 ? false : true;
    }
  }

  @override
  void didUpdateWidget(DataAnalysis oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(oldWidget.baseInfo != widget.baseInfo || oldWidget.valueData != widget.valueData ) {
      _dataPlural =widget.dataPlural;
      _valueData =widget.valueData;
      _windData =widget.windData;
      _lineChartsName =widget.lineChartsName;
      _lineChartsUnit =widget.lineChartsUnit;
      _dataConclusion =widget.dataConclusion;
      _windConclusion =widget.windConclusion;
      if(widget.baseInfo !=null){
        _switchData[0]['state'] =  widget.baseInfo!['dataFiltering'] == 1 ? false : true;
        _switchData[1]['state'] =  widget.baseInfo!['siteEnvironment'] == 1 ? false : true;
        _switchData[2]['state'] =  widget.baseInfo!['instrumentEnvironment'] == 1 ? false : true;
        _switchData[3]['state'] =  widget.baseInfo!['networkEnvironment'] == 1 ? false : true;
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: px(24.0)),
      children: [
        WidgetCheck.miniTitle(
            '数据核查及分析',
            icon: 'assets/icon/alarm/DataAnalysis.png'
        ),
        WidgetCheck.fromCard(
          child: Column(
            children: [
              _chartsTitle(title: '三氯甲烷浓度趋势图'),
              Container(
                height: px(320),
                child: LineCharts(
                  facName: _lineChartsName,
                  unit: _lineChartsUnit,
                  warnLevel: 0,
                  showAxis: true,
                  valueData: _valueData
                  // [
                  //   [DateTime.parse('2020-09-02T03:01:59.999Z').millisecondsSinceEpoch, 7.4356],
                  //   [DateTime.parse('2020-09-02T03:02:59.999Z').millisecondsSinceEpoch, 17.4356],
                  //   [DateTime.parse('2020-09-02T03:03:59.999Z').millisecondsSinceEpoch, 27.4356],
                  //   [DateTime.parse('2020-09-02T03:04:59.999Z').millisecondsSinceEpoch, 57.4356],
                  //   [DateTime.parse('2020-09-02T03:05:59.999Z').millisecondsSinceEpoch, 27.4356],
                  // ],
                )
              ),
              _itemResult(title: '监测数据结论', data: _dataConclusion)
            ],
          )
        ),
        // 玫瑰图
        Container(
          margin: EdgeInsets.only(top: px(24.0)),
          child: WidgetCheck.fromCard(
            child: Column(
              children: [
                _chartsTitle(title: '风力风向玫瑰图'),
                Container(
                  height: px(460.0),
                  child: RoseCharts(windData: {'W': 12})
                ),
                _itemResult(title: '气象数据结论', data: _windConclusion)
              ],
            )
          ),
        ),
        WidgetCheck.fromCard(
          child: ListView.separated(
            shrinkWrap: true, 
            physics: NeverScrollableScrollPhysics(),
            itemCount: _switchData.length,
            itemBuilder: (context, index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '${index + 1}. ${_switchData[index]['name']}', 
                    style: TextStyle(
                      fontSize: sp(28.0),
                      color: Color(0XFF2E2F33)
                    )
                  ),
                  Visibility(
                    child: Container(
                      width: px(66.0),
                      height: px(34.0),
                      child: Image.asset(
                        'assets/images/RightMenu/btn.png', 
                        width: px(66.0),
                        height: px(34.0)
                      ),
                    ),
                    replacement:Image.asset(
                      'assets/images/RightMenu/unBtn.png',
                      width: px(66.0),
                      height: px(34.0),
                    ),
                    visible: _switchData[index]['state'],
                  )
                ]
              );
            }, 
            separatorBuilder: (context, index) {
              return Divider(color: Color(0X33A1A8B3),);
            }, 
          )
        )
      ]
    );
  }

  Widget _chartsTitle({String? title}) {
    return Container(
      padding: EdgeInsets.only(bottom: px(20.0)),
      child: Text(
        '$title',
        style: TextStyle(
          fontSize: sp(30.0),
          color: Color(0XFF4D7CFF),
          fontFamily: "M"
        ),
      ),
    );
  } 

  Widget _itemResult({String? title, String? data}) {
    return Container(
      width: Adapt.screenW(),
      margin: EdgeInsets.only(top: px(20.0)),
      padding: EdgeInsets.symmetric(
        horizontal: px(20.0),
        vertical:  px(12.0)
      ),
      decoration: BoxDecoration(
        color: Color(0X244D7CFF),
        borderRadius: BorderRadius.circular(px(16.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title：',
            style: TextStyle(
              fontSize: sp(28.0),
              color: Color(0XFF2E2F33)
            )
          ),
          Padding(
            padding: EdgeInsets.only(top: px(10.0)),
            child: Text(
              '$data',
              style: TextStyle(
                fontSize: sp(26.0),
                color: Color(0XFF3D5699)
              )
            ),
          )
        ],
      )
    );
  }
}