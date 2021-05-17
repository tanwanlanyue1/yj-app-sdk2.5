import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scet_app/components/DownInput.dart';
import 'package:scet_app/components/TimeSelect.dart';
import 'package:scet_app/components/ToastWidget.dart';
import 'package:scet_app/model/provider/provider_home.dart';
import 'package:scet_app/pages/addModule/components/FormCheck.dart';
import 'package:scet_app/pages/addModule/components/SubmitButton.dart';
import 'package:scet_app/utils/api/Api.dart';
import 'package:scet_app/utils/api/Request.dart';
import 'package:scet_app/utils/tool/screen/Adapter.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';

/*------------添加检修-------------*/ 
class AddPolling extends StatefulWidget {
  @override
  _AddPollingState createState() => _AddPollingState();
}

class _AddPollingState extends State<AddPolling> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  FocusNode blankNode = FocusNode();

  String person, remark, offSetReason, applicant; 
  
  Map station = {}, offsetType = {}, device = {};

  int nto = 0;
  List tzyz = [
    {"name": "是", "value": true}, 
    {"name": "否", "value": false}
  ];

  List deviceList = [];

  DateTime stopTime, expectTime;
  void timeChange(int state, DateTime time) {
    if (mounted) {
      // print(time);
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

  void _getStationDevice(stId) async {
    var response = await Request().get(Api.url['stationDevice'] + '/$stId');
    if(response['code'] == 200) {
      List data = response['data'].map((item) {
        return {"name": item['name'], "value": item['id'].toString()}; 
      }).toList();
      setState(() {
        deviceList = data;
      });
    }
  }

  void _postAddPolling() async {
    if(station['value'] == null) {
      ToastWidget.showToastMsg('请选择设备位置！');
    } else if(device['value'] == null){
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
      params['stId'] = station['value'];
      params['devId'] = device['value'];
      params['NTO'] = nto;
      params['offSetType'] = offsetType['value'];
      params['offSetTime'] = stopTime.toUtc().toString();
      params['exceptRecoverTime'] = expectTime.toUtc().toString();
      params['applicant'] = applicant;
      params['offSetReason'] = offSetReason;
      var response = await Request().post(Api.url['maintainUpload'],data: params);
      if(response['code'] == 200) {
        ToastWidget.showToastMsg('添加设备检修成功！');
        Navigator.pop(context);
      }
    }
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
                FormCheck.fromCard(
                  child: Column(
                    children: [
                      FormCheck.formRowItem(
                        padding: false,
                        title: '设备位置',
                        child: DownInput(
                          hitStr: '请选择设备位置',
                          value: station['name'] ?? null,
                          data: _stationList(),
                          callback: (val) {
                            _getStationDevice(val['value']);
                            setState(() {
                              station = val;
                            });
                          }
                        )
                      ),
                      FormCheck.formRowItem(
                        padding: true,
                        title: '设备名称',
                        child: DownInput(
                          hitStr: '请选择监测设备',
                          value: device['name'] ?? null,
                          data: deviceList,
                          beforeClick: () {
                            if(station['value'] == null){
                              ToastWidget.showToastMsg('请先选择设备位置');
                            }
                          },
                          callback: (val) {
                            setState(() {
                              device = val;
                            });
                          }
                        )
                      ),
                      FormCheck.formRowItem(
                        padding: false,
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
                      FormCheck.formRowItem(
                        padding: true,
                        title: '申请人员',
                        child: FormCheck.inputWidget(
                          hintText: '请填写申请人员',
                          onChanged: (val) {
                            applicant = val;
                          }
                        )
                      ),
                      FormCheck.formRowItem(
                        padding: false,
                        title: '停运时间',
                        child: TimeSelect(
                          scaffoldKey: _scaffoldKey, 
                          hintText: "请选择停运时间",
                          callBack: (time) => timeChange(0, time)
                        )
                      ),
                      FormCheck.formRowItem(
                        padding: true,
                        title: '预期修复',
                        child: TimeSelect(
                          scaffoldKey: _scaffoldKey,
                          hintText: "请选择预期修复时间",
                          callBack: (time ) => timeChange(1, time)
                        )
                      ),
                      FormCheck.formRowItem(
                        padding: false,
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
                                    onChanged: (bool val) {
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
                      FormCheck.formRowItem(
                        alignStart: true,
                        padding: true,
                        title: '停运原因',
                        child: FormCheck.textAreaWidget(
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
                  padding: EdgeInsets.only(top: px(150.0)),
                  child: SubmitButton(function: _postAddPolling)
                )
              ],
            ),
          )
        )
      )
    );
  }

  // 获取站点数据
  List _stationList() {
    var _homeModel = Provider.of<HomeModel>(context, listen: true);
    List data = _homeModel.siteList;
    return data.map((item) {
      return {"name": item['stName'], "value": item['stId'].toString()};
    }).toList();
  }
}