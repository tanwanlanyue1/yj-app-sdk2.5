import 'package:flutter/material.dart';
import 'package:scet_app/pages/AlarmModule/components/WidgetCards.dart';
import 'package:scet_app/pages/alarmModule/components/WidgetCheck.dart';
import 'package:scet_app/utils/api/Api.dart';
import 'package:scet_app/utils/api/Request.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';

class InspectTask extends StatefulWidget {
  final Map data;
  InspectTask({
    this.data,
  });
  @override
  _InspectTaskState createState() => _InspectTaskState();
}

class _InspectTaskState extends State<InspectTask> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  List _taskList = []; // 核查列表
  int _showIndex = -1; //当前展开的下标
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getEventTaskList(4); // 核查任务列表
  }

  /// 核查任务列表
  void _getEventTaskList(type)async {
    Map<String, dynamic> _data = Map();
    _data['code'] = widget.data['eventCode'];
    _data['type'] = type;
    var response = await Request().get(Api.url['taskList'], data: _data);
    if(response['code'] == 200 && mounted){
      _taskList = response['data'];
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
                    '核查任务',
                    icon: 'assets/icon/alarm/InspectTask.png'
                ),
                WidgetCheck.fromCard(
                    child: Column(
                        children: _taskList.asMap().keys.map((index) {
                          return WidgetCards(
                            type: 4,
                            title: _taskList[index]['name'],
                            status: _taskList[index]['status'].toString(),
                            code: _taskList[index]['code'],
                            event: _taskList[index]['relationCode'],
                            explain: _taskList[index]['verificationExplain'],
                            time: _taskList[index]['executionStartTime'],
                            executor: _taskList[index]['publisher'],
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
    );
  }
}