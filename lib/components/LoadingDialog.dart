import 'package:flutter/material.dart';
import 'package:scet_dz/utils/screen/screen.dart';

class LoadingDialog extends Dialog {
  final String? text;
  LoadingDialog({this.text});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(px(20.0)))
            )
          ),
          width: px(200.0),
          height: px(200.0),
          padding: EdgeInsets.all(px(20.0)),
          child: Column(children: <Widget>[
            CircularProgressIndicator(),
            Text(
              text ?? '正在加载...',
              style: TextStyle(
                fontSize: sp(24.0),
                color: Colors.grey
              ),
              softWrap: false
            )
          ],mainAxisAlignment: MainAxisAlignment.spaceEvenly,),
        ),
      ),
    );
  }
}