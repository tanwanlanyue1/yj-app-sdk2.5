import 'package:flutter/material.dart';
import 'package:scet_app/utils/tool/colorTheme/colorTheme.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';

//状态角标
class Status extends StatefulWidget {
  final String status; //事件状态(0,进行中 1,已结束 )
  Status({this.status = '1'});

  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: px(100),
      height: px(36),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: statusColorTheme(widget.status, bgColor: true),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(px(15)),
            bottomRight: Radius.circular(px(15)),
          )),
      child: Text(
        '${widget.status == '0' ? '进行中' : widget.status == '1' ? '已完成' : '未开始'}',
        style:
            TextStyle(color: statusColorTheme(widget.status,), fontSize: sp(22)),
      ),
    );
  }
}
