import 'package:flutter/material.dart';
import 'package:scet_app/components/DateRange.dart';
import 'package:scet_app/components/DownInput.dart';
import 'package:scet_app/components/NoData.dart';
import 'package:scet_app/pages/alarmModule/components/WidgetCheck.dart';
import 'package:scet_app/pages/dataModule/components/ReportCard.dart';
import 'package:scet_app/utils/api/Api.dart';
import 'package:scet_app/utils/api/Request.dart';
import 'package:scet_app/utils/tool/screen/Adapter.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';

class Report extends StatefulWidget {
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {

  List _pdfList = [];

  DateTime _startTime = DateTime.now().add(Duration(days: -365));

  DateTime _endTime = DateTime.now();

  String _currentType = 'week';
  
  Map _report= {'name': '周报', 'value': 'week'}; // 选中项目
  
  List _reportType = [
    {'name': '周报', 'value': 'week'},
    {'name': '月报', 'value': 'month'},
    {'name': '季报', 'value': 'season'},
    {'name': '年报', 'value': 'year'},
    {'name': '快报', 'value': 'quick'},
  ];

  void _getPdfList(type, startTime, endTime) async{
    Map<String, dynamic> params = Map();
    params['type'] = type;
    params['startTime'] = startTime.toUtc();
    params['endTime'] = endTime.toUtc();
    
    var response = await Request().get(Api.url['reportList'], data: params);
    if(response['code'] == 200) {
      setState(() {
        _pdfList = response['data'];
      });
    }
  }

  @override
  void initState() {
    _getPdfList(_currentType, _startTime, _endTime);
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(Adapt.screenW(), px(Adapter.topBarHeight)),
        child: AppBar(
          title: Text(
            '报告', 
            style: TextStyle(
              color: Colors.white,
              fontSize: sp(Adapter.appBarFontSize)
            )
          ),
          elevation: 0,
          centerTitle: true
        ),
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0XFFFFFFFF),
              boxShadow: [
                BoxShadow(
                  color: Color(0X0A002480),
                  offset: Offset(0, 0),
                  blurRadius: 1,
                  spreadRadius: 0
                )
              ],
            ),
            padding: EdgeInsets.symmetric(vertical: px(24.0), horizontal: px(48.0)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                WidgetCheck.rowItem(
                  padding: false,
                  title: '报告类型',
                  child: DownInput(
                    hitStr: '请选择报告类型',
                    value: _report['name'],
                    currentData: _report,
                    data: _reportType,
                    callback: (val) {
                      setState(() {
                        _currentType =  val == null ?'week': val['value'];
                        _report = val == null ? {'name': '', 'value': ''} : val;
                      });
                    },
                  )
                ),
                WidgetCheck.rowItem(
                  padding: true,
                  title: '时间范围',
                  child: DateRange(
                    start: _startTime,
                    end: _endTime,
                    callBack: (val) {
                      _startTime = val[0];
                      _endTime = val[1];
                    },
                  )
                ),
                Container(
                  width: px(120.0),
                  height: px(48.0),
                  child: GestureDetector(
                    onTap: () {
                      _getPdfList(_currentType, _startTime, _endTime);
                    },
                    child: Image.asset(
                      'assets/icon/report/search.png', 
                      fit: BoxFit.cover
                    )
                  )
                )
              ],
            )
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(px(20.0), 0.0, px(20.0), px(24.0)),
              children: [
                ListView.builder(
                  shrinkWrap: true, 
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _pdfList.length,
                  itemBuilder: (context, index) {
                    return ReportCard(data: _pdfList[index]);
                  }
                ),
                // 没数据
                Visibility(
                  visible: _pdfList.length == 0,
                  child: NoData(state: '当前时间区间无该类报告！')
                )
              ]
            )
          )
        ],
      )
    );
  }
}