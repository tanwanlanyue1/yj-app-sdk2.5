import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scet_dz/api/Api.dart';
import 'package:scet_dz/api/Request.dart';
import 'package:scet_dz/components/DownInput.dart';
import 'package:scet_dz/components/WidgetCheck.dart';
import 'package:scet_dz/components/TimeSelect.dart';
import 'package:scet_dz/components/ToastWidget.dart';
import 'package:scet_dz/model/provider/provider_home.dart';
import 'package:scet_dz/pages/ModuleMonitor/Components/SubmitButton.dart';
import 'package:scet_dz/utils/screen/Adapter.dart';
import 'package:scet_dz/utils/screen/screen.dart';

/*------------添加巡检-------------*/ 
class UploadInspection extends StatefulWidget {
  @override
  _UploadInspectionState createState() => _UploadInspectionState();
}

class _UploadInspectionState extends State<UploadInspection> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  FocusNode blankNode = FocusNode();

  String? person, remark;
  
  Map station = {};

  DateTime? currentTime;
  void timeChange(DateTime time) {
    if (mounted) {
      setState(() {
        currentTime = time;
      });
    }
  }

  void _postAddMaintenance() async{
    if(station['value'] == null) {
      ToastWidget.showToastMsg('请选择巡检点位！');
    } else if(currentTime == null){
      ToastWidget.showToastMsg('请选择时间！');
    } else if(person == null) {
      ToastWidget.showToastMsg('请输入巡检人员！');
    } else if(remark == null) {
      ToastWidget.showToastMsg('请输入巡检描述！');
    } else {
      Map<String, dynamic> params = Map();
      params['stId'] = station['value'];
      params['time'] = currentTime.toString();
      params['name'] = person;
      params['remark'] = remark;
      var response = await Request().post(Api.url['patrolUpload'],data: params);
      if(response['code'] == 200) {
        ToastWidget.showToastMsg('添加站点巡检成功！');
        Navigator.pop(context);
      }
    }
  }

  // 获取站点数据
  List _stationList() {
    var _homeModel = Provider.of<HomeModel>(context, listen: true);
    List data = _homeModel.siteList;
    return data.map((item) {
      return {"name": item['stName'], "value": item['stId'].toString()};
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
            '添加站点巡检', 
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
            padding: EdgeInsets.symmetric(horizontal: px(20.0), vertical: px(24.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WidgetCheck.fromCard(
                  child: Column(
                    children: [
                      WidgetCheck.rowItem(
                        padding: false,
                        title: '巡检位置',
                        child: DownInput(
                          hitStr: '请选择巡检站点',
                          value: station['name'] ?? '',
                          data: _stationList(),
                          callback: (val) {
                            setState(() {
                              station = val;
                            });
                          }
                        )
                      ),
                      WidgetCheck.rowItem(
                        padding: true,
                        title: '巡检时间',
                        child: TimeSelect(
                          scaffoldKey: _scaffoldKey,
                          hintText: "请选择巡检时间",
                          callBack: (time ) => timeChange(time)
                        )
                      ),
                      WidgetCheck.rowItem(
                        padding: false,
                        title: '巡检人员',
                        child: WidgetCheck.inputWidget(
                          hintText: '请填写巡检人员',
                          onChanged: (val) {
                            person = val;
                          }
                        )
                      ),
                      WidgetCheck.rowItem(
                        alignStart: true,
                        padding: true,
                        title: '巡检描述',
                        child: WidgetCheck.textAreaWidget(
                          hintText: "请填写巡检描述",
                          onChanged: (val) {
                            remark = val;
                          }
                        )
                      )
                    ]
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: px(475.0)),
                  child: SubmitButton(function: _postAddMaintenance)
                )
              ],
            )
          )
        )
      ),
    );
  }
}