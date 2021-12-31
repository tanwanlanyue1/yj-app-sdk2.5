import 'package:flutter/material.dart';
import 'package:cs_app/api/Api.dart';
import 'package:cs_app/api/Request.dart';
import 'package:cs_app/components/DownInput.dart';
import 'package:cs_app/components/WidgetCheck.dart';
import 'package:cs_app/components/TimeSelect.dart';
import 'package:cs_app/components/ToastWidget.dart';
import 'package:cs_app/pages/ModuleMonitor/Components/SubmitButton.dart';
import 'package:cs_app/utils/screen/Adapter.dart';
import 'package:cs_app/utils/screen/screen.dart';

/*------------添加检修-------------*/ 
class UploadMaintain extends StatefulWidget {
  final arguments;
  UploadMaintain({this.arguments});

  @override
  _UploadMaintainState createState() => _UploadMaintainState();
}

class _UploadMaintainState extends State<UploadMaintain> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  FocusNode blankNode = FocusNode();

  String? person, remark, offSetReason, applicant;
  
  Map station = {}, offsetType = {}, device = {};

  int nto = 0;
  List tzyz = [
    {"name": "是", "value": true}, 
    {"name": "否", "value": false}
  ];

  DateTime? stopTime, expectTime;
  void timeChange(int state, DateTime time) {
    if (mounted) {
      if (state == 0) {
        setState(() {
          stopTime = time;
        });
      } else {
        setState(() {
          expectTime = time;
        });
      }
    }
  }

  void _postAddPolling() async {
    if(device['value'] == null){
      ToastWidget.showToastMsg('请选择监测设备！');
    } else if(offsetType == null) {
      ToastWidget.showToastMsg('请选择停运性质！');
    } else if(applicant == null) {
      ToastWidget.showToastMsg('请填写申请人员！');
    }  else if(stopTime == null){
      ToastWidget.showToastMsg('请选择停运时间！');
    } else if(nto == null){
      ToastWidget.showToastMsg('请选择是否通知业主！');
    } else if(expectTime == null) {
      ToastWidget.showToastMsg('请选择预期恢复时间！');
    } else if(offSetReason == null) {
      ToastWidget.showToastMsg('请填写停运原因！');
    } else {
      Map<String, dynamic> params = Map();
      params['stId'] = widget.arguments['stId'];
      params['devId'] = device['value'];
      params['NTO'] = nto;
      params['offSetType'] = offsetType['value'];
      params['offSetTime'] = stopTime.toString();
      params['exceptRecoverTime'] = expectTime.toString();
      params['applicant'] = applicant;
      params['offSetReason'] = offSetReason;
      var response = await Request().post(Api.url['maintainUpload'],data: params);
      if(response['code'] == 200) {
        ToastWidget.showToastMsg('添加设备检修成功！');
        Navigator.pop(context);
      }
    }
  }

  List _deviceList() {
    List data =  widget.arguments['deviceList'];
    print(data);
    return data.map((item) {
      return {"name": item['name'], "value": item['id'].toString()};
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size(Adapt.screenW(), px(Adapter.topBarHeight)),
        child: AppBar(
          title: Text(
            '添加设备检修', 
            style: TextStyle(
              color: Colors.white,
              fontSize: sp(Adapter.appBarFontSize)
            )
          ),
          elevation: 0,
          centerTitle: true
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(blankNode);
        },
        child: SingleChildScrollView(
          child: Container(
            width: Adapt.screenW(),
            color: Color(0XFFF2F4FA),
            padding: EdgeInsets.symmetric(
              vertical: px(24.0),
              horizontal: px(20.0)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WidgetCheck.fromCard(
                  child: Column(
                    children: [
                      WidgetCheck.rowItem(
                        padding: false,
                        title: '设备名称',
                        child: DownInput(
                          hitStr: '请选择监测设备',
                          value: device['name'] ?? null,
                          data: _deviceList(),
                          callback: (val) {
                            setState(() {
                              device = val;
                            });
                          }
                        )
                      ),
                      WidgetCheck.rowItem(
                        padding: true,
                        title: '停用性质',
                        child: DownInput(
                          hitStr: '请选择停用性质',
                          value: offsetType['name'] ?? null,
                          data: [
                            {"name": "短期", "value": "短期"},
                            {"name": "长期", "value": "长期"},
                          ],
                          callback: (val) {
                            setState(() {
                              offsetType = val;
                            });
                          }
                        )
                      ),
                      WidgetCheck.rowItem(
                        padding: false,
                        title: '申请人员',
                        child: WidgetCheck.inputWidget(
                          hintText: '请填写申请人员',
                          onChanged: (val) {
                            applicant = val;
                          }
                        )
                      ),
                      WidgetCheck.rowItem(
                        padding: true,
                        title: '停运时间',
                        child: TimeSelect(
                          scaffoldKey: _scaffoldKey, 
                          hintText: "请选择停运时间",
                          callBack: (time) => timeChange(0, time)
                        )
                      ),
                      WidgetCheck.rowItem(
                        padding: false,
                        title: '预期修复',
                        child: TimeSelect(
                          scaffoldKey: _scaffoldKey,
                          hintText: "请选择预期修复时间",
                          callBack: (time ) => timeChange(1, time)
                        )
                      ),
                      WidgetCheck.rowItem(
                        padding: true,
                        title: '通知业主',
                        child: Row(
                          children: tzyz.asMap().keys.map((index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  width: px(34.0),
                                  height: px(34.0),
                                  child: Checkbox(
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    activeColor: Color(0XFF4D7CFF),
                                    value: tzyz[index]['value'],
                                    onChanged: (bool? val) {
                                      nto = index;
                                      List data = tzyz;
                                      data.forEach((item) {
                                        item['value'] = false;
                                      });
                                      data[index]['value'] = !data[index]['value'];
                                      setState(() {
                                        tzyz = data;
                                      });
                                    },
                                  )
                                ),
                                Container(
                                  margin: index == tzyz.length - 1 ? EdgeInsets.zero : EdgeInsets.only(right: px(20.0)),
                                  padding: EdgeInsets.only(left: px(12.0)),
                                  child: Text(
                                    '${tzyz[index]['name']}   ',
                                    style: TextStyle(
                                      color: Color(0XFF45474D),
                                      fontSize: sp(28.0),
                                      fontWeight: FontWeight.w500
                                    )
                                  )
                                )
                              ]
                            );
                          }).toList()
                        )
                      ),
                      WidgetCheck.rowItem(
                        alignStart: true,
                        padding: false,
                        title: '停运原因',
                        child: WidgetCheck.textAreaWidget(
                          hintText: "请填写停运原因",
                          onChanged: (val) {
                            offSetReason = val;
                          }
                        )
                      )
                    ]
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: px(270.0)),
                  child: SubmitButton(function: _postAddPolling)
                )
              ],
            ),
          )
        )
      )
    );
  }
}