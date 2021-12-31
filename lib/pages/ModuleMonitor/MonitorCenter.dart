import 'package:flutter/material.dart';
import 'package:scet_dz/api/Api.dart';
import 'package:scet_dz/api/Request.dart';
import 'package:scet_dz/utils/screen/Adapter.dart';
import 'package:scet_dz/utils/screen/screen.dart';

class MonitorCenter extends StatefulWidget {
  _MonitorCenter createState() => _MonitorCenter();
}

class _MonitorCenter extends State<MonitorCenter> {

  // 站点信息
  List stationList = [];
  _realStationInfo() async{
    var response = await Request().get(Api.url['realStationInfo']);
    if(response['code'] == 200) {
      /** pc站點兼容操作**/
      response['data'].forEach((item){
        item['stId'] = item['oldId'];
      });
      response['data'].forEach((item){
        List list = [];
        item['factors'].forEach((itemFactors){
          if(itemFactors['mark'] == "N" || itemFactors['mark'] == ''){
            list.add(itemFactors);
          }
        });
        item['factors'] = list;
      });
      List data = response['data'];
      data.sort((a, b) {
        return b['factors'].length.compareTo(a['factors'].length);
      });
      this.setState(() {
        stationList = response['data'];
      });
      // List data = response['data'];
      // _dataSwitch(data);
    }
  }

  // 抽离公共的数据转换部分
  _dataSwitch(List data){
    data.forEach((item) {
      Map weather = {};
      item['facInfo'].forEach((facItem) {
        switch (facItem['type']) {
          case 'ws': weather.addAll({facItem['type']: facItem['value']}); break;
          case 'wd': weather.addAll({facItem['type']: facItem['value'],'explain': facItem['explain']}); break;
          case 'temp': weather.addAll({facItem['type']: facItem['value']}); break;
          case 'rh': weather.addAll({facItem['type']: facItem['value']}); break;
          case 'ap': weather.addAll({facItem['type']: facItem['value']}); break;
        }
      });
      item['weather'] = weather;
    });
    _realFactorNumber(data);
  }

  _realFactorNumber(List stationData) async{
    var response = await Request().get(Api.url['realFactorNum']);
    if(response['code'] == 200) {
      List data = response['data'];
      stationData.forEach((station) {
        station['facSum'] = 0;
        data.forEach((items) {
          if(station['stId'] == items['stId']) {
            station['facSum'] = items['factorSum'];
          } 
        });
      });
      stationData.sort((a, b) {
        return int.parse(b['facSum'].toString()).compareTo(int.parse(a['facSum'].toString()));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(Adapt.screenW(), px(Adapter.topBarHeight)),
        child: AppBar(
          title: Text(
            '监测站点', 
            style: TextStyle(
              color: Colors.white,
              fontSize: sp(40.0)
            )
          ),
          centerTitle: true
        )
      ),
      body: Container(
        child: ListView.builder(
          padding: EdgeInsets.symmetric(vertical: px(30.0)),
          itemCount: stationList.length,
          itemBuilder: (context, index) {
            Map? weather = stationList[index]['weather'];
            return InkWell( 
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                margin: EdgeInsets.fromLTRB(px(16.0), 0.0, px(16.0), px(20.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center, 
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: px(30.0), vertical: px(40.0)),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(px(16.0)), 
                          bottomLeft: Radius.circular(px(16.0))
                        ),
                        gradient: LinearGradient(
                          colors: [Color(0XFF1D7DFE), Color(0XFF1D7DFE)], 
                          begin: FractionalOffset(0, 1), 
                          end: FractionalOffset(1, 0)
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center, 
                        children: <Widget>[
                          Text(
                              '监测因子',
                              style: TextStyle(
                                color: Colors.white,
                                  fontSize: sp(30.0)
                              )
                          ),
                          Text(
                              '${stationList[index]['factors'].length}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: sp(56.0),
                                  fontWeight: FontWeight.w600
                              )
                          ),
                        ]
                      )
                    ), 
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: px(16.0)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        fontSize: sp(34.0)
                                    )
                                  ),
                                ),
                                Text(
                                  '${stationList[index]['status'] == 1 ? '正常' : '停用'}', 
                                  style: TextStyle(
                                    color: Colors.grey, fontSize: sp(30.0)
                                  )
                                )
                              ]
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: px(8.0)),
                              child: Divider(color: Colors.black38),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                Navigator.pushNamed(context, '/station/details', arguments: { 
                  'stId': stationList[index]['stId'], 
                  'title': stationList[index]['stName']
                });
              }
            );
          },
        )
      ),
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