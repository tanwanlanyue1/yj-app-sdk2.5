import 'package:flutter/material.dart';
import 'package:scet_app/pages/AlarmModule/components/WidgetCards.dart';
import 'package:scet_app/pages/alarmModule/components/WidgetCheck.dart';
import 'package:scet_app/utils/api/Api.dart';
import 'package:scet_app/utils/api/Request.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';

class MonitorTask extends StatefulWidget {
  final Map data;
  MonitorTask({
    this.data,
  });
  @override
  _MonitorTaskState createState() => _MonitorTaskState();
}

class _MonitorTaskState extends State<MonitorTask> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;
  List _monitorTaskList = []; // 监测列表
  int _showIndex = -1; //当前展开的下标

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getEventTaskList(5); // 监测任务列表

  }
  void _getEventTaskList(type)async {
    Map<String, dynamic> _data = Map();
    _data['code'] = widget.data['eventCode'];
    _data['type'] = type;
    var response = await Request().get(Api.url['taskList'], data: _data);
    if(response['code'] == 200 && mounted){
      _monitorTaskList = response['data'];
      setState(() {});
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: px(24.0)),
        child: ListView(
          children: [
            Column(
              children: [
                WidgetCheck.miniTitle(
                    '监测任务',
                    icon:'assets/icon/alarm/MonitorTask.png'
                ),
                WidgetCheck.fromCard(
                    child: Column(
                        children: _monitorTaskList.asMap().keys.map((index) {
                          return WidgetCards(
                            type: 5,
                            title: _monitorTaskList[index]['name'],
                            status: _monitorTaskList[index]['status'].toString(),
                            code: _monitorTaskList[index]['code'],
                            event: _monitorTaskList[index]['relationCode'],
                            time: _monitorTaskList[index]['executionStartTime'],
                            executor: _monitorTaskList[index]['publisher'],
                            index: index,
                            showIndex: _showIndex,
                            callBackIndex: (index){
                              _showIndex = index;
                              setState(() {});
                            },
                          );
                        }).toList()
                    )
                )
              ],
            )
          ],
        )
    );;
  }
}