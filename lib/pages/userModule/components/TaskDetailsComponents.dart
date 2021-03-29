import 'package:flutter/material.dart';
import 'package:scet_app/components/Status.dart';
import 'package:scet_app/utils/tool/colorTheme/colorTheme.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';
///监测任务详情组件
class TaskComponents{
  ///标题
  static Widget title({String icon = 'assets/images/user/monIcon.png', String title, String status,}) {
    return Container(
      margin: EdgeInsets.fromLTRB(px(24), px(20), px(24), px(20)),
      child: Row(
        children: [
          Container(
            width: px(40),
            height: px(40),
            child: Image.asset(icon),
          ),
          Container(
            margin: EdgeInsets.only(left: px(10), right: px(24)),
            child: Text(
              title,
              style: TextStyle(
                  color: Color(0xff2E2F33),
                  fontFamily: "M",
                  fontSize: sp(30)
              ),
            ),
          ),
          Status(status: status,),
        ],
      ),
    );
  }

  ///每张卡片
  static Widget itemCard({String title,Widget child}){
    return Container(
      margin: EdgeInsets.fromLTRB(px(24),px(0),px(24),px(24)),
      padding: EdgeInsets.all(px(24)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(px(16)))
      ),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: TextStyle(
                fontSize: sp(30),
                fontFamily: "M"
              ),
            ),
          ),
          child??Container()
        ],
      ),
    );
  }

  ///卡片每一行数据
  static Widget itemCardRows({
    bool isCenter = true,//是否居中显示 否则靠上
    bool isName = false,//是否人名
    bool isMap = false,//是否人名
    String title,//标题
    String data,//内容
  }) {
    return Padding(
      padding: EdgeInsets.only(top: px(10)),
      child: Row(
        children: [
          Container(
              width: px(128),
              child: Text(
                  '${title}:',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: Color(0XFF787A80),
                    fontSize: sp(28.0),
                  )
              )
          ),
          Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: px(3)),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                          data,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: isName ? Color(0xff4D7CFF) : Color(0xff2E2F33),
                            fontSize: isName ?sp(28):sp(30.0),
                          )
                      ),
                    ),
                    isMap ? InkWell(
                      onTap: () {},
                      child: Image.asset('assets/images/home/map_button.png',width:px(128),height: px(48) ,),
                    ) : Container()
                  ],
                ),
              )
          )
        ],
        crossAxisAlignment: isCenter ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      ),
    );
  }
}