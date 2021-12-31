import 'package:cs_app/components/NoData.dart';
import 'package:flutter/material.dart';
import 'package:cs_app/api/Api.dart';
import 'package:cs_app/api/Request.dart';
import 'package:cs_app/components/ToastWidget.dart';
import 'package:cs_app/pages/ModuleAlarm/Components/ListAlarm.dart';
import 'package:cs_app/utils/screen/screen.dart';

class StationCount extends StatefulWidget {
  _StationCount createState() => _StationCount();
}

class _StationCount extends State<StationCount> {

  // 站点信息
  List stationList = [];
  _realStationInfo() async{
    var response = await Request().get(Api.url['realStationInfo']);
    if(response['code'] == 200) {
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
    Map<String, dynamic> data = {
      'withoutMiscalculation':1,
    };
    var response = await Request().get(Api.url['alarmCount'], data : data);
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


  // // 获取单个站点当天警情
  // void _getHistory(stId, stName) async {
  //   Map<String, dynamic> params = Map();
  //   params['stId'] = stId;
  //   params['type'] = '1';
  //   var response = await Request().get(Api.url['historyAlarm'], data: params);
  //   if(response['code'] == 200) {
  //     List data = [];
  //     response['data'].forEach((item) {
  //       if(item['warnStatus'] != null  && item['warnStatus'] != 1) {
  //         data.add(item);
  //       }else if(item['status'] != 2 &&  item['alarmStatus'] != 2) {
  //         data.add(item);
  //       }
  //     });
  //     if(response['data'].length > 0) {
  //       return showModalBottomSheet(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return Container(
  //             height: px(580.0),
  //             child: ListView(
  //               children: <Widget>[
  //                 Padding(
  //                   padding: EdgeInsets.symmetric(vertical: 5.0),
  //                   child: Text(
  //                     '$stName实时报警情况',
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.w600,
  //                       fontSize: sp(30.0),
  //                     ),
  //                     textAlign: TextAlign.center,
  //                   ),
  //                 ),
  //                 data.length > 0 ? ListAlarm(alarmData: data) : NoData(timeType: true, state: '当前无报警情况！'),
  //               ],
  //             ),
  //           );
  //         }
  //       );
  //     } else {
  //       return ToastWidget.showToastMsg('$stName今日无报警情况！');
  //     }
  //   }
  // }

  // 获取单个站点当天警情

  void _getHistory(stId, stName) async {
    Map<String, dynamic> params = Map();
    params['stId'] = stId;
    params['withoutMiscalculation'] = 1;
    var response = await Request().get(Api.url['threshold'], data: params);
    if(response['code'] == 200) {
      List data = response['data'];
      if(response['data'].length > 0) {
        return showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                height: px(580.0),
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                      child: Text(
                        '$stName当日最高报警情况',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: sp(30.0),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    data.length > 0 ? ListAlarm(alarmData: data) : NoData(timeType: true, state: '当前无报警情况！'),
                  ],
                ),
              );
            }
        );
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
          Map weather = stationList[index]['weather'];
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
                          ? 
                            [Color(0XFFFF8034), Color(0XFFFDA93F)] 
                          : 
                            [Color(0XFF1FD178), Color(0XFF4CC5A4)], 
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
                              Text(
                                '${stationList[index]['stName']}', 
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: sp(34.0)
                                )
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
                              Text.rich(
                                TextSpan(text: '温度：',
                                  style: TextStyle(fontSize: sp(24.0)),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '${(weather ==null || weather['temp'] == null ) ? "-" : weather['temp'].toStringAsFixed(1)}℃',
                                      style: TextStyle(
                                        fontSize: sp(28.0), 
                                        fontWeight: FontWeight.w500
                                      )
                                    )
                                  ],
                                ),
                              ),
                              Text.rich(
                                TextSpan(text: '风向：',
                                  style: TextStyle(fontSize: sp(24.0)),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '${(weather ==null || weather['wdExpl'] == null) ? '-' : weather['wdExpl']}',
                                      style: TextStyle(
                                        fontSize: sp(28.0), fontWeight: FontWeight.w500
                                      )
                                    )
                                  ],
                                ),
                              ),
                              Text.rich(
                                TextSpan(text: '风速：',
                                  style: TextStyle(fontSize: sp(24.0)),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '${(weather ==null || weather['ws'] == null) ? "-" : weather['ws'].toStringAsFixed(1)}m/s',
                                      style: TextStyle(
                                        fontSize: sp(28.0), 
                                        fontWeight: FontWeight.w500
                                      )
                                    )
                                  ],
                                ),
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

}