import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

//适配像素类工具封装
screen(num, context) {
  MediaQueryData mediaQuery = MediaQuery.of(context);
  var _pixelRatio = mediaQuery.devicePixelRatio; //密度比
  var widths = mediaQuery.size.width;
  double dp = num * widths / 1334;
  return dp;
}

class Adapt {
  static MediaQueryData mediaQuery = MediaQueryData.fromWindow(window);
  static double _width = mediaQuery.size.width;
  static double _height = mediaQuery.size.height;
  static double _topbarH = mediaQuery.padding.top;
  static double _botbarH = mediaQuery.padding.bottom;
  static double _pixelRatio = mediaQuery.devicePixelRatio;
  static var _ratio;
  static init(int number) {
    int uiwidth = number is int ? number : 750;
    _ratio = _width / uiwidth;
  }

  static px(number) {
    if (!(_ratio is double || _ratio is int)) {
      Adapt.init(750);
    }
    return number * _ratio;
  }

  static onepx() {
    return 1 / _pixelRatio;
  }

  static screenW() {
    return _width;
  }

  static screenH() {
    return _height;
  }

  static padTopH() {
    return _topbarH;
  }

  static padBotH() {
    return _botbarH;
  }
}

//appPading安全顶部距离 内边距
appTop(context){
  return EdgeInsets.only(top: MediaQuery.of(context).padding.top);
}
appTopPadding(context){
  return MediaQuery.of(context).padding.top;
}

/*
  ScreenUtil.pixelRatio       //设备的像素密度
  ScreenUtil.screenWidth      //设备宽度
  ScreenUtil.screenHeight     //设备高度
  ScreenUtil.bottomBarHeight  //底部安全区距离，适用于全面屏下面有按键的
  ScreenUtil.statusBarHeight  //状态栏高度 刘海屏会更高  单位px
  ScreenUtil.textScaleFactor //系统字体缩放比例

  ScreenUtil().scaleWidth  // 实际宽度的dp与设计稿px的比例
  ScreenUtil().scaleHeight // 实际高度的dp与设计稿px的比例
*/

/// 设置宽度
double Width(double width) {
  return ScreenUtil().setWidth(width);
}

/// 设置宽度
double Height(double height) {
  return ScreenUtil().setHeight(height);
}

/// 设置字体尺寸
double fontsize(fontSize) {
  return ScreenUtil().setSp(fontSize);
}

/// 设置像素px
double px(number) {
  return Adapt.px(number);
}

/// 设置PT
double pt(number) {
  return Adapt.px(number * 4);
}

/// 设置sp字体
double sp(number) {
  return ScreenUtil().setSp(number);
}
