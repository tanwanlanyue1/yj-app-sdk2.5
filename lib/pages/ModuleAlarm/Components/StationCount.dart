import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:scet_dz/utils/easyRefresh/easyRefreshs.dart';
import 'package:scet_dz/api/Api.dart';
import 'package:scet_dz/api/Request.dart';
import 'package:scet_dz/components/ToastWidget.dart';
import 'package:scet_dz/pages/ModuleAlarm/Components/ListAlarm.dart';
import 'package:scet_dz/utils/screen/screen.dart';

class StationCount extends StatefulWidget {
  _StationCount createState() => _StationCount();
}

class _StationCount extends State<StationCount> {

  // 站点信息
  List stationList = [];
  int _pageNo = 1, _total = 10; // 分页
  _realStationInfo() async{
    var response = await Request().get(Api.url['realStationInfo']);
    if(response['code'] == 200) {
      print('response===========$response');
      /** pc站點兼容操作**/
      response['data'].forEach((item){
        item['stId'] = item['oldId'];
      });
      List data = response['data'];
      data.forEach((item) {
        item['type'] = 'history';
      });
      _realAlarmNumber(data);
    }
  }
  _realAlarmNumber(List stationData) async{
    var response = await Request().get(Api.url['alarmCount'] + '?type=day');
    if(response['code'] == 200) {
      List data = response['data'];
      stationData.forEach((station) {
        station['alarmSum'] = 0;
        data.forEach((items) {
          if(station['stId'] == items['stId']) {
            station['alarmSum'] = items['count'];
          }
        });
      });
      stationData.sort((a, b) {
        return int.parse(b['alarmSum'].toString()).compareTo(int.parse(a['alarmSum'].toString()));
      });
      this.setState(() {
        stationList = stationData;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _realStationInfo();
  }


  // 获取单个站点当天警情
  void _getHistory(stId, stName) async {
    Map<String, dynamic> params = Map();
    params['stId'] = stId;
    params['type'] = 'realTime';
    params['pageNo'] = _pageNo;
    params['pageSize'] = 10;
    var response = await Request().get(Api.url['table'], data: params);
    if(response['code'] == 200) {
      List data = response['data']["data"];
      _total = response["data"]["total"];
      if(data.length > 0) {
        return showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return ShowMoudle(
                data:  data,
                total: _total,
                stId:stId,
              );
            });
      } else {
        return ToastWidget.showToastMsg('$stName今日无报警情况！');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFEEEEEE),
      child: ListView.builder(
        padding: EdgeInsets.only(top: 20.0),
        itemCount: stationList.length,
        itemBuilder: (context, index) {
          Map? weather = stationList[index]['weather'];
          return InkWell( 
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))
              ),  //设置圆角
              margin: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center, 
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: px(30.0), 
                      vertical: px(40.0)
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0), 
                        bottomLeft: Radius.circular(8.0)
                      ),
                      gradient: LinearGradient(
                          colors: stationList[index]['alarmSum'] > 0
                              ? [Color(0XFFFF8034), Color(0XFFFDA93F)]
                              : [Color(0XFF1FD178), Color(0XFF4CC5A4)],
                        begin: FractionalOffset(0, 1), 
                        end: FractionalOffset(1, 0)
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center, 
                      children: <Widget>[
                        Text(
                          '今日预警', 
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: sp(30.0)
                          )
                        ),
                        Text(
                            '${stationList[index]['alarmSum']}',
                            style: TextStyle(
                            color: Colors.white, 
                            fontSize: sp(56.0), 
                            fontWeight: FontWeight.w600)
                          )
                      ]
                    )
                  ), 
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center, 
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center, 
                            children: <Widget>[
                              Expanded(
                                  child: Text(
                                      '${stationList[index]['stName']}',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: sp(30.0)
                                      )
                                  ),
                              ),
                              Text(
                                '${stationList[index]['status'] == 1 ? '正常' : '停用'}', 
                                style: TextStyle(
                                  color: Colors.grey, 
                                  fontSize: sp(30.0)
                                )
                              )
                            ]
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center, 
                            children: <Widget>[
                              _itemWeatherData(
                                  title: '温度',
                                  value: (weather != null && weather['temp'] != null) ? weather['temp'].toStringAsFixed(1) : "-",
                                  unit: '℃'
                              ),
                              _itemWeatherData(
                                  title: '风向',
                                  value: (weather != null && weather['wdExpl'] != null) ? weather['wdExpl'] : "-",
                                  unit: ''
                              ),
                              _itemWeatherData(
                                  title: '风速',
                                  value: (weather != null && weather['ws'] != null) ? weather['ws'].toStringAsFixed(1) : "-",
                                  unit: 'm/s'
                              ),
                            ]
                          ),
                        ]
                      )
                    )
                  )
                ]
              ),
            ),
            onTap: () {
              _getHistory(stationList[index]['stId'], stationList[index]['stName']);
            }
          );
        },
      )
    );
  }

  Widget _itemWeatherData({String? title, String? value, String? unit}) {
    return Text.rich(
      TextSpan(text: '$title：',
        style: TextStyle(fontSize: sp(24.0),),
        children: <TextSpan>[
          TextSpan(
              text: '$value$unit',
              style: TextStyle(
                  fontSize: sp(28.0),
                  fontWeight: FontWeight.w500
              )
          )
        ],
      ),
    );
  }
}

class ShowMoudle extends StatefulWidget {
  final List data;
  final int total;
  final stId;
  ShowMoudle({required this.data,required this.total,this.stId});

  @override
  _ShowMoudleState createState() => _ShowMoudleState();
}

class _ShowMoudleState extends State<ShowMoudle> {

  EasyRefreshController _controller = EasyRefreshController(); // 上拉组件控制器
  bool _enableLoad = true; // 是否开启加载
  int _total = 0;
  int _pageNo = 2;
  List siteData  = [];

  //刷新页面
  refreshPage(List data) {
    siteData = data;
    _enableLoad = true;
    _controller.resetLoadState();
    _controller.finishRefresh();
    if(siteData.length >= _total){
      _controller.finishLoad(noMore: true);
    }
    setState(() {});
  }
// 上拉加载
  _onLoad(List data) {
    if(mounted){
      siteData.addAll(data);
      _controller.finishLoadCallBack!();
      if(siteData.length >= _total){
        _controller.finishLoad(noMore: true);
        _enableLoad = false;
        ToastWidget.showToastMsg('暂无更多报警情况！');
      }
    }
    setState(() {});
  }
// 获取单个站点当天警情
  void _getHistory(stId,{typeStatus? type}) async {
    Map<String, dynamic> params = Map();
    params['stId'] = stId;
    params['type'] = 'realTime';
    params['pageNo'] = _pageNo;
    params['pageSize'] = 10;
    var response = await Request().get(Api.url['table'], data: params);
    if (response['code'] == 200) {
      _pageNo++;
      if(type == typeStatus.onRefresh) {
        // 下拉刷新
        if(response['data']['data'].length>0){
          refreshPage(response['data']['data']);
        }else{
          ToastWidget.showToastMsg('暂无更多报警情况！');
        }
      }else if(type == typeStatus.onLoad) {
        // 上拉加载
        _onLoad(response['data']['data']);
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _total = widget.total;
    siteData = widget.data;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: px(800.0),
      child: EasyRefresh(
        enableControlFinishRefresh: true,
        enableControlFinishLoad: true,
        firstRefresh: true,
        topBouncing: true,
        controller: _controller,
        taskIndependence: false,
        header: headers(),
        footer: footers(),
        onRefresh:() async{
          _pageNo = 1;
          _getHistory(widget.stId,type: typeStatus.onRefresh,);
        },
        onLoad: _enableLoad ? () async{
          _getHistory(widget.stId,type: typeStatus.onLoad,);
        } :null,
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0),
              child: Text(
                '当日报警情况',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: sp(30.0),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            ListAlarm(alarmData: siteData)
          ],
        ),
      ),
    );
  }
}