import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scet_dz/utils/screen/screen.dart';
import '../utils/dateUtc/dateUtc.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DateRange extends StatefulWidget {
  final DateTime start;
  final DateTime end;
  final callBack;
  DateRange({Key? key, required this.start, required this.end, this.callBack}):super(key: key);

  @override
  _DateRangeState createState() => _DateRangeState();
}

class _DateRangeState extends State<DateRange> {

  String? startTime, endTime;
  DateTime? initFirstDate, initLastDate;

  @override
  void initState() {
    startTime = formatTime(widget.start);
    endTime = formatTime(widget.end);
    initFirstDate = DateTime(widget.start.year-50,widget.start.month,);
    initLastDate = DateTime(widget.start.year+50,widget.start.month,);
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
            startTime == null ?  
              Text(
                '请选择时间区间', 
                style: TextStyle(
                  fontSize: sp(28.0),
                  color: Color(0XFFA8ABB3)
                )
              ) 
            : 
              Expanded(
                child: Text(
                  '$startTime~$endTime', 
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(22.0),
                    color: Color(0XFF585858)
                  ),
                  overflow: TextOverflow.ellipsis,
                )
              ),
            Padding(
              padding: const EdgeInsets.only(left: 2.0),
              child: Icon(
                Icons.date_range, 
                size: sp(30.0),
                color: Color(0XFF8A8E99)
              ),
            )
          ],
        ),
        onPressed: () async {
          DateTime start = DateTime.parse(startTime!);
          DateTime end = DateTime.parse(endTime!);
          return showDialog(context: context, builder: (context){
            return GestureDetector(
              child: Container(
                  color: Colors.transparent,
                  child: Center(
                    child: Container(
                      height: px(750),
                      width: px(550),
                      child: SfDateRangePicker(
                        selectionMode: DateRangePickerSelectionMode.range,
                        headerHeight: 50,
                        showActionButtons: true,
                        backgroundColor: Colors.white,
                        initialSelectedRange: PickerDateRange(start, end),
                        cancelText: "取消",
                        confirmText: "确定",
                        minDate: initFirstDate,
                        maxDate: initLastDate,
                        onCancel: (){
                          Navigator.pop(context);
                        },
                        onSubmit: (val) async{
                          Navigator.pop(context);
                          List picked = [];
                          if (val is PickerDateRange) {
                            //拿到当天的最后一秒
                            if(val.endDate != null){
                              picked = [
                                val.startDate,
                                DateTime(val.endDate!.year,val.endDate!.month,val.endDate!.day, 23,59,59),
                              ];
                            }else{
                              picked = [
                                val.startDate,
                                DateTime(val.startDate!.year,val.startDate!.month,val.startDate!.day, 23,59,59),
                              ];
                            }
                            widget.callBack?.call(picked);
                            startTime = formatTime(val.startDate);
                            endTime = formatTime(picked[1]);
                            setState(() {});
                          }
                        },
                      ),
                    ),
                  )
              ),
              onTap: (){
                Navigator.pop(context);
              },
            );
          });
          // final List<DateTime> picked = await DateRangePicker.showDatePicker(
          //   context: context,
          //   initialFirstDate: new DateTime.now(),
          //   initialLastDate: (new DateTime.now()).add(new Duration(days: 7)),
          //   firstDate: new DateTime(2018),
          //   lastDate: new DateTime(DateTime.now().year + 2));
          // if (picked != null && picked.length == 2) {
          //   widget.callBack(picked);
          //   setState(() {
          //     startTime = formatTime(picked[0]);
          //     endTime = formatTime(picked[1]);
          //   });
          // }
        }    
      )
    );
  }

  String formatTime(time) {
    return dateUtc(time.toString());
  }
}