import 'package:flutter/material.dart';
import 'package:scet_app/components/Status.dart';
import 'package:scet_app/components/ToastWidget.dart';
import 'package:scet_app/pages/alarmModule/components/WidgetCheck.dart';
import 'package:scet_app/utils/api/Api.dart';
import 'package:scet_app/utils/api/Request.dart';
import 'package:scet_app/utils/tool/dateUtc/dateUtc.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';

class BasicInformation extends StatefulWidget {
  final Map data;
  final Map baseInfo;
  BasicInformation({
    this.data,
    this.baseInfo
  });
  @override
  _BasicInformationState createState() => _BasicInformationState();
}

class _BasicInformationState extends State<BasicInformation> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  List upgradeAlarm = [{"name": "是", "value": true}, {"name": "否", "value": false}];

  Map _baseInfo;// 事件基础信息
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _baseInfo = widget.baseInfo;
  }
  @override
  void didUpdateWidget(BasicInformation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(oldWidget.baseInfo != widget.baseInfo) {
      _baseInfo = widget.baseInfo;
    }
  }
  @override
  Widget build (BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: px(24.0)),
      child: Column(
        children: [
          WidgetCheck.miniTitle(
              '基础信息',
              icon:'assets/icon/alarm/BasicInformation.png'
          ),
          WidgetCheck.fromCard(
            child: Column(
              children: [
                WidgetCheck.rowItem(
                  padding: false,
                  title: '事件编号',
                  child: WidgetCheck.textData(data: '${widget.data['eventCode']}')
                ),
                WidgetCheck.rowItem(
                  padding: true,
                  title: '事件名称',
                  child: WidgetCheck.textData(data: '${ _baseInfo == null
                      ?'/'
                      :_baseInfo['name']
                  }')
                ),
                WidgetCheck.rowItem(
                  expanded: false,
                  padding: false,
                  title: '当前状态',
                  child:
                  Status(status:_baseInfo == null
                      ?''
                      : _baseInfo['status'].toString() ,)
                ),
                WidgetCheck.rowItem(
                  padding: true,
                  title: '启动时间',
                  child: WidgetCheck.textData(
                      data: '${dateUtc(_baseInfo == null
                          ? ''
                          : _baseInfo['runupTime'])}'
                  )
                ),
                WidgetCheck.rowItem(
                  padding: false,
                  title: '最高级别',
                  child: _itemLevel(
                      level: '警报级 -- ${_baseInfo == null
                          ? '/'
                          : _baseInfo['maxWarn']['level'].toString()}级',
                      multiple: '超标${_baseInfo == null
                          ? '/'
                          :_baseInfo['maxWarn']['thresholdValue'].toString()}倍'
                  )
                ),
                WidgetCheck.rowItem(
                  padding: true,
                  title: '当前级别',
                  child: _itemLevel(
                      level: '警报级 -- ${_baseInfo== null
                          ? '/'
                          : _baseInfo['warn']['level'].toString()}级',
                      multiple: '超标${_baseInfo == null
                          ? '/'
                          : _baseInfo['warn']['thresholdValue'].toString()}倍'
                  )
                ),
                WidgetCheck.rowItem(
                  padding: false,
                  title: '核实结果',
                  child: WidgetCheck.textData(
                      state: false,
                      data: '${_baseInfo == null
                      ? '暂无核查任务及结论'
                      : _baseInfo['conclusion']}'
                  )
                ),
                WidgetCheck.rowItem(
                  alignStart: true,
                  padding: true,
                  title: '报告情况',
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WidgetCheck.textData(state: false, data: '暂无核查报告；'),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: px(16.0)),
                        child: WidgetCheck.textData(state: false, data: '暂无监测报告；'),
                      ),
                      WidgetCheck.textData(state: false, data: '暂无事件报告；'),
                    ]
                  )
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: px(30.0)),
                      child: Text(
                        '升级为应急事件响应：',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          color: Color(0XFF737880),
                          fontSize: sp(28.0),
                          fontWeight: FontWeight.w500
                        )
                      )
                    ),
                    _itemCheckbox(
                        checkbox:_baseInfo == null
                            ? 0
                            : _baseInfo['isResponse']
                    )
                    // Row(
                    //   children: upgradeAlarm.asMap().keys.map((index) {
                    //     return Row(
                    //       mainAxisAlignment: MainAxisAlignment.start,
                    //       children: <Widget>[
                    //         SizedBox(
                    //           width: px(34.0),
                    //           height: px(34.0),
                    //           child: Checkbox(
                    //             materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    //             activeColor: Color(0XFF4D7CFF),
                    //             value: upgradeAlarm[index]['value'],
                    //             onChanged: (bool val) {
                    //               List data = upgradeAlarm;
                    //               data.forEach((element) {
                    //                 element['value'] = false;
                    //               });
                    //               data[index]['value'] = !data[index]['value'];
                    //               setState(() {
                    //                 upgradeAlarm = data;
                    //               });
                    //             },
                    //           ),
                    //         ),
                    //         Container(
                    //           margin: index == 0 ? EdgeInsets.only(right: px(60.0)) : EdgeInsets.zero,
                    //           padding: EdgeInsets.only(left: px(12.0)),
                    //           child: WidgetCheck.textData(data: '${upgradeAlarm[index]['name']}')
                    //         )
                    //       ]
                    //     );
                    //   }).toList()
                    // )
                  ]
                )
              ]
            )
          )
        ],
      )
    );
  }

  Widget _itemLevel({String level, String multiple}) {
    return Row(
      children: [
        Text(
            '$level',
            style: TextStyle(
                color: Color(0XB3FF3333),
                fontSize: sp(30.0),
                fontWeight: FontWeight.w500
            )
        ),
        Padding(
          padding: EdgeInsets.only(left: px(40.0)),
          child: Text(
              '$multiple',
              style: TextStyle(
                  color: Color(0XFF2E2F33),
                  fontSize: sp(30.0),
                  fontWeight: FontWeight.w500
              )
          ),
        )
      ],
    );
  }
  Widget _itemCheckbox({int checkbox}) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: px(34.0),
            height: px(34.0),
            child: Checkbox(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              activeColor: Color(0XFF4D7CFF),
              value:checkbox == 1,
              onChanged: (bool val) {},
            ),
          ),
          Container(
              margin: EdgeInsets.only(right: px(60.0)),
              padding: EdgeInsets.only(left: px(12.0)),
              child: WidgetCheck.textData(data: '是')
          ),
          SizedBox(
            width: px(34.0),
            height: px(34.0),
            child: Checkbox(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              activeColor: Color(0XFF4D7CFF),
              value:checkbox == 0,
              onChanged: (bool val) {},
            ),
          ),
          Container(
              margin: EdgeInsets.only(right: px(60.0)),
              padding: EdgeInsets.only(left: px(12.0)),
              child: WidgetCheck.textData(data: '否')
          ),
        ]
    );
  }
}