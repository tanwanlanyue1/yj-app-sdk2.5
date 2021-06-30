import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'package:scet_app/utils/tool/dateUtc/dateUtc.dart';

class DateRange extends StatefulWidget {
  final DateTime start;
  final DateTime end;
  final callBack;
  DateRange({Key key, this.start, this.end, this.callBack}) : super(key: key);

  @override
  _DateRangeState createState() => _DateRangeState();
}

class _DateRangeState extends State<DateRange> {
  String startTime, endTime;

  @override
  void initState() {
    startTime = formatTime(widget.start);
    endTime = formatTime(widget.end);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: ScreenUtil().setHeight(60.0),
        color: Color(0xffF5F6FA),
        child: OutlineButton(
            borderSide: BorderSide(color: Color(0XffF5F6FA)),
            padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                startTime == null
                    ? Text('请选择时间区间',
                        style: TextStyle(
                            fontSize: sp(28.0), color: Color(0XFFA8ABB3)))
                    : Expanded(
                        child: Text(
                        '$startTime~$endTime',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(22.0),
                            color: Color(0XFF585858)),
                        overflow: TextOverflow.ellipsis,
                      )),
                Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: Icon(Icons.date_range,
                      size: sp(30.0), color: Color(0XFF8A8E99)),
                )
              ],
            ),
            onPressed: () async {
              final List<DateTime> picked =
                  await DateRangePicker.showDatePicker(
                      context: context,
                      initialFirstDate: new DateTime.now(),
                      initialLastDate:
                          (new DateTime.now()).add(new Duration(days: 7)),
                      firstDate: new DateTime(2018),
                      lastDate: new DateTime(DateTime.now().year + 2));
              if (picked != null && picked.length == 2) {
                widget.callBack(picked);
                setState(() {
                  startTime = formatTime(picked[0]);
                  endTime = formatTime(picked[1]);
                });
              }
            }));
  }

  String formatTime(time) {
    return dateUtc(time.toString());
  }
}
