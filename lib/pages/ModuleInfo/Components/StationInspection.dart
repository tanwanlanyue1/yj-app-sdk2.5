import 'package:scet_dz/utils/dateUtc/dateUtc.dart';
import 'package:flutter/material.dart';
import 'package:scet_dz/api/Api.dart';
import 'package:scet_dz/api/Request.dart';
import 'package:scet_dz/components/DateRange.dart';
import 'package:scet_dz/components/DownInput.dart';
import 'package:scet_dz/components/NoData.dart';
import 'package:scet_dz/components/WidgetCheck.dart';
import 'package:scet_dz/utils/screen/screen.dart';
import 'package:scet_dz/utils/storage/data_storageKey.dart';
import 'package:scet_dz/utils/storage/storage.dart';

class StationInspection extends StatefulWidget {
  final int? stId;
  StationInspection({Key? key, this.stId}) : super(key: key);
  
  _StationInspectionState createState() => _StationInspectionState();
}

class _StationInspectionState extends State<StationInspection> {

  DateTime _startTime = DateTime.now().add(Duration(days: -30));

  DateTime _endTime = DateTime.now();

  Map _station = {'name': '全部站点', 'value': '0'};

  // 巡检记录接口
  List _inspectionList = [];
  void _getInspection(stId, startTime, endTime) async {
    Map<String, dynamic> params = Map();
    params['stId'] = stId;
    params['startTime'] = startTime.toUtc();
    params['endTime'] = endTime.toUtc();
    var response = await Request().get(Api.url['patrolList'], data: params);
    if (response['code'] == 200) {
      setState(() {
        _inspectionList = response['data'];
      });
    }
  }

  // 获取站点数据
  List _stationList = [];
  void _getStationList() {
    List? data = StorageUtil().getJSON(StorageKey.RealStationInfo);
    data?.insert(0, {"stName": '全部站点', "stId": '0'});
    List? stationList = data?.map((item) {
      return {"name": item['stName'], "value": item['stId'].toString()};
    }).toList();
    setState(() {
      _stationList = stationList ?? [];
    });
  }

  @override
  void initState() {
    super.initState();
    _getStationList();
    _getInspection(0, _startTime, _endTime);
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
                  hitStr: '请选择巡检站点',
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
                    _getInspection(_station['value'], _startTime, _endTime);
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
          child: ListView(
            padding: EdgeInsets.fromLTRB(px(20.0), 0.0, px(20.0), px(24.0)),
            children: [
              ListView.builder(
                shrinkWrap: true, 
                physics: NeverScrollableScrollPhysics(),
                itemCount: _inspectionList.length,
                itemBuilder: (context, index) {
                  return _itemInspect(_inspectionList[index]);
                }
              ),
              // 没数据
              Visibility(
                visible: _inspectionList.length == 0,
                child: NoData(margin: false, state: '当前时间区间无巡检数据！')
              )
            ]
          )
        )
      ],
    );
  }

  Widget _itemInspect(data) {
    return Container(
      margin: EdgeInsets.only(top: px(30.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: px(20.0)),
            child: Text(
              '${data['stName']}',
              style: TextStyle(
                fontSize: sp(28.0), 
                color: Color(0XFF1D7DFE)
              )
            ),
          ),
          _itemInspectdata(
            padding: false,
            title: '巡检人员',
            value: '${data['personName']}'
          ),
          _itemInspectdata(
            padding: true,
            title: '巡检时间',
            value: '${dateUtc(data['patrolTime'])}'
          ),
          _itemInspectdata(
            padding: false,
            title: '巡检描述',
            value: '${data['remark']}'
          )
        ],
      ),
    );
  }

  Widget _itemInspectdata({required bool padding, String? title, String? value}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: px(5.0)),
      padding: padding ? EdgeInsets.symmetric(vertical: px(10.0)) : EdgeInsets.zero,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: px(156.0),
            margin: EdgeInsets.only(right: px(60.0)),
            child: Text(
              '$title:', 
              style: TextStyle(
                fontSize: sp(24.0), 
                color: Color(0XFF999999)
              )
            ),
          ),
          Expanded(
            child: Container(
              child: Text(
                '${value ?? '/'}', 
                style: TextStyle(
                  fontSize: sp(24.0), 
                  color: Color(0XFF222222)
                )
              )
            ),
          )
        ]
      ),
    );
  }
}