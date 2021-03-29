import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';

class NoData extends StatelessWidget {
  bool timeType;
  String state;
  NoData({this.timeType = false, this.state});
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(top: px(24.0)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(px(12.0)))),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: px(50.0), horizontal: px(24.0)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(px(10.0))),
          gradient: LinearGradient(
            colors: [Color(0XFF3992F5), Color(0XFF8267F0)]
          ),
        ),
        child: timeType 
        ? 
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                '${state}', 
                style: TextStyle(
                  fontSize: sp(32.0), 
                  color: Colors.white)
              ),
              Text(
                '${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())}', 
                style: TextStyle(
                  fontSize: sp(24.0), 
                  color: Colors.white
                )
              )
            ],
          )
        :
          Center(
            child: Text(
              '${state}',
              style: TextStyle(
                fontSize: sp(32.0),
                color: Color(0XFFFFFFFF)
              )
            ),
          )
      )
    );
  }
}