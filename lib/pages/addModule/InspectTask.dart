import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scet_app/components/DownInput.dart';
import 'package:scet_app/components/DialogPages.dart';
import 'package:scet_app/components/TimeSelect.dart';
import 'package:scet_app/components/ToastWidget.dart';
import 'package:scet_app/pages/addModule/components/AccessLocate.dart';
import 'package:scet_app/pages/addModule/components/FormCheck.dart';
import 'package:scet_app/pages/addModule/components/SubmitButton.dart';
import 'package:scet_app/utils/api/Api.dart';
import 'package:scet_app/utils/api/Request.dart';
import 'package:scet_app/utils/tool/dateUtc/dateUtc.dart';
import 'package:scet_app/utils/tool/screen/Adapter.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';

/// 核查任务
class InspectTask extends StatefulWidget {
  @override
  _InspectTaskState createState() => _InspectTaskState();
}

class _InspectTaskState extends State<InspectTask> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  FocusNode blankNode = FocusNode();

  String _typeCode = ''; //任务编号
  String _time = ''; // 发布时间
  String _name = ''; // 任务名称
  String _alarm = ''; //关联警情
  String _publisher = ''; //发布人
  String _verificationExplain = ''; //说明
  String _partitionId = ''; //分区id 记录上一次搜索所有企业的值
  List _partitionList = []; //分区列表
  String _companyPlaceId = ''; //装置区id 记录上一次搜索的装置区列表
  List _companyPlace = []; //装置区列表
  List _peoples = []; //值班人员
  List _publishPlatform = [1, 2, 3]; //发布平台
  List fbpt = [
    {'name': '系统', 'value': true},
    {'name': 'App', 'value': true},
    {'name': '短信通知', 'value': true},
  ];
  List _verificationTasks = []; //核查目标数组
  List _companyList = []; //企业数组
  Map _item = {
    'area': 1,
    'source': '手动设定',
    "longitude": '', //经度
    'latitude': '', //纬度  获取所有企业自
    "partitionName": '', //所在分区
    'partitionId': '', //分区ID
    "companyName": '', //企业名
    'companyId': '', //企业id
    "placeName": '', //装置区名
    'placeId': '', //装置区ID
    "inspector": [], //核查员
    "time": '', //实际执行任务时间
    "access": '', //企业对接人
  };

  @override
  void initState() {
    super.initState();
    _time = dateUtc(DateTime.now().toString());
    _verificationTasks.add(json.decode(json.encode(_item)));
    // _verificationTasks.add(_item);
    _createTaskCode();
    _partitions();
    _dutys();
  }

  /// 提交核查任务
  void _postInspectTask() async {
    Map<String, dynamic> _data = {
      // 'code':_typeCode,
      'name': _name,
      'type': 4,
      'status': 0,
      'runupTime': _time,
      'startTime': _time,
      'publisher': _publisher,
      'publishPlatform': _publishPlatform,
      'verificationExplain': _verificationExplain,
      'verificationTasks': _verificationTasks
    };
    if (_name == '') {
      ToastWidget.showToastMsg('请输入任务名称');
    } else if (_publisher == '') {
      ToastWidget.showToastMsg('请选择发布人');
    } else if (_verificationExplain == '') {
      ToastWidget.showToastMsg('请输入任务说明');
    } else if (_isEmptys()) {
      ToastWidget.showToastMsg('请完善每一项信息');
    } else {
      var response = await Request().post(Api.url['addOrUpdate'], data: _data);
      if (response['code'] == 200) {
        DialogPages.succeedDialog(context, back: () {
          Navigator.pop(context);
        });
      }
    }
  }

  ///时间获取
  void timeChange(DateTime time, int index) {
    if (mounted == true) {
      setState(() {
        _verificationTasks[index]['time'] = time.toString();
        setState(() {});
      });
    }
  }

  ///经纬度获取
  void _getLonLat(longitude, latitude, index) {
    print('经纬度');
    print(longitude);
    print(latitude);
    // _verificationTasks[index]['longitude'] = longitude;
    // _verificationTasks[index]['latitude'] = latitude;
    setState(() {});
  }

  /// 获取任务编号
  void _createTaskCode() async {
    Map<String, dynamic> _data = {'type': 4}; // 核查任务
    var response = await Request().get(Api.url['createCode'], data: _data);
    if (response['code'] == 200) {
      _typeCode = response['data']['code'];
      setState(() {});
    }
  }

  /// 获取所有分区
  void _partitions() async {
    var response = await Request().get(
      Api.url['partitions'],
    );
    if (response['code'] == 200) {
      _partitionList = response['data'];
      setState(() {});
    }
  }

  /// 获取所有企业信息
  void _companys(int index, String id) async {
    Map<String, dynamic> _data = {
      'hasPlace': 1,
      'partitionId': id,
    };
    var response = await Request().get(Api.url['companys'], data: _data);
    if (response['code'] == 200) {
      _companyList = response['data'];
      setState(() {});
    }
  }

  // 多选展示
  String _processorStr(List li) {
    List data = li.map((item) {
      return item['name'];
    }).toList();
    return data.join(',');
  }

  // 查看值班人员
  void _dutys() async {
    var response = await Request().get(Api.url['dutys']);
    if (response['code'] == 200) {
      _peoples = response['data'];
      setState(() {});
    }
  }

  ///发布平台 选中事件
  void _seletIndex(bool val, int index) {
    if (val && !_publishPlatform.contains(index + 1)) {
      _publishPlatform.add(index + 1);
    } else if (!val && _publishPlatform.contains(index + 1)) {
      _publishPlatform.remove(index + 1);
    }
    // print(_publishPlatform);
    List data = fbpt;
    data[index]['value'] = !data[index]['value'];
    setState(() {
      fbpt = data;
    });
  }

  // 对象的非空校验
  bool _isEmptys() {
    // 判断数组每个对象内是否有为空的值
    bool isEmpty = false;
    _verificationTasks.forEach((object) {
      object.forEach((key, value) {
        if (object[key] == '' || object[key] == null || object[key] == []) {
          isEmpty = true;
        }
      });
    });
    return isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: Size(Adapt.screenW(), px(Adapter.topBarHeight)),
          child: AppBar(
              title: Text('添加核查任务',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: sp(Adapter.appBarFontSize))),
              elevation: 0,
              centerTitle: true),
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
                    child: Column(children: [
                      FormCheck.formRowItem(
                          padding: false,
                          title: '任务编号',
                          child: FormCheck.textData(data: '${_typeCode}')),
                      FormCheck.formRowItem(
                          padding: true,
                          title: '任务名称',
                          child: FormCheck.inputWidget(
                              hintText: '请输入任务名称',
                              onChanged: (taskName) {
                                _name = taskName;
                              })),
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
                      //         _alarm = val['value'];
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
                              _publisher = val == null ? '' : val['name'];
                              setState(() {});
                            },
                          )),
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
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        activeColor: Color(0XFF4D7CFF),
                                        value: fbpt[index]['value'],
                                        onChanged: (bool? val) {
                                          _seletIndex(val!, index);
                                        },
                                      )),
                                  Container(
                                      margin: index == fbpt.length - 1
                                          ? EdgeInsets.zero
                                          : EdgeInsets.only(right: px(20.0)),
                                      padding: EdgeInsets.only(left: px(12.0)),
                                      child: Text('${fbpt[index]['name']}   ',
                                          style: TextStyle(
                                              color: fbpt[index]['value']
                                                  ? Color(0xff4D7CFF)
                                                  : Color(0XFF45474D),
                                              fontSize: sp(28.0),
                                              fontWeight: FontWeight.w500)))
                                ]);
                          }).toList())),
                      FormCheck.formRowItem(
                          padding: false,
                          alignStart: true,
                          title: '任务说明',
                          child: FormCheck.textAreaWidget(
                              hintText: "请填写任务说明",
                              onChanged: (val) {
                                _verificationExplain = val;
                              })),
                      FormCheck.formRowItem(
                          padding: true,
                          title: '发布时间',
                          child: FormCheck.textData(data: '${_time}')),
                    ]),
                  ),
                  /******** 核查目标 ********/
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FormCheck.miniTitle('核查目标'),
                        Container(
                            width: Width(38.0),
                            height: Width(38.0),
                            margin: EdgeInsets.only(right: Width(24.0)),
                            child: InkWell(
                                child: Image.asset(
                                  'assets/icon/other/add.png',
                                  width: px(38),
                                ),
                                onTap: () {
                                  _verificationTasks
                                      .add(json.decode(json.encode(_item)));
                                  ToastWidget.showToastMsg(
                                      '新增成功，当前有${_verificationTasks.length}个核查目标');
                                  setState(() {});
                                }))
                      ]),
                  Column(
                    children: _verificationTasks.asMap().keys.map((index) {
                      return FormCheck.fromCard(
                          child: Column(children: [
                            FormCheck.formRowItem(
                                padding: false,
                                title: '目标序号',
                                child:
                                    FormCheck.textData(data: '${index + 1}P')),
                            FormCheck.formRowItem(
                                padding: true,
                                title: '所在位置',
                                child: AccessLocate(
                                  callback: (lon, lat) =>
                                      _getLonLat(lon, lat, index),
                                  hintStrl: _verificationTasks[index]
                                          ['longitude'] +
                                      ',' +
                                      _verificationTasks[index]['latitude'],
                                )),
                            FormCheck.formRowItem(
                                padding: false,
                                title: '所在分区',
                                child: DownInput(
                                    hitStr: '请选择所在分区',
                                    data: _partitionList,
                                    value: _verificationTasks[index]
                                        ['partitionName'],
                                    callback: (val) {
                                      _verificationTasks[index]
                                              ['partitionName'] =
                                          val == null ? '' : val['name'];
                                      _verificationTasks[index]['partitionId'] =
                                          val == null ? '' : val['id'];
                                      _partitionId =
                                          val == null ? '' : val['id'];
                                      setState(() {});
                                      _companys(
                                          index,
                                          _verificationTasks[index]
                                              ['partitionId']);
                                    })),
                            FormCheck.formRowItem(
                                padding: true,
                                title: '区域企业',
                                child: DownInput(
                                    hitStr: '请选择区域企业',
                                    data: _companyList,
                                    value: _verificationTasks[index]
                                        ['companyName'],
                                    beforeClick: () {
                                      if (_verificationTasks[index]
                                                  ['partitionName'] ==
                                              '' ||
                                          _verificationTasks[index]
                                                  ['partitionName'] ==
                                              null ||
                                          _verificationTasks[index]
                                                  ['partitionId'] !=
                                              _partitionId) {
                                        ToastWidget.showToastMsg('请先选择或重新选择分区');
                                        _companyList = [];
                                        setState(() {});
                                      }
                                    },
                                    callback: (val) {
                                      _verificationTasks[index]['companyName'] =
                                          val == null ? '' : val['name'];
                                      _verificationTasks[index]['companyId'] =
                                          val == null ? '' : val['id'];
                                      _verificationTasks[index]['access'] =
                                          val == null
                                              ? ''
                                              : val['emergencyContact'] +
                                                  ',' +
                                                  val['emergencyPhone'];
                                      _companyPlace = val == null
                                          ? []
                                          : val['companyPlace'];
                                      _companyPlaceId =
                                          val == null ? '' : val['id'];
                                      setState(() {});
                                    })),
                            FormCheck.formRowItem(
                                padding: false,
                                title: '装  置  区',
                                child: DownInput(
                                    hitStr: '请选择装置区',
                                    value: _verificationTasks[index]
                                        ['placeName'],
                                    data: _companyPlace,
                                    beforeClick: () {
                                      if (_verificationTasks[index]
                                                  ['companyName'] ==
                                              '' ||
                                          _verificationTasks[index]
                                                  ['companyName'] ==
                                              null ||
                                          _verificationTasks[index]
                                                  ['companyId'] !=
                                              _companyPlaceId) {
                                        ToastWidget.showToastMsg('请先选择或重新选择企业');
                                        _companyPlace = [];
                                        setState(() {});
                                      }
                                    },
                                    callback: (val) {
                                      _verificationTasks[index]['placeId'] =
                                          val == null ? '' : val['id'];
                                      _verificationTasks[index]['placeName'] =
                                          val == null ? '' : val['name'];
                                      _verificationTasks[index]['longitude'] =
                                          val == null ? '' : val['longitude'];
                                      _verificationTasks[index]['latitude'] =
                                          val == null ? '' : val['latitude'];
                                      setState(() {});
                                    })),
                            FormCheck.formRowItem(
                                padding: true,
                                title: '核  查  项',
                                child: FormCheck.inputWidget(
                                    hintText: '请输入核查项',
                                    onChanged: (val) {
                                      print('未设置参数${val}');
                                    })),
                            FormCheck.formRowItem(
                                padding: false,
                                title: '人员配置',
                                child: DownInput(
                                  hitStr: '请选择发布人',
                                  value: _processorStr(
                                      _verificationTasks[index]['inspector']),
                                  data: _peoples,
                                  more: true,
                                  callback: (val) {
                                    _verificationTasks[index]['inspector'] =
                                        val;
                                    setState(() {});
                                  },
                                )),
                            FormCheck.formRowItem(
                                padding: true,
                                title: '执行时间',
                                child: TimeSelect(
                                    scaffoldKey: _scaffoldKey,
                                    hintText: "请选择执行时间",
                                    callBack: (time) =>
                                        timeChange(time, index))),
                            FormCheck.formRowItem(
                                padding: false,
                                title: '对  接  人',
                                child: FormCheck.inputWidget(
                                    disabled: false,
                                    hintText: _verificationTasks[index]
                                                ['access'] ==
                                            ''
                                        ? '请输入企业对接人'
                                        : _verificationTasks[index]['access'],
                                    onChanged: (val) {
                                      _verificationTasks[index]['access'] = val;
                                      setState(() {});
                                    })),
                          ]),
                          close: () {
                            _verificationTasks.removeAt(index);
                            setState(() {});
                          });
                    }).toList(),
                  ),
                  /******** 提交 ********/
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: px(32.0)),
                    child: SubmitButton(function: _postInspectTask),
                  )
                ],
              ),
            ))));
  }
}
