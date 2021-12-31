import 'package:flutter/material.dart';
import 'package:scet_app/components/Search.dart';
import 'package:scet_app/components/CasingPly.dart';
import 'package:scet_app/pages/dataModule/StationLayout/ValueChart.dart';
import 'package:scet_app/pages/dataModule/StationLayout/siteComponts.dart';
import 'package:scet_app/utils/api/Api.dart';
import 'package:scet_app/utils/api/Request.dart';
import 'package:scet_app/utils/tool/alarmLevel/warnLevel.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';

/// 物质
class Matter extends StatefulWidget {
  final int stId;
  final String? facId;
  Matter({required this.stId, this.facId});

  @override
  _MatterState createState() => _MatterState();
}

class _MatterState extends State<Matter> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Map _nowMatter = {}; // 选中的物质
  List _matterList = []; // 物质数组
  List _searchList = []; //搜索物质数组数据的参考数据源

  @override
  void initState() {
    super.initState();
    _getStationFactor(stId: widget.stId);
  }

  // 获取站点所有监测因子
  void _getStationFactor({required int stId}) async {
    var response = await Request().get(Api.url['stationFactor']  + '/$stId');
    if(response['code'] == 200) {
      List data = response['data'];
      data.sort((a, b) {
        return double.parse(b['value'].toString()).compareTo(double.parse(a['value'].toString()));
      });
      data.sort((a, b) {
        return int.parse(b['warn']['level'].toString()).compareTo(int.parse(a['warn']['level'].toString()));
      });
      // 获取当前因子的详细信息
      _getFactorDescription(facId: data[0]['facId']);
      // 获取当前因子的浓度趋势
      _getFactorValueList(stId: stId, facId: data[0]['facId']);
      setState(() {
        _matterList = data;
        _nowMatter = data[0];
        _searchList = data;
      });
    }
  }

  // 获取当前因子的详细信息
  Map _facInfo = {};
  void _getFactorDescription({required String facId}) async {
    Map<String, dynamic> params = Map();
    params['facId'] = facId;
    var response = await Request().get(Api.url['factorDescription'], data: params);
    if(response['code'] == 200) {
      setState(() {
        if( response['data'].length>0){
          _facInfo = response['data'][0];
        }
      });
    }
  }

  // 获取当前因子的浓度趋势
  List _valueData = [];
  void _getFactorValueList({ int? stId, String? facId}) async {
    Map<String, dynamic> params = Map();
    params['stId'] = stId;
    params['facId'] = facId;
    params['endTime'] = DateTime.now().toUtc();
    var response = await Request().get(Api.url['factorValueList'], data: params);
    if(response['code'] == 200) {
      List valueList = [];
      response['data'].forEach((item) {
        valueList.add([DateTime.parse(item['time']).millisecondsSinceEpoch, item['value']]);
      });
      setState(() {
        _valueData = valueList;
      });
    }
  }
  // 文字改变触发搜索回调
  _search(String value){
    _matterList = _searchStrig(value.trim());
    setState(() {});
  }
  // 搜索事件的处理
  List _searchStrig(value){
    List _newList = [];
    _searchList.forEach((item) {
      if((item['facName'].contains(value))){
        _newList.add(item);
      }
    });
    return _newList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _matterList == null ?
      CasingPly.casingPly3()  :
      ListView(
        children: [
          Search(
            bgColor: Color(0xffEFF0F4),
            textFieldColor: Color(0xffffffff),
            search: (value) {
              _search(value);
            }
          ),
          SiteComponents.matterCard(
            data: _matterList,
            callBack: (index, facId) {
              // 获取当前因子的详细信息
              _getFactorDescription(facId: facId);
              // 获取当前因子的浓度趋势
              _getFactorValueList(stId: widget.stId, facId: facId);
              setState(() {
                _nowMatter = _matterList[index];
              });
            }
          ),
          SiteComponents.itemCard(children: [
            Text(
              '${_nowMatter['facName'] ?? '/'}',
              style: TextStyle(
                color: Color(0xff45474D),
                fontSize: sp(32.0),
                fontFamily: "M"
              ),
            ),
            SiteComponents.matterCardTextrow(
              leftTitle: '最新浓度',
              leftValue: '${_nowMatter['value'] ?? '/'} ${_nowMatter['unit']}',
              rightTitle: '注意标识',
              rightValue: '${_nowMatter['warn'] == null ? '/' : warnLevel(_nowMatter['warn']['level'])}',
            ),
            SiteComponents.matterCardTextrow(
              leftTitle: 'cas',
              leftValue: '${_facInfo['CAS'] ?? '/'}',
              rightTitle: '化学式',
              rightValue: '${_facInfo['MF'] ?? '/'}',
            ),
            SiteComponents.matterCardTextrow(
              leftTitle: '英文名称',
              leftValue: '${_facInfo['enName'] ?? '/'}',
              rightTitle: '监测仪器',
              rightValue: '${_facInfo['devType'] ?? '/'}',
            ),
            Container(
              width: px(702.0),
              height: px(543.0),
              alignment: Alignment.center,
              child: ValueChart(
                facName: _nowMatter['facName'],
                unit: _nowMatter['unit'],
                warnLevel: _nowMatter['warn'] == null ? 0 : _nowMatter['warn']['level'],
                valueData: _valueData
              )
            )
          ])
        ],
      ),
    );
  }
}
