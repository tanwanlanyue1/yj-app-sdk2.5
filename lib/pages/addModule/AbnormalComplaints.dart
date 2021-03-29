import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scet_app/components/DownInput.dart';
import 'package:scet_app/components/DialogPages.dart';
import 'package:scet_app/components/ToastWidget.dart';
import 'package:scet_app/pages/addModule/components/AccessLocate.dart';
import 'package:scet_app/pages/addModule/components/FormCheck.dart';
import 'package:scet_app/pages/addModule/components/SubmitButton.dart';
import 'package:scet_app/utils/api/Api.dart';
import 'package:scet_app/utils/api/Request.dart';
import 'package:scet_app/utils/tool/screen/Adapter.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';

/*------------异常投诉-------------*/ 
class AbnormalComplaints extends StatefulWidget {
  @override
  _AbnormalComplaintsState createState() => _AbnormalComplaintsState();
}

class _AbnormalComplaintsState extends State<AbnormalComplaints> {

  FocusNode blankNode = FocusNode();

  int thrillValue;

  List likeFactorList= [];

  var complaintsLon, complaintsLat;

  DateTime currentTime = DateTime.now();

  String eventCode, eventName, complaintsPlace, complaintsContent,smellType, complaintsSmell,complaintsScene;

  Map complaintsType = {}, complaintsMethod = {}, 
    complaintsColor = {}, complaintsForm ={}, 
    complaintsDirection = {},complaintsPower={};

  List smellTypeList = [
    {"name": "香味", "value": true}, 
    {"name": "臭味", "value": false},
    {"name": "中性味道", "value": false},
    {"name": "其他", "value": false},
  ];

  List thrillList = [
    {"name": "是", "value": true}, 
    {"name": "否", "value": false}
  ];

  void _createCode({type}) async{
    Map<String, dynamic> params = Map();
    params['type'] = type;
    var response = await Request().get(Api.url['createCode'], data: params);
    if(response['code'] == 200) {
      setState(() {
        eventCode = response['data']['code'];
      });
    }
  }

  void _postAbnormalComplaints() async{
    Map<String, dynamic> params = Map();
    params['type']= 3;
    params['status']= 0; // 进行中
    params['name']= eventName;
    params['startTime']= currentTime;
    params['runupTime']= currentTime;
    params['complaintsPlace']= complaintsPlace;
    params['complaintsLon']= complaintsLon;
    params['complaintsLat']= complaintsLat;
    params['complaintsType']= complaintsType['name'];
    params['complaintsMethod']= complaintsMethod['name'];
    params['complaintsContent']= complaintsContent;
    params['complaintsForm']= complaintsForm['name'];
    params['complaintsColor']= complaintsColor['name'];
    params['complaintsTaste']= smellType;
    params['complaintsThrill']= thrillValue;
    params['complaintsSmell']= complaintsSmell;
    params['complaintsDirection']= complaintsDirection['name'];
    params['complaintsPower']= complaintsPower['name'];
    params['complaintsFactor']= json.encode(likeFactorList);
    params['complaintsScene']= complaintsScene;

    if(eventName == null) {
      ToastWidget.showToastMsg('事件名称不能为空');
    } else if(complaintsContent == null) {
      ToastWidget.showToastMsg('投诉内容不能为空');
    } else if(complaintsLon == null || complaintsLat == null) {
      ToastWidget.showToastMsg('经纬度不能为空');
    } else if(complaintsDirection['name'] == null || complaintsPower['name'] == null) {
      ToastWidget.showToastMsg('风力风向反馈不能为空');
    } else {
      var response = await Request().get(Api.url['addOrUpdate'], data: params);
      if(response['code'] == 200) {
        DialogPages.succeedDialog(
            context,
            title: '异常投诉填报成功',
            back: () { Navigator.pop(context); }
        );
        // ToastWidget.showToastMsg('异常投诉填报成功！');
      }
    }
  }

  // 获取所有物质
  List allFactors = [];
  void _getAllFactors() async{
    var response = await Request().get(Api.url['chemicals']);
    if(response['code'] == 200) {
      List factors = response['data'].map((factor) {
        return {'id': factor['id'], 'name': factor['name']};
      }).toList();
      this.setState(() {
        allFactors = factors;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getAllFactors();
    _createCode(type: 3); // 异常投诉
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(Adapt.screenW(), px(Adapter.topBarHeight)),
        child: AppBar(
          title: Text(
            '异常投诉事件填报', 
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
            padding: EdgeInsets.symmetric(horizontal: px(20.0)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormCheck.miniTitle('基础信息'),
                FormCheck.fromCard(
                  child: Column(
                    children: [
                      FormCheck.formRowItem(
                        padding: false,
                        title: '事件编号',
                        child: FormCheck.textData(data: eventCode)
                      ),
                      FormCheck.formRowItem(
                        padding: true,
                        title: '事件名称',
                        child: FormCheck.inputWidget(
                          hintText: '请输入事件名称',
                          onChanged: (value) {
                            eventName = value;
                          }
                        )
                      ),
                      FormCheck.formRowItem(
                        padding: false,
                        title: '投诉类型',
                        child: DownInput(
                          hitStr: '请选择投诉类型',
                          value: complaintsType['name'] ?? null,
                          data: [
                            {'name': '园区单位人员投诉'},
                            {'name': '市民投诉'},
                          ],
                          callback: (val) {
                            setState(() {
                              complaintsType = val;
                            });
                          }
                        )
                      ),
                      FormCheck.formRowItem(
                        padding: true,
                        title: '投诉方式',
                        child: DownInput(
                          hitStr: '请选择投诉方式',
                          value: complaintsMethod['name'] ?? null,
                          data: [
                            {'name': '电话投诉'},
                            {'name': '手机APP投诉填报'},
                          ],
                          callback: (val) {
                            complaintsMethod = val;
                            setState(() {});
                          }
                        )
                      ),
                      FormCheck.formRowItem(
                        padding: false,
                        title: '投诉地点',
                        child: FormCheck.inputWidget(
                          hintText: "请填写投诉地点",
                          onChanged: (value) {
                            complaintsPlace = value;
                          }
                        )
                      ),
                      FormCheck.formRowItem(
                        padding: true,
                        title: '经 纬 度 ',
                        child: AccessLocate(
                          callback: (longitude, latitude) {
                            complaintsLon = longitude;
                            complaintsLat = latitude;
                          }
                        )
                      ),
                      FormCheck.formRowItem(
                        alignStart: true,
                        padding: false,
                        title: '投诉内容',
                        child: FormCheck.textAreaWidget(
                          hintText: "请填写投诉内容",
                          onChanged: (value) {
                            complaintsContent = value;
                          }
                        )
                      )
                    ]
                  ),
                ),
                /********视觉反馈********/
                FormCheck.miniTitle('视觉反馈'),
                FormCheck.fromCard(
                  child: Column(
                    children: [
                      FormCheck.formRowItem(
                        padding: false,
                        title: '污染形态',
                        child: DownInput(
                          hitStr: '请选择污染形态',
                          value: complaintsForm['name'] ?? null,
                          data: [{"name": "烟"}, {"name": "气"}, {"name": "液"}],
                          callback: (value) {
                            complaintsForm = value;
                          }
                        )
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: px(24.0)),
                        child: FormCheck.formRowItem(
                          padding: false,
                          title: '颜色描述',
                          child: DownInput(
                            hitStr: '请选择颜色描述',
                            value: complaintsColor['name'] ?? null,
                            data: [
                              {"name": "白色"}, {"name": "黑色"}, {"name": "红色"},
                              {"name": "橙色"}, {"name": "黄色"}, {"name": "绿色"},
                              {"name": "青色"}, {"name": "蓝色"}, {"name": "紫色"},
                            ],
                            callback: (value) {
                              complaintsColor = value;
                            }
                          )  
                        )
                      )
                    ]
                  ),
                ),
                /********嗅觉反馈********/
                FormCheck.miniTitle('嗅觉反馈'),
                FormCheck.fromCard(
                  child: Column(
                    children: [
                      FormCheck.formRowItem(
                        alignStart: true,
                        padding: false,
                        title: '气味分类',
                        child: Wrap(
                          spacing: 2,
                          runSpacing: 10,
                          children: smellTypeList.asMap().keys.map((index) {
                            return Container(
                              width: px(160.0),
                              child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  width: px(34.0),
                                  height: px(34.0),
                                  child: Checkbox(
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    activeColor: Color(0XFF4D7CFF),
                                    value: smellTypeList[index]['value'],
                                    onChanged: (bool val) {
                                      List data = smellTypeList;
                                      data.forEach((element) {
                                        element['value'] = false;
                                      });
                                      data[index]['value'] = !data[index]['value'];
                                      smellType = data[index]['name'];
                                      setState(() {
                                        smellTypeList = data;
                                      });
                                    },
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: px(12.0)),
                                  child: Text(
                                    '${smellTypeList[index]['name']}',
                                    style: TextStyle(
                                      color: Color(0XFF45474D),
                                      fontSize: sp(28.0),
                                      fontWeight: FontWeight.w500
                                    )
                                  )
                                )
                              ]
                            )
                            );
                          }).toList()
                        )
                      ),
                      FormCheck.formRowItem(
                        padding: true,
                        title: '具刺激性',
                        child: Row(
                          children: thrillList.asMap().keys.map((index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  width: px(34.0),
                                  height: px(34.0),
                                  child: Checkbox(
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    activeColor: Color(0XFF4D7CFF),
                                    value: thrillList[index]['value'],
                                    onChanged: (bool val) {
                                      List data = thrillList;
                                      data.forEach((element) {
                                        element['value'] = false;
                                      });
                                      data[index]['value'] = !data[index]['value'];
                                      thrillValue = data[index]['name'] == '是' ? 1 : 0;
                                      setState(() {
                                        thrillList = data;
                                      });
                                    },
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: px(12.0)),
                                  child: Text(
                                    '${thrillList[index]['name']}   ',
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
                        padding: false,
                        title: '气味描述',
                        child: FormCheck.textAreaWidget(
                          hintText: "请填写气味描述",
                          onChanged: (value) {
                            complaintsSmell = value;
                          }
                        )
                      )
                    ]
                  ),
                ),
                /********风力风向********/
                FormCheck.miniTitle('风力风向'),
                FormCheck.fromCard(
                  child: Column(
                    children: [
                      FormCheck.formRowItem(
                        padding: false,
                        title: '风力风向',
                        child: DownInput(
                          hitStr: '请选择风力风向',
                          value: complaintsDirection['name'] ?? null,
                          data: [
                            {"name": "东风"}, {"name": "南风"}, {"name": "西风"}, {"name": "北风"}, 
                            {"name": "东北风"}, {"name": "西北风"}, {"name": "东南风"}, {"name": "西南风"}, 
                          ],
                          callback: (val) {
                            setState(() {
                                complaintsDirection = val;
                            });
                          }
                        )
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: px(24.0)),
                        child: FormCheck.formRowItem(
                          padding: false,
                          title: '风力描述',
                          child: DownInput(
                            hitStr: '请选择风力描述',
                            value: complaintsPower['name'] ?? null,
                            data: [
                              {"name": "无风—预估风力0级"}, {"name": "软风—预估风力1级"},
                              {"name": "轻风—预估风力2级"}, {"name": "微风—预估风力3级"}, 
                              {"name": "和风—预估风力4级"}, {"name": "清劲风—预估风力5级"}, 
                              {"name": "强风—预估风力6级"}, {"name": "疾风—预估风力7级"}, 
                              {"name": "大风—预估风力8级"}, {"name": "烈风—预估风力9级"}, 
                              {"name": "狂风—预估风力10级"}, {"name": "暴风—预估风力11级"}, 
                              {"name": "飓风—预估风力12级"} 
                            ],
                            callback: (val) {
                              setState(() {
                                complaintsPower = val;
                              });
                            }
                          )
                        ),
                      )
                    ]
                  ),
                ),
                /********疑似物质********/
                FormCheck.miniTitle('疑似物质'),
                FormCheck.fromCard(
                  child: Column(
                    children: [
                      FormCheck.formRowItem(
                        padding: false,
                        title: '疑似物质',
                        child: DownInput(
                          hitStr: '请选择疑似物质',
                          more: true,
                          value: likeFactorList.join(','),
                          data: allFactors,
                          callback: (value) {
                            List data = value.map((item) {
                              return item['name'];
                            }).toList();
                            setState(() {
                              likeFactorList = data;
                            });
                          }
                        )
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: px(24.0)),
                        child: FormCheck.formRowItem(
                          alignStart: true,
                          padding: false,
                          title: '现场情况',
                          child: FormCheck.textAreaWidget(
                            hintText: "请填写现场情况",
                            onChanged: (value) {
                              complaintsScene = value;
                            }
                          )
                        )
                      )
                    ]
                  ),
                ),
                /********提交********/
                Padding(
                  padding: EdgeInsets.symmetric(vertical: px(32.0)),
                  child: SubmitButton(function: _postAbnormalComplaints),
                )
              ],
            ),
          )
        )
      )
    );
  }
}