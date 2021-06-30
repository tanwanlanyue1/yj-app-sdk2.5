import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:intl/intl.dart';
import 'package:scet_app/utils/tool/dateUtc/dateUtc.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';

class TimeSelect extends StatefulWidget {
  final GlobalKey scaffoldKey;
  final DateTime time;
  final String hintText;
  final callBack;
  TimeSelect(
      {Key key, this.scaffoldKey, this.time, this.hintText, this.callBack})
      : super(key: key);

  @override
  _TimeSelectState createState() => _TimeSelectState();
}

class _TimeSelectState extends State<TimeSelect> {
  String currentTime;

  @override
  void initState() {
    super.initState();
    // currentTime = formatTime(widget.time);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: px(56.0),
        color: Color(0xffF5F6FA),
        child: OutlineButton(
          borderSide: BorderSide(color: Color(0xffF5F6FA)),
          padding: EdgeInsets.fromLTRB(px(10.0), 0.0, px(10.0), 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                  child: currentTime == null
                      ? Text('${widget.hintText}',
                          style: TextStyle(
                              fontSize: sp(28.0), color: Color(0XFFB0B2B8)))
                      : Text(
                          '$currentTime',
                          style: TextStyle(
                              fontSize: sp(26.0), color: Color(0XFF585858)),
                          overflow: TextOverflow.ellipsis,
                        )),
              Padding(
                padding: EdgeInsets.only(left: 2.0),
                child: Icon(Icons.date_range,
                    size: sp(24.0), color: Color(0XFF8A8E99)),
              )
            ],
          ),
          onPressed: () {
            showPickerDateTime24(context);
          },
        ));
  }

  showPickerDateTime24(BuildContext context) {
    Picker(
        cancelText: '取消',
        confirmText: '确定',
        selectedTextStyle: TextStyle(color: Colors.blue),
        cancelTextStyle: TextStyle(
            fontSize: sp(28.0),
            fontWeight: FontWeight.w600,
            color: Color(0XFF585858)),
        confirmTextStyle: TextStyle(
            fontSize: sp(28.0),
            fontWeight: FontWeight.w600,
            color: Color(0XFF585858)),
        textStyle: TextStyle(
          color: Color(0XFF585858),
          fontSize: sp(28.0),
        ),
        adapter: DateTimePickerAdapter(
            type: PickerDateTimeType.kYMDHM,
            isNumberMonth: true,
            yearSuffix: "年",
            monthSuffix: "月",
            daySuffix: "日"),
        title: Text("请选择时间",
            style: TextStyle(
                fontSize: sp(28.0),
                fontWeight: FontWeight.w600,
                color: Color(0XFF585858))),
        delimiter: [
          PickerDelimiter(
              column: 3,
              child: Container(
                width: 8.0,
                alignment: Alignment.center,
              )),
          PickerDelimiter(
              column: 5,
              child: Container(
                width: 12.0,
                alignment: Alignment.center,
                child: Text(':', style: TextStyle(fontWeight: FontWeight.bold)),
                color: Colors.white,
              )),
        ],
        onConfirm: (Picker picker, List value) {
          DateTime time = DateTime.parse(
              (picker.adapter as DateTimePickerAdapter).value.toString());
          widget.callBack(time);
          setState(() {
            currentTime = formatTime(time);
          });
        }).show(widget.scaffoldKey.currentState);
  }

  String formatTime(time) {
    return dateUtc(time.toString());
  }
}
