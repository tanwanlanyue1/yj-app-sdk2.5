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
    return new Material(
      type: MaterialType.transparency,
      child: new Center(
        child: new Container(
          decoration: new ShapeDecoration(
            color: Colors.white,
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.all(new Radius.circular(10))
            )
          ),
          width: 100,
          height: 100,
          padding: EdgeInsets.all(10),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CircularProgressIndicator(),
              new Text(
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