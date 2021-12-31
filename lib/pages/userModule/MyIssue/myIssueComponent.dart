import 'package:flutter/material.dart';
import 'package:scet_app/components/Status.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';

class MyIssueComponent {

  static Widget card({
    Color color = Colors.white,
    required Widget child,
    double paddingAll = 24.0,
    double marginAll = 24.0,
  }) {
    return Container(
      width: double.infinity,
      margin:EdgeInsets.fromLTRB(px(paddingAll), px(paddingAll), px(paddingAll), 0.0),
      padding: EdgeInsets.all(px(paddingAll)),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(px(16)))
      ),
      child: child,
    );
  }

  ///检修任务 标题
  static Widget maintenanceTitle({
    required String title,
    String? status,
    Function? onDetails
  }) {
    return Container(
      height: px(68),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                color: Color(0xff2E2F33),
                fontSize: sp(30),
                fontFamily: "M" ),
          ),
         if(status != null) Status(
           status: status,
         ),
          if(onDetails != null) InkWell(
            onTap: (){
              onDetails.call();
            },
            child: Row(
              children: [
                Text('详情',style: TextStyle(fontSize: sp(24),color: Color(0xff909399)),),
                Icon(Icons.keyboard_arrow_right,color: Color(0xff909299),size: sp(30),)
              ],
            ),
          )
        ],
      ),
    );
  }
  ///标题 加 内容
  static Widget rowItem({bool isCenter = true, String? title, String? data}){
    return Padding(
      padding: EdgeInsets.only(top: px(10.0)),
      child: Row(
        children: [
          Container(
              width: px(133),
              child: Text(
                  '${title}:',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: Color(0XFF787A80),
                    fontSize: sp(26.0),
                  )
              )
          ),
          Expanded(
              child: Text(
                  '$data',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Color(0XFF2E2F33),
                    fontSize: sp(28.0),
                    // height: 1.3
                  )
              ),
          )
        ],
        crossAxisAlignment: isCenter?CrossAxisAlignment.center:CrossAxisAlignment.start,
      ),
    );
  }
}
