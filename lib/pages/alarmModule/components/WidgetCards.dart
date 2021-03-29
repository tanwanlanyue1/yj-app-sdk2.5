import 'package:flutter/material.dart';
import 'package:scet_app/components/Status.dart';
import 'package:scet_app/pages/AlarmModule/components/WidgetCheck.dart';
import 'package:scet_app/utils/api/Api.dart';
import 'package:scet_app/utils/api/Request.dart';
import 'package:scet_app/utils/tool/dateUtc/dateUtc.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';
///核查 、监测卡片
class WidgetCards extends StatefulWidget {
  final int type;// 4 核查 5监测
  final String status;//状态
  final String title;//任务标题
  final String code;//编号
  final String event;//事件
  final String explain;//说明
  final String time;//时间
  final String executor;//执行
  final int index;//当前下标
  final int showIndex;//当前显示的下标
  final callBackIndex;//回调父组件当前显示的下标的事件
  WidgetCards({
    this.type,
    this.status,
    this.title,
    this.code,
    this.event,
    this.explain,
    this.time,
    this.executor,
    this.index,
    this.showIndex,
    this.callBackIndex
  });
  @override
  _WidgetCardsState createState() => _WidgetCardsState();
}

class _WidgetCardsState extends State<WidgetCards> {

  List _detailsList = [];//任务详情列表
  bool _show = false; //是否展开

  //任务详情
  _details() async {
    Map<String, String> _data = Map();
    _data['code'] = widget.code;
    var response = await Request().get(Api.url['eventDetails'], data: _data);
    if(response['code'] == 200){
      _show = !_show;
      widget.callBackIndex(widget.index);
      var result = response['data'];

      if(widget.type == 4){
        List dataArray = [];
        result['verificationTasks'].forEach((item) {
          String target = '${item['partitionName'] ?? ''}—${item['companyName'] ?? ''}—${item['placeName'] ?? ''}';
          String point = '${item['longitude']},${item['latitude']}';
          String person = item['inspector'].join('、');
          String time = item['time'];
          dataArray.add({'target': target, 'point': point, 'person': person, 'access': item['access'], 'time': time});
        });
        _detailsList = dataArray;
        setState(() {});
      }else if(widget.type == 5){
        List dataArray = [];
        result['monitoringTasks'].forEach((item) {
          String pointName = item['point'];
          String point = '${item['longitude']},${item['latitude']}';
          String factor = item['factor'].join('、');
          String device = item['instrument'].join('、');
          String person = item['monitoringStaff'].join('、');
          String fanghu = item['protectEquipment'].join('、');
          dataArray.add({'pointName': pointName, 'point': point, 'factor': factor, 'device': device, 'person': person, 'fanghu': fanghu});
        });
        _detailsList = dataArray;
        setState(() {});
      }
    }
  }
  /// 动态改变高度 核查/监测
  double _height() {
    if(widget.index == widget.showIndex &&  _show){
      if(widget.type == 4) {
       return px(415) + px( 350 * _detailsList.length);
      }else if(widget.type == 5) {
        return px(388) + px( 410 * _detailsList.length);
      }
    }else{
      if(widget.type == 4 ) {
        return px(415);
      }else if(widget.type == 5 ) {
        return px(380);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child:  Container(
        width: double.infinity,
        height:_height(),
        child: Row(
          children: [
            Container(
              child: Column(
                children: [
                  Container(
                      width: px(1),
                      height: px(5),
                      color: Color(0xff4D7CFF)
                  ),
                  Container(
                    width: px(26),
                    height: px(26),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(13)),
                        border: Border.all(
                            width: px(6),
                            color: widget.status== '0' ? Color(0xff4D7CFF) : Color(0xff97A4C9)
                        )
                    ),
                  ),
                  Expanded(
                    child: Container(
                        width: px(1),
                        color: Color(0xff4D7CFF)
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child:  Container(
                margin: EdgeInsets.only(left: px(12)),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('${widget.title}',style: TextStyle(fontSize: sp(28)),),
                        Spacer(),
                        Status(status: widget.status,),
                      ],
                    ),
                    _itemCard(
                      child: Column(
                        children: [
                          WidgetCheck.rowItem2(title: '任务编号', data: '${widget.code}'),
                          WidgetCheck.rowItem2(title: '关联事件', data: '${widget.event}'),
                          if(widget.type == 4) WidgetCheck.rowItem2(
                              isCenter: false,
                              title: '任务说明',
                              data: '${widget.explain}'
                          ),
                          WidgetCheck.rowItem2(title: '执行时间', data: '${dateUtc(widget.time)}'),
                          WidgetCheck.rowItem2(title: '执  行  人', data: '${widget.executor}'),
                          if(widget.index == widget.showIndex && _show && widget.type == 4)
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: _detailsList.asMap().keys.map((index) {
                                  return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Divider(color: Colors.white),
                                        WidgetCheck.rowItem2(title: '核查目标${index + 1}', data: _detailsList[index]['target'], isCenter: false),
                                        WidgetCheck.rowItem2(title: '经  纬  度', data: _detailsList[index]['point'], isCenter: false),
                                        WidgetCheck.rowItem2(title: '核查人员', data: _detailsList[index]['person'], isCenter: false),
                                        WidgetCheck.rowItem2(title: '企业对接人', data: _detailsList[index]['access'], isCenter: false),
                                        WidgetCheck.rowItem2(title: '执行时间', data: _detailsList[index]['time'],),
                                      ]
                                  );
                                }).toList()
                            ),
                          if(widget.index == widget.showIndex && _show && widget.type == 5)
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: _detailsList.asMap().keys.map((index) {
                                  return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Divider(color: Colors.white),
                                        WidgetCheck.rowItem2(title: '点位序号', data: '${index + 1} P'),
                                        WidgetCheck.rowItem2(title: '点位名称', data: _detailsList[index]['pointName']),
                                        WidgetCheck.rowItem2(title: '经  纬  度', data: _detailsList[index]['point']),
                                        WidgetCheck.rowItem2(title: '监测物质', data: _detailsList[index]['factor']),
                                        WidgetCheck.rowItem2(title: '监测配置', data: _detailsList[index]['device'],isCenter: false),
                                        WidgetCheck.rowItem2(title: '监测人员', data: _detailsList[index]['person'],isCenter: false),
                                        WidgetCheck.rowItem2(title: '防护设备', data: _detailsList[index]['fanghu'])
                                      ]
                                  );
                                }).toList()
                            ),
                          widget.index == widget.showIndex && _show
                              ? Icon(Icons.expand_less,color: Colors.white,)
                              : Icon(Icons.expand_more,color: Colors.white)
                        ],
                      )
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      onTap: () {
        if(widget.showIndex == widget.showIndex && _show == true){
          _show = false;
          _detailsList = [];
          setState(() { });
        }else{
          print('123');
          _details();
        }
       },
    );
  }
  Widget _itemCard({Widget child}){
    return Container(
      width: px(616),
      margin: EdgeInsets.only(top: px(10)),
      padding: EdgeInsets.only(top:px(14),bottom:px(14),left: px(12),right: px(12)),
      decoration: BoxDecoration(
          color: Color(0xff628CFF),
          gradient: LinearGradient(      //渐变位置
              begin: Alignment.topRight, //右上
              end: Alignment.bottomLeft, //左下
              stops: [0.0, 1.0],         //[渐变起始点, 渐变结束点]
              //渐变颜色[始点颜色, 结束颜色]
              colors:widget.status=='0'
                  ? [Color(0xff5C88FF), Color(0xff80A2FF),]
                  : [Color(0xff7585B1), Color(0xff94A2C9),]
          ),
          borderRadius: BorderRadius.all(Radius.circular(px(16)))
      ),
      child:child,
    );
  }
}
