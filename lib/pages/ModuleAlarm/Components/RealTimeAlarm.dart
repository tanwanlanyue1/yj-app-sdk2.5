import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cs_app/api/Api.dart';
import 'package:cs_app/api/Request.dart';
import 'package:cs_app/components/NoData.dart';
import 'package:cs_app/pages/ModuleAlarm/Components/ListAlarm.dart';
import 'package:cs_app/utils/screen/screen.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:cs_app/utils/easyRefresh/easyRefreshs.dart';

class RealTimeAlarm extends StatefulWidget {
  _RealTimeAlarmState createState() => _RealTimeAlarmState();
}

class _RealTimeAlarmState extends State<RealTimeAlarm> {

  List realAlarm = [], historyAlarm = [];
  EasyRefreshController _controller = EasyRefreshController(); // 上拉组件控制器
  bool _enableLoad = true; // 是否开启加载
  int _total = 10;
  int _pageNo =1;

  // 获取警情消息
  void _getRealTimeAlarm({typeStatus? type}) async{
    Map<String, dynamic> params = Map();
    params['type'] = 'realTime';
    params['pageNo'] = _pageNo;
    params['pageSize'] = 10;
    params['status'] = jsonEncode([0,1]);
    var response = await Request().get(Api.url['table'], data: params);
    // var response = await Request().get(Api.url['realtimeAlarm']);
    if(response['code'] == 200) {
      _pageNo++;
      List data = response['data']["data"];
      _total = response['data']["total"];
      data.forEach((item) {
        item['type'] = 'realtime';
      });
      setState(() {});
      if (mounted) {
        if(type == typeStatus.onRefresh) {
          // 下拉刷新
          refreshPage(data);
        }else if(type == typeStatus.onLoad) {
          // 上拉加载
          _onLoad(data);
        }
      }
    }
  }

  //刷新页面
  void refreshPage(List data) {
    realAlarm = data;
    _enableLoad = true;
    _controller.resetLoadState();
    _controller.finishRefresh();
    if(realAlarm.length >= _total){
      _controller.finishLoad(noMore: true);
    }
    setState(() {});
  }
  // 上拉加载
  _onLoad(List data) {
    realAlarm.addAll(data);
    _controller.finishLoadCallBack!();
    if(realAlarm.length >= _total){
      _controller.finishLoad(noMore: true);
      _enableLoad = false;
    }
    setState(() {});
  }

  @override
  void initState() {
    _getRealTimeAlarm(type: typeStatus.onRefresh);
    // _getHistoryAlarm();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          // 现时警情情况
          realAlarm.length > 0 ?
          Expanded(
            child: EasyRefresh(
              enableControlFinishRefresh: true,
              enableControlFinishLoad: true,
              topBouncing: true,
              controller: _controller,
              taskIndependence: false,
              header: headers(),
              footer: footers(),
              onRefresh: () async{
                _pageNo = 1;
                _getRealTimeAlarm(type: typeStatus.onRefresh,);
              },
              onLoad:  _enableLoad ? () async {
                _getRealTimeAlarm(type: typeStatus.onLoad);
              } : null,
              child: ListAlarm(alarmData: realAlarm),
            ),
          ) :
          NoData(timeType: true, state: '现时暂无异常数据！'),
          // // 以下是历史
          // Visibility(
          //   visible: historyAlarm.length > 0,
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: <Widget>[
          //       Container(
          //         padding: EdgeInsets.only(top: 30, bottom: 12),
          //         child: Text(
          //           '———— 以下是近七天警情 ————',
          //           style: TextStyle(
          //             color: Color(0XFF707070), 
          //             fontSize: sp(24.0)
          //           ),
          //           textAlign: TextAlign.center,
          //         )
          //       ),
          //       ListAlarm(alarmData: historyAlarm) 
          //     ],
          //   ) 
          // )
        ],
      ),
    );
  }
}