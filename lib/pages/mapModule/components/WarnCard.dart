import 'package:flutter/material.dart';
import 'package:scet_app/components/Status.dart';
import 'package:scet_app/components/LineCharts.dart';
import 'package:scet_app/utils/tool/colorTheme/colorTheme.dart';
import 'package:scet_app/utils/tool/dateUtc/dateUtc.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';

/// 警情卡片
class WarnCard extends StatelessWidget {
  final Map data; // 警情数据
  WarnCard({this.data});

  _getMaxIndex(List arr) {
    var max = arr[0]['judgmentValue'];
    int index = 0;
    for (int i = 0; i < arr.length; i++) {
      if(max < arr[i]['judgmentValue']) {
        max = arr[i]['judgmentValue'];
        index = i;
      } 
    }
    return index;
  }

  _changeData(curveList) {
    List valueList = [];
    if(curveList != null && curveList.length > 0) {
      // int index = _getMaxIndex(curveList);
      int listLength = curveList.length;
      List dataList = [];
      if(listLength > 50) {
        dataList = curveList.sublist(listLength-50, listLength);
      } else {
        dataList = curveList;
      }
      // if(listLength - index >= 10 && index + 10 <= listLength) {
      //   dataList = curveList.sublist(index - 10, index + 10);
      // } else {
      //   dataList = curveList;
      // }
      dataList.forEach((item) {
        valueList.add([DateTime.parse(item['time']).millisecondsSinceEpoch, item['judgmentValue']]);
      });
    } else {
      valueList = [
        [DateTime.parse('2020-09-02T03:01:59.999Z').millisecondsSinceEpoch, 0.01],
      ];
    }
    return valueList;
  }
  
  @override
  Widget build(BuildContext context) {

    List valueList = _changeData(data['curveList']);

    return InkWell(
      child: Container(
        height: px(264),
        width: px(702),
        margin: EdgeInsets.only(left: px(24),right: px(24),bottom: px(16),top: px(16)),
        padding: EdgeInsets.all(px(16)),
        decoration: BoxDecoration(
          color: Color(0xffffffff),
          borderRadius: BorderRadius.circular(px(15)),
          boxShadow: [
            BoxShadow(
              color: Color(0xffE9EBF3),
              offset: Offset(2.0, 2.0),
              blurRadius: 1.0,
              spreadRadius: 2.0
            ),
          ]
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${data['stName']}',
                  style: TextStyle(
                    color: Color(0xff4D7CFF),
                    fontSize: sp(32),
                    fontFamily: "M",
                  ),
                ),
                Spacer(),
                Status(status:data['eventStatus'].toString(),),
                Container(
                  margin: EdgeInsets.only(left: px(14)),
                  child: Row(
                    children: [
                      Text(
                        '更多',
                        style: TextStyle(color: Color(0xff8A9099),fontSize: sp(22)),
                      ),
                      Icon(Icons.keyboard_arrow_right,color: Color(0xffB5B8BD),size: sp(35),)
                    ],
                  ),
                )
              ],
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: px(10)),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          _tabText('预警物质', data['facName']),
                          _tabText('注意标识', '警告级 -- ${data['warn']['level']}级', colors: true),
                          _tabText('截止浓度', data['value'].toString()),
                          _tabText('截止时间', dateUtc(data['time'])),
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      ),
                    ),
                    Container(
                      width: px(196.31),
                      height: double.infinity,
                      child: LineCharts(
                        facName: data['facName'] ?? '/',
                        unit: data['unit'] ?? '/',
                        warnLevel: data['warn']['level'] ?? 1,
                        showAxis: false,
                        valueData: valueList
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, '/alarm/handleProcess',arguments:data );
        },
    );
  }

  Widget _tabText(String title, String str,{bool colors = false}){
    return Row(
      children: [
        Text('$title：',style: TextStyle(color: Color(0xff787A80),fontSize: sp(26)),),
        Text(
          '$str',
          style: TextStyle(
            color: colors ? noticeColorTheme(data['warn']['level']) : Color(0xff2E2F33),
            fontSize: sp(30.0)
          ),
        )
      ],
    );
  }
}