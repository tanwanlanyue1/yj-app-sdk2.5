import 'package:flutter/material.dart';
import 'package:scet_app/components/Status.dart';
import 'package:scet_app/utils/tool/colorTheme/colorTheme.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';
//我的代办相关组件
class BacklogComments{

  static Widget itemCard({
    String status,//状态
    String title,//任务标题
    String taskId,//编号
    String event,//事件
    String explain,//说明
    String time,//时间
    String executor,//执行人
  }) {
    return Container(
      width: px(702),
      margin: EdgeInsets.fromLTRB(px(24), px(0), px(24), px(20)),
      padding: EdgeInsets.fromLTRB(px(20), px(15), px(20), px(20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(px(16)))
      ),
      child: Column(
        children: [
          rowTitle(title:title,status: status),
          rowItems(title: '任务编号',data: taskId,status: status),
          rowItems(title: '关联事件',data: event,status: status),
          rowItems(title: '任务说明',data: explain,status: status,isCenter: false),
          rowItems(title: '执行时间',data: time,status: status),
          rowItems(title: '执 行 人  ',data: executor,status: status),
        ],
      ),
      // child: ,
    );
  }

  ///卡片标题
  static Widget rowTitle({String title,String status}) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
              color: titleTextColor(status),
              fontFamily: "M",
              fontSize: sp(30)
          ),
        ),
        Spacer(),
        Status(status: status,),
        InkWell(
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: px(20)),
                child: Text(
                  status == '0' ? '去执行' : '详情',
                  style: TextStyle(
                      color: Color(0xff909399),
                      fontSize: sp(24)
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: px(5)),
                child: Icon(Icons.keyboard_arrow_right,color:titleTextColor(status),size: sp(35),),
              )
            ],
          ),
          onTap: () {},
        )
      ],
    );
  }

  ///卡片每一行数据
  static Widget rowItems({
    bool isCenter = true,//是否居中显示 否则靠上
    String title,//标题
    String data,//内容
    String status //状态
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
                    color: status == '1'?Color(0xffA8ABB3):Color(0XFF787A80),
                    fontSize: sp(26.0),
                  )
              )
          ),
          Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: px(3)),
                child: Text(
                    data,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: titleTextColor(status,title: false),
                      fontSize: sp(28.0),
                    )
                ),
              )
          )
        ],
        crossAxisAlignment: isCenter ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      ),
    );
  }
}