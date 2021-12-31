import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  final CancelFunc? cancelFunc;

  const Loading({Key? key, this.cancelFunc}) : super(key: key);

  @override
  _LoadingWidget createState() => _LoadingWidget();
}

class _LoadingWidget extends State<Loading> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          decoration:  ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(  Radius.circular(10))
            )
          ),
          width: 100,
          height: 100,
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CircularProgressIndicator(),
                Text(
                '正在加载...',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey
                ),
                softWrap: false
              )
            ],
          ),
        ),
      )
    );
  }
}