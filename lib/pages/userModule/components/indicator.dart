import 'package:flutter/material.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';

/// 指示器封装
class Indicator extends AnimatedWidget {
  Indicator({
    required this.controller,
    required this.itemCount,
    required this.nowIndex,
  }) : super(listenable: controller);

  /// 滑动控制器
  final PageController controller;

  ///  滑动页面个数
  final int itemCount;

  final int nowIndex;

  static const double _itemWith = 20.0;

  Widget build(BuildContext context) {
    return Container(
      width: itemCount * px(_itemWith) + px(_itemWith),
      height: px(6.0),
      margin: EdgeInsets.only(top: px(20.0)),
      decoration: BoxDecoration(
          color: Color(0xff1A2E4A99),
          borderRadius: BorderRadius.all(Radius.circular(px(4.5)))
      ),
      child: Stack(
        children: [
          Positioned(
            left: px(_itemWith) * (controller.page != null ? controller.page : nowIndex.toDouble())!,
            top: 0.0,
            child: Container(
              width: px(40.0),
              height: px(6.0),
              decoration: BoxDecoration(
                color: Color(0xffFF4D7CFF),
                borderRadius: BorderRadius.all(Radius.circular(px(4.5)))
              ),
            ),
          )
        ],
      ),
    );
  }
}
