import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ToastWidget {
  static showToastMsg(String msg) {
    BotToast.showText(
      text: msg,
      align: const Alignment(0, 0),
      borderRadius: BorderRadius.all(Radius.circular(6.0)),
      contentPadding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 10),
      textStyle: TextStyle(
        color: Colors.white,
        fontSize: ScreenUtil().setSp(32.0)
      )
    );
  }
}