import 'package:cs_app/utils/dateUtc/dateUtc.dart';
import 'package:flutter/material.dart';
import 'package:cs_app/api/Api.dart';
import 'package:cs_app/api/Request.dart';
import 'package:cs_app/components/DateRange.dart';
import 'package:cs_app/components/NoData.dart';
import 'package:cs_app/components/WidgetCheck.dart';
import 'package:cs_app/utils/screen/screen.dart';

class RecordInspection extends StatefulWidget {
  final int? stId;
  RecordInspection({Key? key, this.stId}) : super(key: key);
  
  _RecordInspectionState createState() => _RecordInspectionState();
}

class _RecordInspectionState extends State<RecordInspection> {

  DateTime _startTime = DateTime.now().add(Duration(days: -30));

  DateTime _endTime = DateTime.now();

  // 巡检记录接口
  List inspectionList = [];
  void _getInspection(startTime, endTime) async {
    Map<String, dynamic> params = Map();
    params['stId'] = widget.stId;
    params['startTime'] = startTime.toUtc();
    params['endTime'] = endTime.toUtc();
    var response = await Request().get(Api.url['patrolList'], data: params);
    if (response['code'] == 200) {
      setState(() {
        inspectionList = response['data'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getInspection(_startTime, _endTime);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: px(20.0)),
      child: ListView(
        children: [
          Row(
            children: [
              Expanded(
                child: WidgetCheck.rowItem(
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
              ),
              Container(
                width: px(120.0),
                height: px(58.0),
                margin: EdgeInsets.only(left: px(15.0)),
                child: GestureDetector(
                  onTap: () {
                    _getInspection(_startTime, _endTime);
                  },
                  child: Image.asset(
                    'lib/assets/icon/search.png', 
                    fit: BoxFit.fill
                  )
                )
              )
            ],
          ),
          inspectionList.length > 0 
          ? 
            _inspectionWidget(data: inspectionList) 
          : 
            NoData(margin: false, timeType: false, state: '该时间段无站点巡检情况！')
        ]
      )
    );
  }

  Widget _inspectionWidget({required List data}) {
    List<Widget> tiles = [];
    Widget content;
    for (var item in data) {
      var mWidget = Container(
        margin: EdgeInsets.only(top: px(30.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: px(20.0)),
              child: Text(
                '${item['stName']}',
                style: TextStyle(
                  fontSize: sp(28.0), 
                  color: Color(0XFF1D7DFE)
                )
              ),
            ),
            _itemInspectdata(
              padding: false,
              title: '巡检人员',
              value: '${item['personName']}'
            ),
            _itemInspectdata(
              padding: true,
              title: '巡检时间',
              value: '${dateUtc(item['patrolTime'])}'
            ),
            _itemInspectdata(
              padding: false,
              title: '巡检描述',
              value: '${item['remark']}'
            )
          ],
        ),
      );
      tiles.add(mWidget);
    }
    content = Column(
      children: tiles
    );
    return content;
  }

  Widget _itemInspectdata({required bool padding, String? title, String? value}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: px(5.0)),
      padding: padding ? EdgeInsets.symmetric(vertical: px(10.0)) : EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: px(156.0),
            margin: EdgeInsets.only(right: px(60.0)),
            child: Text(
              '$title:', 
              style: TextStyle(
                fontSize: sp(24.0), 
                color: Color(0XFF999999)
              )
            ),
          ),
          Expanded(
            child: Container(
              child: Text(
                '${value ?? '/'}', 
                style: TextStyle(
                  fontSize: sp(24.0), 
                  color: Color(0XFF222222)
                )
              )
            ),
          )
        ]
      ),
    );
  }
}