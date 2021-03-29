import 'package:flutter/material.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';

/// 骨架屏的封装类
class CasingPly{

  // 样式集合
  static String _loading1 = 'assets/images/loading/loading1.png';
  static String _loading2 = 'assets/images/loading/loading2.png';
  static String _loading3 = 'assets/images/loading/loading3.png';
  static String _loading4 = 'assets/images/loading/loading4.png';

  // 加载1
  static Widget casingPly1({int length = 4}){
    return bgDiv(
      child: Column(
        children: _listLoading(
          length: length,
          item: Container(
            margin: EdgeInsets.fromLTRB(px(24), px(24), px(24), 0),
            child: Image.asset(_loading1,width: px(702),height: px(307),fit: BoxFit.fill)
          )
        ),
      )
    );
  }

  // 加载2
  static Widget casingPly2({int length = 4}){
    return bgDiv(
      child: Column(
        children: _listLoading(
          length: length,
          item: Container(
            margin: EdgeInsets.fromLTRB(px(24), px(24), px(24), 0),
            child: Image.asset(_loading2,width: px(702),height: px(296),fit: BoxFit.fill,),
          )
        ),
      )
    );
  }

  // 加载3
  static Widget casingPly3({int length = 1}){
    return bgDiv(
      child: Column(
        children: _listLoading(
          length: length,
          item: Container(
            margin: EdgeInsets.fromLTRB(px(24), px(24), px(24), 0),
            child: Column(
              children: [
                bgContainer(
                  width: 702.0,
                  height: 78.0
                ),
                Container(
                  height: px(108),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: _listLoading(
                      item: bgContainer(
                        width: 244.0,
                        height: 108.0,
                        marginR:24.0,
                      ),
                      length: 3
                    )
                  ),
                ),
                Image.asset(_loading3,width: px(702),height: px(878),fit: BoxFit.fill,),
              ],
            )
          )
        ),
      )
    );
  }

  // 加载4
  static Widget casingPly4({int length = 4}){
    return bgDiv(
      child:  Column(
        children: _listLoading(
          length: length,
          item: Container(
            margin: EdgeInsets.fromLTRB(px(24), px(24), px(24), 0),
            child: Image.asset(_loading4,width: px(702),height: px(502),fit: BoxFit.fill,),
          )
        ),
      )
    );
  }
  // 白色 滑动背景
  static Widget bgDiv({Widget child}){
    return Container(
      color: Colors.white,
      child:SingleChildScrollView(
        child:child
      ),
    );
  }

  // 个数的 统一循环处理
  static List<Widget> _listLoading({int length,Widget item}){
    List<Widget> li =[];
    for(var i = 0; i < length; i++){
      li.add(item);
    }
    return li;
  }

  // 抽离的 每个小盒子
  static Widget bgContainer({
    double width,
    double height,
    double marginL = 0.0,
    double marginT = 0.0,
    double marginR = 0.0,
    double marginB = 24.0,
    double radius = 16.0,
  }){
    return Container(
      width: px(width),
      height: px(height),
      margin: EdgeInsets.fromLTRB(px(marginL), px(marginT), px(marginR), px(marginB)),
      decoration: BoxDecoration(
        color: Color(0xFFF2F4F7),
        borderRadius: BorderRadius.all(Radius.circular(px(radius)))
      ),
    );
  }
}