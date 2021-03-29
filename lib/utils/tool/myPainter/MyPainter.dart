import 'package:flutter/material.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';
///我的 canvas半圆背景
class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Color(0xff5683FF);
    const PI = 3.1415926;

    Rect rect2 = Rect.fromCircle(center: Offset(200.0, -100.0), radius: px(600));
    canvas.drawArc(rect2, 0.0, PI, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}