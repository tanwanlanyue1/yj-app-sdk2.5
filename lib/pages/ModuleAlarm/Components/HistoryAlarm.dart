import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:scet_dz/utils/easyRefresh/easyRefreshs.dart';
import 'package:scet_dz/utils/storage/data_storageKey.dart';
import 'package:scet_dz/utils/storage/storage.dart';
import 'package:scet_dz/api/Api.dart';
import 'package:scet_dz/api/Request.dart';
import 'package:scet_dz/components/DateRange.dart';
import 'package:scet_dz/components/DownInput.dart';
import 'package:scet_dz/components/NoData.dart';
import 'package:scet_dz/components/WidgetCheck.dart';
import 'package:scet_dz/pages/ModuleAlarm/Components/ListAlarm.dart';
import 'package:scet_dz/utils/screen/screen.dart';

class HistoryAlarm extends StatefulWidget {
  final int? stId;
  HistoryAlarm({Key? key, this.stId}) : super(key: key);
  
  _HistoryAlarmState createState() => _HistoryAlarmState();
}

class _HistoryAlarmState extends State<HistoryAlarm> {

  DateTime _startTime = DateTime.now().add(Duration(days: -7));

  DateTime _endTime = DateTime.now();

  Map _station = {'name': '全部监测站点', 'value': ''}; // 选中项目
  EasyRefreshController _controller = EasyRefreshController(); // 上拉组件控制器
  bool _enableLoad = true; // 是否开启加载
  int _total = 10;
  int _pageNo =1;
  // 获取历史警情
  List historyAlarm = [];
  void _getHistoryAlarm(stId, _startTime, _endTime, {typeStatus? type}) async {
    Map<String, dynamic> params = Map();
    params['stId'] = stId;
    params['startTime'] = _startTime;
    params['endTime'] = _endTime;
    params['pageNo'] = _pageNo;
    params['pageSize'] = 10;
    params['type'] = "history";
    var response = await Request().get(Api.url['table'], data: params);
    if(response['code'] == 200) {
      List data = response['data']["data"];
      _pageNo++;
      _total = response['data']["total"];
      if (mounted) {
        if(type == typeStatus.onRefresh) {
          // 下拉刷新
          refreshPage(data);
        }else if(type == typeStatus.onLoad) {
          // 上拉加载
          _onLoad(response['data']['data']);
        }
      }
      setState(() {});
    }
  }

  //下拉刷新
  void refreshPage(List data) {
    historyAlarm = data;
    _enableLoad = true;
    _controller.resetLoadState();
    _controller.finishRefresh();
    if(historyAlarm.length >= _total){
      _controller.finishLoad(noMore: true);
    }
    setState(() {});
  }
  // 上拉加载
  _onLoad(List data) {
    historyAlarm.addAll(data);
    _controller.finishLoadCallBack!();
    if(historyAlarm.length >= _total){
      _controller.finishLoad(noMore: true);
      _enableLoad = false;
    }
    setState(() {});
  }
  @override
  void initState() {
    super.initState();
    _getStationList();
    // _getHistoryAlarm(0, _startTime, _endTime);
  }

  // 获取站点数据
  List _stationList = [];
  void _getStationList() {
    List? data = StorageUtil().getJSON(StorageKey.RealStationInfo);
    data?.insert(0, {"stName": '全部站点', "stId": ''});
    List? stationList = data?.map((item) {
      return {"name": item['stName'], "value": item['stId'].toString()};
    }).toList();
    setState(() {
      _stationList = stationList ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color(0XFFFFFFFF),
            boxShadow: [
              BoxShadow(
                color: Color(0X0A002480),
                offset: Offset(0, 0),
                blurRadius: 1,
                spreadRadius: 0
              )
            ],
          ),
          padding: EdgeInsets.symmetric(vertical: px(24.0), horizontal: px(48.0)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              WidgetCheck.rowItem(
                padding: false,
                title: '站点数据',
                child: DownInput(
                  hitStr: '请选择监测站点',
                  value: _station['name'],
                  currentData: _station,
                  data: _stationList,
                  callback: (val) {
                    setState(() {
                      _station = val;
                    });
                  }
                )
              ),
              WidgetCheck.rowItem(
                padding: true,
                title: '时间范围',
                child: DateRange(
                  start: _startTime,
                  end: _endTime,
                  callBack: (val) {
                    _startTime = val[0];
                    _endTime = val[1];
                  },
                )
              ),
              Container(
                width: px(120.0),
                height: px(48.0),
                child: GestureDetector(
                  onTap: () {
                    _pageNo = 1;
                    _getHistoryAlarm(_station['value'], _startTime, _endTime,type: typeStatus.onRefresh);
                  },
                  child: Image.asset(
                    'lib/assets/icon/search.png', 
                    fit: BoxFit.cover
                  )
                )
              )
            ],
          )
        ),
        Expanded(
          child: EasyRefresh(
            enableControlFinishRefresh: true,
            enableControlFinishLoad: true,
            topBouncing: true,
            firstRefresh: true,
            controller: _controller,
            taskIndependence: false,
            header: headers(),
            footer: footers(),
              onRefresh: () async{
                _pageNo = 1;
                _getHistoryAlarm(_station['value'], _startTime, _endTime,type: typeStatus.onRefresh);
              },
              onLoad:  _enableLoad ? () async {
                  _getHistoryAlarm(_station['value'], _startTime, _endTime,type: typeStatus.onLoad);
              } : null,
            child: historyAlarm.length > 0 ?
            ListAlarm(alarmData: historyAlarm)
            : NoData(timeType: true, state: '该时间段无异常数据！'),
            )
          ),
      ],
    );
  }
}