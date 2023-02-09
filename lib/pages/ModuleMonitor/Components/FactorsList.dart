import 'package:cs_app/utils/dateUtc/dateUtc.dart';
import 'package:flutter/material.dart';
import 'package:cs_app/api/Api.dart';
import 'package:cs_app/api/Request.dart';
import 'package:cs_app/components/NoData.dart';
import 'package:cs_app/pages/ModuleMonitor/Components/MonitorCharts.dart';
import 'package:cs_app/utils/alarmLevel/ColorLevel.dart';
import 'package:cs_app/utils/screen/screen.dart';

class FactorsList extends StatefulWidget {
  final int stId;
  FactorsList({Key? key,required this.stId}):super(key: key);

  _FactorsList createState() => _FactorsList();
}

class _FactorsList extends State<FactorsList> with AutomaticKeepAliveClientMixin {

  // 重写状态函数
  @override
  bool get wantKeepAlive => true;
  
  bool showCharts = false;

  var currentFactor, levelColor;

  List normalFactor = [], zeroFactor = [];

  // 获取站点所有监测因子
  void _getStationFactor({required int stId}) async {
    var response = await Request().get(Api.url['stationFactor']  + '?stId=$stId&interval=1440');
    if(response['code'] == 200) {
      List data = response['data'];
      List normal = [], zero = [];
      data.forEach((factor) {
        if(!factor.containsKey('warn')){
          factor['warn'] = {
            'warning': {'level':-1, 'method': '无阈值'},
          };
        }
        if(factor['value'] > 0) {
          normal.add(factor);
        } else {
          zero.add(factor);
        }
      });
      normal.sort((a, b) {
        return double.parse(b['value'].toString()).compareTo(double.parse(a['value'].toString()));
      });
      normal.sort((a, b) {
        int numberA;
        int numberB;
        if(a['warn'].containsKey('level')){
          numberA = a['warn']['level'];
        }else{
          numberA = a['warn']['warning']['level'];
        }
        if(b['warn'].containsKey('level')){
          numberB = b['warn']['level'];
        }else{
          numberB = b['warn']['warning']['level'];
        }
        return numberB.compareTo(numberA);
        // return int.parse(b['warn']['warning']['level'].toString()).compareTo(int.parse(a['warn']['warning']['level'].toString()));
      });
      setState(() {
        normalFactor = normal;
        zeroFactor = zero;
      });
    }
  }

  @override
  void initState() {
    _getStationFactor(stId: widget.stId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0XFFECEEF3),
      child: showCharts 
      ? 
        MonitorCharts(
          factor: currentFactor, 
          levelColor: levelColor, 
          callBack: (value) {
            setState(() {
              showCharts = value;
            });
          }
        ) 
      : 
        ListView(
          children: <Widget>[
            Visibility(
              visible: normalFactor.length > 0,
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                childAspectRatio: 2.0,
                padding: EdgeInsets.all(5.0),
                physics: NeverScrollableScrollPhysics(),
                children: normalFactor.map((factor) {
                  return _getGridViewItemUI(factor: factor);
                }).toList(),
              )
            ),
            Visibility(
              visible: zeroFactor.length > 0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  '———— 以下为近期已发现的污染物 ————',
                  style: TextStyle(
                    color: Color(0XFF707070), 
                    fontSize: sp(24.0),
                  ),
                  textAlign: TextAlign.center,
                )
              )
            ),
            Visibility(
              visible: zeroFactor.length > 0,
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                childAspectRatio: 2.0,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(5.0),
                children: zeroFactor.map((factor) {
                  return _getGridViewItemUI(factor: factor);
                }).toList()
              ) 
            ),
            Visibility(
              visible: normalFactor.length == 0 && zeroFactor.length == 0,
              child: NoData(timeType: true, state: '现时暂无监测物质！')
            )
          ],
        )
    );
  }

  Widget _getGridViewItemUI({factor}) {
    int level;
    if(factor['warn'].containsKey('level')){
      level = factor['warn']['level'];
    }else{
      level = factor['warn']['warning']['level'];
    }
    bool warnState = level > 0 ? true : false;
    var color = colorSelest(level);
    return InkWell(
      onTap: () {
        setState(() {
          levelColor = color[1];
          currentFactor = factor;
          showCharts = true; 
        });
      },
      child: Card(
        child: Container(
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            gradient: LinearGradient(
              colors: color[0], 
              begin: Alignment.centerLeft, 
              end: Alignment.centerRight,
              stops: [0.1, 1.0]
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${factor['facName'] ?? '-'}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: warnState ? Color(0xFFFFFFFF) : Color(0xFF222222), 
                  fontSize: sp(28.0), 
                  fontWeight: FontWeight.w600
                ),
              ),
              Divider(height: 2.0,color: warnState ? Color(0xFFFFFFFF) : Color(0xFF999999)),
              Text.rich(
                TextSpan(
                  text: '浓度：',
                  style: TextStyle(
                    fontSize: sp(20.0), 
                    color: warnState ? Color(0xFFFFFFFF) : Color(0xFF999999)
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: '${factor['value'] ?? '-'} ${factor['unit'] ?? '-'}', 
                      style: TextStyle(
                        fontSize: sp(28.0), 
                        fontWeight: FontWeight.w600, 
                        color: warnState ? Color(0xFFFFFFFF) : Color(0XFF585858)
                      )
                    )
                  ],
                ),
              ),
              Text.rich(
                TextSpan(
                  text: '时间：',
                  style: TextStyle(
                    fontSize: sp(20.0), 
                    color: warnState ? Color(0xFFFFFFFF) : Color(0xFF999999)
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: '${dateUtc(factor['time'])}', 
                      style: TextStyle(
                        fontSize: sp(24.0), 
                        color: warnState ? Color(0xFFFFFFFF) : Color(0XFF585858)
                      )
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}