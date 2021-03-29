import 'package:flutter/material.dart';
/// 注意标识主题颜色配置统一输出 1级 2级 3级 4级
noticeColorTheme(int status) {
  switch(status) {
    case 1:
      return Color(0xff90CC00);
    break;

    case 2:
      return Color(0xffFFDB00);
    break;

    case 3:
      return Color(0xffFF8600);
      break;

    case 4:
      return Color(0xffFF3333);
      break;

    default:
      return Colors.black;
    break;
  }
}

///状态标识 主题颜色配置统一输出  2 未开始 0 进行中 1已完成
statusColorTheme(String status,{bool bgColor = false}){
  /// bgColor 为true输出背景配色 否则输出 字体颜色
  switch(status) {
    case '2':
      return bgColor?Color(0xffD5DFFA):Color(0xff4D7CFF);
      break;

    case '0':
      return bgColor?Color(0xffFFEBCC):Color(0xffF09000);
      break;

    case '1':
      return bgColor?Color(0xffD8DAE0):Color(0xff6B7D99);
      break;

    default:
      return Colors.white;
    break;
  }
}

///状态标识 主题颜色配置统一输出  0 进行中 1已完成 2 未开始
titleTextColor(String status,{bool title = true}) {
  /// title 为true输出标题配色 否则输出 内容字体颜色
  switch(status) {
    case '0':
      return title?Color(0xFF2E2F33):Color(0xFF2E2F33);
      break;

    case '1':
      return title?Color(0xFFA8ABB3):Color(0xFF909399);
      break;

    case '2':
      return title?Color(0xFF2E2F33):Color(0xFF2E2F33);
      break;

    default:
      return Colors.black;
    break;
  }
}