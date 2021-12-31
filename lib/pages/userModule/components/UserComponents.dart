import 'package:flutter/material.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';
class UserComments{
  ///  白色背景
  static Widget bgCard({required List<Widget> children }){
    return Container(
      width: px(702.0),
      margin: EdgeInsets.only(bottom: px(24.0)),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(px(16.0))),
          boxShadow: [
            BoxShadow(
                color: Color(0xffE6EAF6),
                offset: Offset(1.0, 1.0), blurRadius: 1.0, spreadRadius: 1.0),
          ]
      ),
        child: Column(
          children: children,
        )
    );
  }
  ///工作台每一项
  static Widget jopItem({required String img, required String title, Function? onTab}) {
    return Expanded(
      child:InkWell(
        onTap: () {
          if( onTab != null ) onTab();
        },
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: px(68.0),
              height: px(68.0),
              margin: EdgeInsets.only(bottom: px(10.0)),
              child: Image.asset(img),
            ),
            Text(
              title,
              style: TextStyle(
                  fontSize: sp(26.0),
                  color: Color(0xff45474D)
              ),
            )
          ],
        ),
      ),
    );
  }
  ///每栏大标题
  static Widget titles({required String title,String? other,Function? onTab}) {
    return Container(
      width: px(702.0),
      height: px(78.0),
      padding: EdgeInsets.only(left:px(20.0),right: px(26.0)),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: sp(30.0),
                fontFamily: "M"
            ),
          ),
          Spacer(),
          InkWell(
            onTap: () {
              if( onTab != null){ onTab(); }
            },
            child: other != null ? Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(other, style: TextStyle(fontSize: sp(24.0), color: Color(0xff909399),),),
                  Icon(Icons.keyboard_arrow_right,color: Color(0xff909399),)
                ],
              ),
            ):Container(),
          )
        ],
      ),
    );
  }
  ///我发布中的每一项
  static Widget releaseItem({required String icon,String? title,Function? onTap}){
    return  Container(
      width: px(100.0),
      margin: EdgeInsets.only(right: px(60.0)),
      child: InkWell(
        child: Column(
          children: [
            Container(
              width: px(68.0),
              height: px(68.0),
              margin: EdgeInsets.only(bottom: px(16.0)),
              child: Image.asset(icon,fit: BoxFit.fill,),
            ),
            Text('$title',style: TextStyle(fontSize: sp(24.0),color: Color(0xFF45474D)),)
          ],
        ),
        onTap:(){
          onTap?.call();
        },
      ),
    );
  }
  ///待办每一行
  static Widget backlogRowItem({
    String icon='assets/images/user/backlog.png',
    required String title,
    String? other,
    Function? onTab
  }) {
    return Container(
      height: px(40.0),
      margin: EdgeInsets.only(bottom: px(22.0)),
      child: Row(
        children: [
          Image.asset(icon,width: px(28.0),height: px(32.0),fit: BoxFit.fill,),
          Container(
            padding: EdgeInsets.only(left: px(10.0)),
            child: Text(title,style: TextStyle(fontSize: sp(28.0),color: Color(0xff2E3033)),),
          ),
          Spacer(),
          InkWell(
            onTap: (){
              if( onTab != null){ onTab();}
            },
            child: other != null ? Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(other, style: TextStyle(fontSize: sp(24.0), color: Color(0xff909399),),),
                  Icon(Icons.keyboard_arrow_right,color: Color(0xff909399),)
                ],
              ),
            ) : Container(),
          )
        ],
      ),
    );
  }
}