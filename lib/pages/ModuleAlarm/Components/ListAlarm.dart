import 'package:scet_dz/utils/dateUtc/dateUtc.dart';
import 'package:flutter/material.dart';
import 'package:scet_dz/utils/alarmLevel/ColorLevel.dart';
import 'package:scet_dz/utils/alarmLevel/warnLevel.dart';
import 'package:scet_dz/utils/screen/screen.dart';

class ListAlarm extends StatelessWidget {
  final List alarmData;
  ListAlarm({ required this.alarmData });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: px(16.0)),
      child: Column(
        children: alarmData.map((item) {
          var color = colorSelest(item['warn']['level']);
          return InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/alarm/dataView', arguments: item);
            },
            child: Padding(
              padding: EdgeInsets.only(bottom: px(12.0)),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(px(10.0)))
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center, 
                  children: <Widget>[
                    Container(
                      width: px(220.0),
                      padding: EdgeInsets.symmetric(vertical: px(70.0)),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(px(10.0)), 
                          bottomLeft: Radius.circular(px(10.0))
                        ),
                        gradient: LinearGradient(
                          colors: color[0]
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center, 
                        children: <Widget>[
                          Text(
                            '预警物质', 
                            style: TextStyle(
                              color: Colors.white, 
                              fontSize: sp(24.0)
                            )
                          ),
                          Text(
                            '${item['facName']}', 
                            style: TextStyle(
                              color: Colors.white, 
                              fontSize: sp(28.0), 
                              height: 2.0, 
                              fontWeight: FontWeight.w600
                            )
                          )
                        ]
                      )
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start, 
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center, 
                              children: <Widget>[
                                Text(
                                  '${item['stName']}', 
                                  style: TextStyle(
                                    fontSize: sp(24.0), 
                                    color: Colors.black)
                                ),
                                Text(
                                  '${warnLevel(item['warn']['level'])}', 
                                  style: TextStyle(
                                    fontSize: sp(28.0), 
                                    color: color[1]
                                  )
                                )
                              ]
                            ),
                            Divider(),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: px(10.0)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start, 
                                children: <Widget>[
                                  Text.rich(
                                    TextSpan(text: '截止浓度：',
                                      style: TextStyle(fontSize: sp(24.0)),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: '${item['value']}${item['unit']}', 
                                          style: TextStyle(
                                            color: color[1], 
                                            fontSize: sp(36.0), 
                                            fontWeight: FontWeight.w600
                                          )
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: px(10.0)),
                                  ),
                                  Text.rich(
                                    TextSpan(text: '截止时间：',
                                      style: TextStyle(fontSize: sp(24.0)),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: "${dateUtc(item['time'])}",
                                          style: TextStyle(
                                            fontSize: sp(30.0), 
                                            fontWeight: FontWeight.w500
                                          )
                                        )
                                      ],
                                    ),
                                  ),
                                ]
                              ),
                            )
                          ]
                        )
                      )
                    )
                  ]
                ),
              ),
            )
          );
        }).toList(),
      )
    );
  }
}