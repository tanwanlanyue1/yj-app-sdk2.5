import 'package:flutter/material.dart';
import 'package:scet_app/pages/MapModule/components/WarnCard.dart';
import 'package:scet_app/utils/tool/screen/Adapter.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';

class MyIndustryEvent extends StatefulWidget {
  @override
  _MyIndustryEventState createState() => _MyIndustryEventState();
}

class _MyIndustryEventState extends State<MyIndustryEvent> {
  List _alarmData  = [

    {
      'stName': '建新子站',
      'facName': '一个物质名称',
      'materials': '二氯甲烷',
      'value': '23.4563mg/m³',
      'warn':{'level': 1,'thresholdValue':'1'},
      'eventStatus': '0',
      'time': '2019-02-01 13:00:00',
    },
    {
      'stName': '建新子站',
      'facName': '一个物质名称',
      'materials': '二氯甲烷',
      'value': '23.4563mg/m³',
      'warn':{'level': 1,'thresholdValue':'1'},
      'eventStatus': '1',
      'time': '2019-02-01 13:00:00',
    },
    {
      'stName': '建新子站',
      'facName': '一个物质名称',
      'materials': '二氯甲烷',
      'value': '23.4563mg/m³',
      'warn':{'level': 2,'thresholdValue':'1'},
      'eventStatus': '2',
      'time': '2019-02-01 13:00:00',
    },
  ];//警情数据

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('警情事件',style: TextStyle(
          color: Colors.white,
          fontSize: sp(Adapter.appBarFontSize)
        ),),
        centerTitle: true,
      ),
      body: Container(
        child: ListView.builder(
          itemCount: _alarmData.length,
            itemBuilder: (BuildContext context, int index){
              return WarnCard(data:_alarmData[index],);
            }
        ),
      ),
    );
  }
}
