import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

/// 监测任务
class MonitorTask extends StatefulWidget {
  @override
  _MonitorTaskState createState() => _MonitorTaskState();
}

class _MonitorTaskState extends State<MonitorTask> {

  FocusNode blankNode = FocusNode();

  String _typeCode ='';       //任务编号
  String _time = '';          // 发布时间
  String _name = '';          // 任务名称
  String _publisher = '';     //发布人
  String _verificationExplain = ''; //说明

  List _monitoringTasks= []; // 监测任务列表
  List _publishPlatform = [1,2,3]; //发布平台
  List fbpt = [
    {'name': '系统', 'value': true},
    {'name': 'App', 'value': true},
    {'name': '短信通知', 'value': true}
  ];

  List _peoples = []; //值班人员
  List _chemicalList = []; //监测的物质
  List _equipmentList = []; //监测的设备
  List _resourceList =[];   //防护设备

  Map _item = {
    "longitude": '',//经度
    'latitude': '', //纬度
    "point": '',//点名称
    'functional':'',//功能分类
    'monitoringStaff':[],//监测人员
    'factor':[], //监测物质
    'instrument':[], //监测仪器
    'protectEquipment':[],//防护设备配置
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _time = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
    _monitoringTasks.add(json.decode(json.encode(_item)));
    _createTaskCode();
    _dutys();
    _chemicals();
    _equipments();
    _resources();
  }

  ///添加监测任务
  void _postMonitorTask() async {
    Map<String, dynamic> _data = {
      // 'code':_typeCode,
      'name':_name,
      'type':5,
      'status':0,
      'runupTime':_time,
      'startTime':_time,
      'publisher':_publisher,
      'publishPlatform':_publishPlatform,
      // 'verificationExplain':_verificationExplain,
      'monitoringTasks':_monitoringTasks
    };
    if(_name == '') {
      ToastWidget.showToastMsg('请输入任务名称');
    } else if(_publisher == '') {
      ToastWidget.showToastMsg('请选择发布人');
    } else if(_isEmptys()) {
      ToastWidget.showToastMsg('请完善每一项信息');
    } else {
      var response = await Request().post(Api.url['addOrUpdate'], data: _data);
      if(response['code'] == 200){
        DialogPages.succeedDialog(
          context,
          back: () { Navigator.pop(context); }
        );
        ToastWidget.showToastMsg('添加成功');
      }
    }
  }

  /// 经纬度获取
  void _getLonLat(longitude, latitude,index) {
    _monitoringTasks[index]['longitude'] = longitude;
    _monitoringTasks[index]['latitude'] = latitude;
    setState(() {});
  }

  /// 获取任务编号
  void _createTaskCode() async {
    Map<String, dynamic> _data = {'type': 5 };// 核查任务
    var response = await Request().get(Api.url['createCode'], data: _data);
    if(response['code'] == 200){
      _typeCode = response['data']['code'];
      setState(() {});
    }
  }

  ///查看值班人员
  void _dutys() async {
    var response = await Request().get(Api.url['dutys']);
    if(response['code'] == 200){
      _peoples = response['data'];
      setState(() {});
    }
  }

  ///  查看应急监测设备监测的物质
  void _chemicals() async {
    var response = await Request().get(Api.url['chemicalsList']);
    if(response['code'] == 200){
      _chemicalList = response['data'];
      setState(() {});
    }
  }

  ///  查看应急监测设备
  void _equipments() async {
    var response = await Request().get(Api.url['equipments']);
    if(response['code'] == 200){
      _equipmentList = response['data'];
      setState(() {});
    }
  }

  ///  查看防护设备
  void _resources() async {
    var response = await Request().get(Api.url['resources']);
    if(response['code'] == 200){
      _resourceList = response['data'];
      setState(() {});
    }
  }

  ///发布平台 选中事件
  void _seletIndex(bool val,int index) {
    if(val && !_publishPlatform.contains(index+1)) {
      _publishPlatform.add(index+1);
    }else if(!val && _publishPlatform.contains(index+1)) {
      _publishPlatform.remove(index+1);
    }
    // print(_publishPlatform);
    List data = fbpt;
    data[index]['value'] = !data[index]['value'];
    setState(() {
      fbpt = data;
    });
  }

  ///多选人员配置的展示
  String _processorStr(List li){
    List data =  li.map((item) {
      return item['name'];
    }).toList();
    print(data);
    return data.join(',');
  }
  ///对象的非空校验
  bool _isEmptys() { // 判断数组每个对象内是否有为空的值
    bool isEmpty = false;
    _monitoringTasks.forEach((object) {
      object.forEach((key, value) {
        if(object[key] == '' || object[key] == null  || object[key] == [] ){
          print('key值为空 ==>${key}');
          isEmpty =  true;
        }
      });
    });
    return isEmpty;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(Adapt.screenW(), px(Adapter.topBarHeight)),
        child: AppBar(
          title: Text(
            '添加监测任务',
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
            padding: EdgeInsets.symmetric(horizontal: Width(20.0)),
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
                        title: '任务编号',
                        child: FormCheck.textData(data: _typeCode)
                      ),
                      FormCheck.formRowItem(
                        padding: true,
                        title: '任务名称',
                        child: FormCheck.inputWidget(
                          hintText: '请输入任务名称',
                          onChanged: (taskName) {
                            _name = taskName;
                          }
                        )
                      ),
                      // FormCheck.formRowItem(
                      //   padding: false,
                      //   title: '关联警情',
                      //   child: DownInput(
                      //     hitStr: '请选择关联警情',
                      //     data: [
                      //       {"name": "警情1", "value": "警情1"},
                      //       {"name": "警情2", "value": "警情2"}
                      //     ],
                      //     callback: (val) {
                      //       setState(() {
                      //         alarm = val['value'];
                      //       });
                      //     }
                      //   )
                      // ),
                      FormCheck.formRowItem(
                        padding: false,
                        title: '发  布  人',
                        child: DownInput(
                          hitStr: '请选择发布人',
                          data: _peoples,
                          value: _publisher,
                          callback: (val) {
                            _publisher = val['name'];
                            setState(() {});
                          }
                        )
                      ),
                      FormCheck.formRowItem(
                        padding: true,
                        title: '发布平台',
                        child: Row(
                          children: fbpt.asMap().keys.map((index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  width: px(34.0),
                                  height: px(34.0),
                                  child: Checkbox(
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    activeColor: Color(0XFF4D7CFF),
                                    value: fbpt[index]['value'],
                                    onChanged: (bool val) {
                                      _seletIndex(val,index);
                                    },
                                  )
                                ),
                                Container(
                                  margin: index == fbpt.length - 1 ? EdgeInsets.zero : EdgeInsets.only(right: px(20.0)),
                                  padding: EdgeInsets.only(left: px(12.0)),
                                  child: Text(
                                    '${fbpt[index]['name']}   ',
                                    style: TextStyle(
                                        color:fbpt[index]['value'] ? Color(0xff4D7CFF) : Color(0XFF45474D),
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
                        padding: false,
                        title: '发布时间',
                        child: FormCheck.textData(data: '2020-09-28  10:00:00')
                      ),
                    ]
                  ),
                ),
                /********监测点位设定********/
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FormCheck.miniTitle('监测点位设定'),
                    Container(
                      width: Width(38.0),
                      height: Width(38.0),
                      margin: EdgeInsets.only(right: Width(24.0)),
                      child: InkWell(
                        child:Image.asset('assets/icon/other/add.png',width: px(38),),
                        onTap: () {
                          _monitoringTasks.add(json.decode(json.encode(_item)));
                          ToastWidget.showToastMsg('新增成功，当前有${_monitoringTasks.length}个监测目标');
                          setState(() {});
                        }
                      )
                    )
                  ]
                ),
                Column(
                  children: _monitoringTasks.asMap().keys.map((index) {
                    return FormCheck.fromCard(
                      child: Column(
                        children: [
                          FormCheck.formRowItem(
                            padding: false,
                            title: '目标序号',
                            child: FormCheck.textData(data: '${index+1}P')
                          ),
                          FormCheck.formRowItem(
                            padding: true,
                            title: '所在位置',
                            child: AccessLocate(
                              callback: (lon, lat) => _getLonLat(lon, lat,index),
                              hintStrl:_monitoringTasks[index]['longitude'] + ',' + _monitoringTasks[index]['latitude'] ,
                            )
                          ),
                          FormCheck.formRowItem(
                            padding: false,
                            title: '点位名称',
                            child: FormCheck.inputWidget(
                              hintText: '请输入点位名称',
                              onChanged: (val) {
                                _monitoringTasks[index]['point'] = val;
                              }
                            )
                          ),
                          FormCheck.formRowItem(
                            padding: true,
                            title: '功能分类',
                            child: DownInput(
                              hitStr: '请选择功能类型',
                              value: _monitoringTasks[index]['functional'],
                              data: [
                                {"name": "上风向-敏感区防护", "value": "上风向-敏感区防护"},
                                {"name": "下风向-敏感区防护", "value": "下风向-敏感区防护"}
                                ],
                              callback: (val) {
                                _monitoringTasks[index]['functional'] = val['value'];
                                setState(() {});
                              }
                            )
                          ),
                          FormCheck.formRowItem(
                            padding: false,
                            title: '监测人员',
                            child: DownInput(
                              hitStr: '请选择相关人员',
                              data: _peoples,
                              value:_processorStr(_monitoringTasks[index]['monitoringStaff']),
                              more: true,
                              callback: (val) {
                                _monitoringTasks[index]['monitoringStaff'] = val;
                                setState(() {});
                              }
                            )
                          ),
                          FormCheck.formRowItem(
                            padding: true,
                            title: '目标物质',
                            child: DownInput(
                              hitStr: '请选择监测物质',
                              more: true,
                              data: _chemicalList,
                              value: _monitoringTasks[index]['factor'].join(','),
                              callback: (val) {
                                List strList = [];
                                val.forEach((item) {
                                strList.add(item['name']);
                                });
                                _monitoringTasks[index]['factor'] = strList;
                                setState(() {});
                              }
                            )
                          ),
                          FormCheck.formRowItem(
                            padding: false,
                            title: '监测配置',
                            child: DownInput(
                              hitStr: '请选择相关配置',
                              value: _monitoringTasks[index]['instrument'].join(','),
                              data: _equipmentList,
                              more: true,
                              callback: (val) {
                                List strList = [];
                                val.forEach((item) {
                                  strList.add(item['name']);
                                  });
                                _monitoringTasks[index]['instrument'] = strList;
                                setState(() {});
                              }
                            )
                          ),
                          FormCheck.formRowItem(
                            padding: true,
                            title: '防护配置',
                            child: DownInput(
                              hitStr: '请选择相关防护设备',
                              data: _resourceList,
                              more: true,
                              value: _monitoringTasks[index]['protectEquipment'].join(','),
                              callback: (val) {
                                List strList = [];
                                val.forEach((item) {
                                  strList.add(item['name']);
                                });
                                _monitoringTasks[index]['protectEquipment'] = strList;
                                setState(() {});
                              }
                            )
                          )
                        ]
                      ),
                      close: (){
                        _monitoringTasks.removeAt(index);
                        setState(() {});
                      }
                    );
                  }).toList(),
                ),
                /********提交********/
                Padding(
                  padding: EdgeInsets.symmetric(vertical: px(32.0)),
                  child: SubmitButton(function: _postMonitorTask),
                )
              ],
            ),
          )
        )
      )
    );
  }
}