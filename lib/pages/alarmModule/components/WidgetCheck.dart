import 'package:flutter/material.dart';
import 'package:scet_app/components/Status.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';

class WidgetCheck {

  static TextStyle nameStyle = TextStyle(fontSize: sp(30), fontWeight: FontWeight.w600,fontFamily: 'Alibaba-PuHuiTi-M, Alibaba-PuHuiTi');
  
  static Widget miniTitle(String title,{String icon}) {
    return Container(
      margin: EdgeInsets.fromLTRB(px(6.0), px(24.0), 0.0, px(12.0)),
      child: Row(
        children: [
          Image.asset(
            '${icon}',
            width: px(40.0),
            height: px(40.0),
          ),
          Padding(
            padding: EdgeInsets.only(left: px(12.0)),
            child: Text(
              '$title',
              style: TextStyle(
                color: Color(0XFF45474D),
                fontSize: sp(30),
                fontFamily: 'M'
              )
            )
          )
        ]
      )
    );
  }

  static Widget fromCard({Widget child}) {
    return Card(
      color: Color(0xffFFFFFF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all( Radius.circular(px(16.0)))),
      child: Container(
        width: Adapt.screenW(),
        padding: EdgeInsets.symmetric(
          horizontal: px(16.0), 
          vertical: px(32.0), 
        ),
        child: child
      )
    );
  }
  
  static Widget rowItem({bool alignStart = false, bool padding, bool expanded = true, String title, Widget child}) {
    return Padding(
      padding: padding ? EdgeInsets.symmetric(vertical: px(24.0)) : EdgeInsets.zero,
      child: Row(
        crossAxisAlignment: alignStart ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: px(145.0),
            child: Text(
              '$title：',
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: Color(0XFF787A80),
                fontSize: sp(28.0),
                fontWeight: FontWeight.w500
              )
            )
          ),
          expanded ? Expanded(child: child) : child
        ]
      )
    );
  }

  static Widget textData({bool state = true, String data}) {
    return Text(
      '$data',
      style: TextStyle(
        color: state ? Color(0XFF2E2F33) : Color(0XFFA8ABB3),
        fontSize: sp(30.0),
        fontWeight: FontWeight.w500
      )
    );
  }
  
  ///卡片每一行数据
  static Widget rowItem2({bool isCenter = true, String title, String data}){
    return Padding(
      padding: EdgeInsets.only(top: px(10)),
      child: Row(
        children: [
          Container(
              width: px(155),
              child: Text(
                  '${title}:',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: Color(0XFFF0F4FF),
                    fontSize: sp(26.0),
                  )
              )
          ),
          Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: px(3)),
                child: Text(
                    '$data',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Color(0XFFFFFFFF),
                      fontSize: sp(26.0),
                      // height: 1.3
                    )
                ),
              )
          )
        ],
        crossAxisAlignment: isCenter?CrossAxisAlignment.center:CrossAxisAlignment.start,
      ),
    );
  }
}