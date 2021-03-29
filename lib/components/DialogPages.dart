import 'package:flutter/material.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';

/// 弹出框 类
class DialogPages {
  // 发布成功的弹出框
  static Future succeedDialog(BuildContext context,{
    String title = '发布成功',
    String subTitle = '前往“我发布的”查看详情',
    String backStr = '返回首页',
    String succeedStr = '立即查看',
    Function back, //返回按钮回调
    Function succeed, //成功按钮回调
  }) {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return GestureDetector(
            onTap: () {
              Navigator.of(context).pop(); //退出弹出框
            },
            child: Container(
              child: Material(
                color: Color.fromRGBO(0, 0, 0, 0.5),
                child: Center(
                  child: Container(
                    width: px(540),
                    height: px(625),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/home/bgImage.png'),
                            fit: BoxFit.fill
                        )
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: px(20)),
                                child: Text(
                                  '$title',
                                  style: TextStyle(
                                      fontSize: sp(32),
                                      fontFamily: "M",
                                      color: Color(0xFF2E2F33)),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: px(40)),
                                child: Text(
                                  '$subTitle',
                                  style: TextStyle(
                                      fontSize: sp(22),
                                      fontFamily: "M",
                                      color: Color(0xFFA8ABB3)),
                                ),
                              ),
                              Row(
                                children: [
                                  succeedDialogBtn(
                                    str: backStr,
                                    bgColor:  Color(0xFF8F98B3),
                                    onTap: () {
                                      Navigator.pop(context);
                                      if (back != null) {
                                        back();
                                      }
                                    },
                                  ),
                                  succeedDialogBtn(
                                    str: succeedStr,
                                    bgColor:  Color(0xFF4D7CFF),
                                    onTap: () {
                                      Navigator.pop(context);
                                      if (succeed != null) {
                                        succeed();
                                      }
                                    },
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
        );
      },
    );
  }

  // 弹框的按钮
  static Widget succeedDialogBtn({String str, Function onTap,Color bgColor}){
    return InkWell(
      child: Container(
        width: px(270),
        height: px(86),
        alignment: Alignment.center,
        color:bgColor,
        child: Text(
          '$str',
          style: TextStyle(
              fontSize: sp(30),
              color: Color(0xFFFFFFFF)),
        ),
      ),
      onTap: onTap,
    );
  }
}
