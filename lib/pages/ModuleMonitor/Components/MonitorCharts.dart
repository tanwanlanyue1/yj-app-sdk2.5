import 'package:cs_app/utils/dateUtc/dateUtc.dart';
import 'package:flutter/material.dart';
import 'package:cs_app/api/Api.dart';
import 'package:cs_app/api/Request.dart';
import 'package:cs_app/components/LineCharts.dart';
import 'package:cs_app/utils/alarmLevel/warnLevel.dart';
import 'package:cs_app/utils/screen/screen.dart';

class MonitorCharts extends StatefulWidget {
  final factor;
  final Color? levelColor;
  final callBack;
  MonitorCharts({Key? key, this.factor, this.levelColor, this.callBack}):super(key: key);

  _MonitorCharts createState() => _MonitorCharts();
}

class _MonitorCharts extends State<MonitorCharts> {

  // 获取当前因子的浓度趋势
  List _valueData = [];
  void _getFactorValueList({required int stId, required String facId}) async {
    Map<String, dynamic> params = Map();
    params['stId'] = stId;
    params['facId'] = facId;
    params['startTime'] = DateTime.now().add(Duration(days: -1));
    params['endTime'] = DateTime.now().toUtc();
    var response = await Request().get(Api.url['factorValueList'], data: params);
    if(response['code'] == 200) {
      List valueList = [];
      response['data'].forEach((item) {
        valueList.add([DateTime.parse(item['time']).millisecondsSinceEpoch, item['value']]);
      });
      setState(() {
        _valueData = valueList;
        _facInfo = response['data'][0];
      });
    }
  }

  // 获取当前因子的详细信息
  Map _facInfo = {};
  void _getFactorDescription({required String facId}) async {
    Map<String, dynamic> params = Map();
    params['facId'] = facId;
    var response = await Request().get(Api.url['factorDescription'], data: params);
    if(response['code'] == 200) {
      setState(() {
        _facInfo = response['data'][0];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // 获取当前因子的详细信息
    // _getFactorDescription(facId: widget.factor['facId']);
    // 获取当前因子的浓度趋势
    _getFactorValueList(
      stId: widget.factor['stId'], 
      facId: widget.factor['facId']
    );
  }

  TextStyle nameStyle = TextStyle(fontSize: sp(24.0), color: Color(0XFF999999));

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      margin: EdgeInsets.all(px(30.0)),
      child: Container(
        padding: EdgeInsets.all(px(12.0)), 
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
                    Icon(
                      Icons.assignment_late,  
                      size: sp(50.0), 
                      color: Color(0XFF2089F6)
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(4.0, 0.0, 6.0, 0.0),
                      child: Text(
                        '${widget.factor['facName']}', 
                        style: TextStyle(
                          color: Color(0XFF222222), 
                          fontSize: sp(34.0), 
                          fontWeight: FontWeight.w600)
                        ),
                    ),
                    Text(
                      '${dateUtc(DateTime.now().toString())}',
                      style: TextStyle(
                        color: Color(0XFF999999),
                        fontSize: sp(24.0)
                      )
                    )
                  ],
                ),
                IconButton(
                  onPressed: (){ 
                    widget.callBack(false);
                  }, 
                  icon: Icon(
                    Icons.cancel, 
                    size: sp(50.0), 
                    color: Color(0XFF7E69F0),
                  ),
                )
              ],
            ),
            Divider(color: Color(0XFFD8D8D8)),
            // 详情
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _itemDataWidget(
                  state: 0,
                  padding: false,
                  leftTitle: '最新浓度',
                  leftData: '${widget.factor['value'] ?? '/'} ${widget.factor['unit'] ?? ''}',
                  rightTitle: '注意标识',
                  rightData: warnLevel(widget.factor['warn']['warning']['level'])
                ),
                _itemDataWidget(
                  state: 1,
                  padding: true,
                  leftTitle: 'cas',
                  leftData: '${_facInfo['CAS'] ?? '/'}',
                  rightTitle: '化学式',
                  rightData: '${_facInfo['MF'] ?? '/'}'
                ),
                // 描述
                Padding(
                  padding: EdgeInsets.only(top: px(20.0), bottom: px(40.0)),
                  child: Text.rich(
                    TextSpan(text: '监测仪器：',
                      style: nameStyle,
                      children: <TextSpan>[
                        TextSpan(
                            text: '${_facInfo['devType'] ?? '/'}',
                            style: valueStyle
                        )
                      ],
                    ),
                  ),
                ),
                // _itemDataWidget(
                //   state: 1,
                //   padding: false,
                //   leftTitle: '英文名称',
                //   leftData: '${_facInfo['enName'] ?? '/'}',
                //   rightTitle: '监测仪器',
                //   rightData: '${_facInfo['devType'] ?? '/'}'
                // ),
                // // 描述
                // Padding(
                //   padding: EdgeInsets.only(top: px(20.0), bottom: px(40.0)),
                //   child: Text.rich(
                //     TextSpan(text: '描述：',
                //       style: nameStyle,
                //       children: <TextSpan>[
                //         TextSpan(
                //           text: '${_facInfo['description'] ?? '/'}',
                //           style: valueStyle
                //         )
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
            Expanded(
              child: LineCharts(
                facName: widget.factor['facName'],
                unit: widget.factor['unit'],
                warnLevel: widget.factor['warn'] == null ? 0 : widget.factor['warn']['warning']['level'],
                valueData: _valueData
              )
            )
          ],
        ),
      )
    );
  }

  TextStyle keyValueStyle = TextStyle(color: Color(0XFF45C79D), fontSize:sp(30.0));
  TextStyle valueStyle = TextStyle(color: Color(0XFF585858), fontSize:sp(28.0));

  Widget _itemDataWidget({
    required int state,
    required bool padding,
    String? leftTitle,
    String? leftData,
    String? rightTitle,
    String? rightData}) {
    return Padding(
      padding: padding ? EdgeInsets.symmetric(vertical: 10.0) : EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Text.rich(
              TextSpan(text: '$leftTitle：',
                style: nameStyle,
                children: <TextSpan>[
                  TextSpan(
                    text: '$leftData', 
                    style: state == 0 ? keyValueStyle : valueStyle
                  )
                ],
              ),
            ), 
          ),
          Expanded(
            flex: 4,
            child: Text.rich(
              TextSpan(text: '$rightTitle：',
                style: nameStyle,
                children: <TextSpan>[
                  TextSpan(
                    text: '$rightData', 
                    style: state == 0 ? keyValueStyle : valueStyle
                  )
                ],
              ),
            ), 
          ),
        ]
      ),
    );
  }
}