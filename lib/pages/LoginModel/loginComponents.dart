import 'package:flutter/material.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';

///登录页组件
class LoginComponents{
  ///输入框
  static Widget loginInput({
    required String icon,
    required String hitStr,
    bool isPassWord = false,
    Function? onChange,
  }) {
    return Container(
      width: px(550),
      height: px(113),
      padding: EdgeInsets.only(left: px(24)),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(width: px(1), color: Color(0x4DA8ABB3))
          )
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            icon,
            width: px(40),
            height: px(40),
          ),
          Expanded(
            child: TextField(
              style: TextStyle(
                  fontSize: sp(28.0),
                  textBaseline: TextBaseline.ideographic
              ),
              obscureText: isPassWord,
              onChanged: (val){
                onChange?.call(val);
              },
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(top: px(10), left: px(15.0)),
                  border: InputBorder.none,
                  hintText: hitStr,
                  hintStyle: TextStyle(
                      fontSize: sp(28), color: Color(0xFFA8ABB3))),
            ),
          )
        ],
      ),
    );
  }
///登录按钮
  static Widget loginBtn({Function? onTap}){
    return Padding(
      padding: EdgeInsets.only(top: px(120)),
      child:  InkWell(
        child: Container(
          width: px(550),
          height: px(76),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Color(0xffFF4D7CFF),
              borderRadius: BorderRadius.all(Radius.circular(px(38)))),
          child: Text(
            '登录',
            style: TextStyle(color: Colors.white, fontSize: sp(32)),
          ),
        ),
        onTap: (){
          onTap?.call();
        },
      ),
    );
  }
}