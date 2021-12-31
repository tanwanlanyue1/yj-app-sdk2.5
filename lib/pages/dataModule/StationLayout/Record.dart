import 'package:flutter/material.dart';
import 'package:scet_app/components/DateRange.dart';
import 'package:scet_app/components/DownInput.dart';
import 'package:scet_app/pages/dataModule/StationLayout/siteComponts.dart';
import 'package:scet_app/utils/api/Api.dart';
import 'package:scet_app/utils/api/Request.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';

/// 记录
class Record extends StatefulWidget {
  final int stId;
  Record({required this.stId});

  @override
  _RecordState createState() => _RecordState();
}

class _RecordState extends State<Record> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  DateTime _startTime = DateTime.now().add(Duration(days: -365));
  DateTime _endTime = DateTime.now(); //取巡检记录列表.获取设备检修列表
  List _recordTypeList = [
    {'name': '检修记录', 'type': 'maintainList'},
    {'name': '巡检记录', 'type': 'patrolList'},
  ]; //记录类型
  Map _nowRecordType = {'name': '检修记录', 'type': 'maintainList'}; //当前选择的类型

  List _maintainData = [];//检修记录
  List _patrolListData = [];//巡检记录
  //分类查询
  _search(){
    Map<String, dynamic> _data = {
      'stId': widget.stId,
      'startTime': _startTime.toUtc(),
      'endTime': _endTime.toUtc()
    };

    if(_nowRecordType['type'] == 'maintainList'){
      _maintainList(_data);
    }

    if(_nowRecordType['type'] == 'patrolList'){
      _patrolList(_data);
    }
  }

  // 获取设备检修列表
  _maintainList(data) async {
    var response = await Request().get(Api.url['maintainList'], data: data);
    if(response['code'] == 200 && mounted == true){
      setState(() {_maintainData = response['data'];});
    }
  }

  // 获取巡检记录列表
  _patrolList(data) async {
    var response = await Request().get(Api.url['patrolList'], data: data);
    if(response['code'] == 200 && mounted == true){
      setState(() {_patrolListData = response['data'];});
    }
  }

  @override
  void initState() {
    super.initState();
    _search();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SiteComponents.itemCard(
            children: [
              SiteComponents.itemTextRow(
                title: '记录类型',
                child: DownInput(
                  hitStr: '请选择记录类型',
                  data: _recordTypeList,
                  value: _nowRecordType['name'],
                  currentData:_nowRecordType ,
                  callback: (val) {
                    _nowRecordType = val;
                    setState(() {});
                  }
                )
              ),
              SiteComponents.itemTextRow(
                title: '查询时间',
                child: DateRange(
                  start: _startTime,
                  end: _endTime,
                  callBack: (val) {
                    _startTime = val[0];
                    _endTime = val[1];
                  },
                )
              ),
              SiteComponents.queryButton(
                onTap: () {
                  _search();
                }
              ),
            ],
          ),
          Expanded(
            child: ListView(
              children: [
                if(_nowRecordType['type'] == 'maintainList') //检修
                  _maintainListWidget(),
                if(_nowRecordType['type'] == 'patrolList')  //巡检
                  _patrolListWidget(),
                if((_nowRecordType['type'] =='maintainList' && _maintainData.length <= 0) ||
                    (_nowRecordType['type'] =='patrolList' && _patrolListData.length <= 0))
                  Image.asset(
                  'assets/images/station/noData.png',
                  width: px(237.0),
                  height: px(237.0),
                ),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            color: Color(0xFF4D7CFF),
            child: Icon(
              Icons.add,
              size: px(64.0),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        onPressed: () {
          if(_nowRecordType['type'] == 'maintainList') { //检修记录
            Navigator.pushNamed(context, '/add/jianxiu');
          } else {
            Navigator.pushNamed(context, '/add/xunjian');
          }
        }
      )
    );
  }

  // 检修记录
  Widget _maintainListWidget(){
    return Column(
      children: _maintainData.asMap().keys.map((index) {
        Map item = _maintainData[index];
        return  SiteComponents.itemCard(
          children: [
            SiteComponents.title(
              title: item['devName'],
            ),
            SiteComponents.itemCardRows(
              title: '申请停运时间',
              data: item['offSetTime'],
            ),
            SiteComponents.itemCardRows(
              title: '申请人',
              data:item['applicant'],
            ),
            SiteComponents.itemCardRows(
              title: '是否已恢复',
              data:item['restore']  == '0' ? '是' : '否' ,
            ),
            SiteComponents.itemCardRows(
              title: '恢复时间',
              data:item['exceptRecoverTime'],
            ),
            SiteComponents.itemCardRows(
              isCenter: false,
              title: '申请停运原因',
              data:item['offSetReason'],
            ),
          ]
        );
      }).toList(),
    );
  }

  // 巡检记录
  Widget _patrolListWidget(){
    return Column(
      children: _patrolListData.asMap().keys.map((index) {
        Map item = _patrolListData[index];
        return SiteComponents.itemCard(
          children: [
            SiteComponents.title(
              title: item['stName'],
            ),
            SiteComponents.itemCardRows(
              title: '监测地点',
              data:item['parkName']
            ),
            SiteComponents.itemCardRows(
              title: '巡检人员',
              data:item['personName']
            ),
            SiteComponents.itemCardRows(
              title: '巡检时间',
              data:item['patrolTime']
            ),
            SiteComponents.itemCardRows(
              isCenter: false,
              title: '巡检描述',
              data:item['remark']
            ),
          ]
        );
      }).toList(),
    );
  }
}
