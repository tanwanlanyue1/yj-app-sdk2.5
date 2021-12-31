import 'package:scet_dz/utils/dateUtc/dateUtc.dart';
import 'package:flutter/material.dart';
import 'package:scet_dz/api/Api.dart';
import 'package:scet_dz/api/Request.dart';
import 'package:scet_dz/components/DateRange.dart';
import 'package:scet_dz/components/NoData.dart';
import 'package:scet_dz/components/WidgetCheck.dart';
import 'package:scet_dz/utils/screen/screen.dart';

class RecordMaintain extends StatefulWidget {
  final int? stId;
  RecordMaintain({Key? key, this.stId}) : super(key: key);
  _RecordMaintainState createState() => _RecordMaintainState();
}

class _RecordMaintainState extends State<RecordMaintain> {

  DateTime _startTime = DateTime.now().add(Duration(days: -730));

  DateTime _endTime = DateTime.now();

  // 设备检修接口
  List maintainList = [];
  void _getDeviceMaintain(startTime, endTime) async{
    Map<String, dynamic> params = Map();
    params['stId'] = widget.stId;
    params['startTime'] = startTime.toUtc();
    params['endTime'] = endTime.toUtc();
    var response = await Request().get(Api.url['maintainList'], data: params);
    if (response['code'] == 200) {
      setState(() {
        maintainList = response['data'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getDeviceMaintain(_startTime, _endTime);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: px(20.0)),
      color: Colors.white,
      child: ListView(
        children: [
          Row(
            children: [
              Expanded(
                child: WidgetCheck.rowItem(
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
              ),
              Container(
                width: px(120.0),
                height: px(58.0),
                margin: EdgeInsets.only(left: px(15.0)),
                child: GestureDetector(
                  onTap: () {
                    _getDeviceMaintain(_startTime, _endTime);
                  },
                  child: Image.asset(
                    'lib/assets/icon/search.png', 
                    fit: BoxFit.fill
                  )
                )
              )
            ],
          ),
          maintainList.length > 0 
          ? 
            _maintainWidget(data: maintainList) 
          : 
            NoData(margin: false, timeType: false, state: '该时间段无设备检修情况！')
        ]
      )
    );
  }

  Widget _maintainWidget({required List data}) {
    List<Widget> tiles = [];
    Widget content;
    for (var item in data) {
      var mWidget = Container(
        margin: EdgeInsets.only(top: px(30.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: px(20.0)),
              child: Text(
                '${item['devName']}',
                style: TextStyle(
                  fontSize: px(28.0), 
                  color: Color(0XFF1D7DFE)
                )
              ),
            ),
            _itemMaintaindata(
              padding: false,
              title: '申请停运时间',
              value: '${dateUtc(item['offSetTime'])}'
            ),
            _itemMaintaindata(
              padding: true,
              title: '申请停运人员',
              value: '${item['applicant']}'
            ),
            _itemMaintaindata(
              padding: false,
              title: '预计恢复时间',
              value: '${dateUtc(item['exceptRecoverTime'])}'
            ),
            _itemMaintaindata(
              padding: true,
              title: '是否已经恢复',
              value: '${item['restore'] == '1' ? '是' : '否'}'
            ),
            _itemMaintaindata(
              padding: false,
              title: '实际恢复时间',
              value: '${item['restore'] == '0' ? '/' : dateUtc(item['actualRecoverTime'])}'
            ),
            _itemMaintaindata(
              padding: true,
              title: '申请停运原因',
              value: '${item['offSetReason']}'
            ),
          ],
        ),
      );
      tiles.add(mWidget);
    }
    content = Column(
      children: tiles
    );
    return content;
  }

  Widget _itemMaintaindata({required bool padding, String? title, String? value}) {
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