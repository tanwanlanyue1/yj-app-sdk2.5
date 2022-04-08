import 'package:flutter/material.dart';
import 'package:scet_dz/api/Api.dart';
import 'package:scet_dz/api/Request.dart';
import 'package:scet_dz/components/NoData.dart';
import 'package:scet_dz/pages/ModuleAlarm/Components/ListAlarm.dart';
import 'package:scet_dz/utils/easyRefresh/easyRefreshs.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
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
    var response = await Request().get(Api.url['table'],data: params);
    if(response['code'] == 200) {
      _pageNo++;
      List data = response['data']['data'];
      _total = response['data']["total"];
      if (mounted) {
        if(type == typeStatus.onRefresh) {
          // 下拉刷新
          refreshPage(data);
        }else if(type == typeStatus.onLoad) {
          // 上拉加载
          _onLoad(data);
        }
      }
      setState(() {});
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
    _getRealTimeAlarm();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EasyRefresh(
        firstRefresh: true,
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
        child: realAlarm.isNotEmpty ?
        ListAlarm(alarmData: realAlarm) :
        NoData(timeType: true, state: '现时暂无异常数据！')
      )
    );
  }
}