import 'package:scet_dz/utils/dateUtc/dateUtc.dart';
import 'package:flutter/material.dart';
import 'package:scet_dz/api/Api.dart';
import 'package:scet_dz/api/Request.dart';
import 'package:scet_dz/components/LineCharts.dart';
import 'package:scet_dz/utils/screen/screen.dart';


class AlarmCharts extends StatefulWidget {
  final data;
  final String? sourceCompany;
  AlarmCharts({this.data, this.sourceCompany});

  @override
  _AlarmChartsState createState() => _AlarmChartsState();
}

class _AlarmChartsState extends State<AlarmCharts> {

  Map factor = {};

  var chartsTime, chartsValue;

  List _valueData=[];

  // 获取浓度趋势
  void _getStationFactor() async {
    Map<String, dynamic> params = Map();
    params['stId'] = widget.data['stId'];
    params['facId'] = widget.data['facId'];
    params['startTime'] = DateTime.parse(widget.data['triggerTime']).add(Duration(hours: -1));
    params['endTime'] = widget.data['time'];
    var response = await Request().get(Api.url['alarmLine'], data: params);
    if(response['code'] == 200) {
      List valueList = [];
      response['data'].forEach((item) {
        valueList.add([DateTime.parse(item['time']).millisecondsSinceEpoch, item['value']]);
      });
      if(valueList.length > 0) {
        setState(() {
          _valueData = valueList;
          factor = response['data'][0];
        });
      }
    }
  }

  @override
  void initState() {
    _getStationFactor();
    super.initState();
  }

  TextStyle nameStyle = TextStyle(fontSize: sp(25.0), color: Color(0XFF999999));
  TextStyle valueStyle = TextStyle(color: Color(0XFF45C79D), fontSize: sp(27.0), fontWeight: FontWeight.w400);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Adapt.screenW(),
      child: Card(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.assignment_late, size: sp(50.0),color: Color(0XFF2089F6),),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text('${widget.data['facName']}', style: TextStyle(color: Color(0XFF222222), fontSize: sp(36.0), fontWeight: FontWeight.bold),),
                      ),
                      Text('${widget.data['stName']}', style: TextStyle(color: Color(0XFF999999),fontSize: sp(26.0)),)
                    ],
                  )
                ],
              ),
              Divider(color: Color(0XFFD8D8D8)),
              // 浓度
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Text.rich(
                        TextSpan(text: '截止浓度: ',
                          style: nameStyle,
                          children: <TextSpan>[
                            TextSpan(text: '${widget.data['value'] ?? '/'}${factor['unit'] ?? ''}', style: valueStyle,)
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text.rich(
                        TextSpan(text: '截止时间: ',
                          style: nameStyle,
                          children: <TextSpan>[
                            TextSpan(
                                text: "${widget.data['time']!=null ? dateUtc(widget.data['time']) : '/'}",
                                style: valueStyle
                            )
                          ],
                        ),
                      ),
                    ),
                  ]
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0),
                child: Text.rich(
                  TextSpan(
                    text: '可能来源企业：',
                    style: nameStyle,
                    children: <TextSpan>[
                      TextSpan(text: '${ widget.sourceCompany }', style: valueStyle)
                    ],
                  ),
                ),
              ),
              Container(
                  height: px(420.0),
                  child: LineCharts(
                    facName: factor['facName'],
                    unit: factor['unit'],
                    warnLevel: factor['warn'] == null ? 0 : factor['warn']['level'],
                    valueData: _valueData,
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}