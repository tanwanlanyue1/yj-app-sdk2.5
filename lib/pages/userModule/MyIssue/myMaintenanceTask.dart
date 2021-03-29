import 'package:flutter/material.dart';
import 'package:scet_app/pages/UserModule/MyIssue/myIssueComponent.dart';
import 'package:scet_app/pages/UserModule/UserLogin.dart';
import 'package:scet_app/utils/tool/screen/Adapter.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';

class MyMaintenanceTask extends StatefulWidget {
  @override
  _MyMaintenanceTaskState createState() => _MyMaintenanceTaskState();
}

class _MyMaintenanceTaskState extends State<MyMaintenanceTask> {
  List _data = [
    {
      'status':'2',
      'stName':'管委会子站-六参数气象仪仪器检修',
      'swz':'管委会子站',
      'smc':'六参数气象仪',
      'tyxz':'监测数据报错。',
      'sqry':'杨大锤',
      'tysj':'2020-10-12 16:00',
      'yqxf':'2020-10-12 16:00',
      'tzyz':true,
      'tyyy':'暂时未知。',
    }
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('检修任务',style: TextStyle(
            color: Colors.white,
            fontSize: sp(Adapter.appBarFontSize)
        ),),
        centerTitle: true,
      ),
      body: Container(
        child: ListView.builder(
          itemCount: _data.length,
          itemBuilder: (BuildContext context,int index){
            Map item = _data[index];
              return  MyIssueComponent.card(
                  child:Column(
                    children: [
                      MyIssueComponent.maintenanceTitle(
                          title: item['stName'] ,
                          status: item['status'] ,
                      ),
                      MyIssueComponent.rowItem(
                          title: '设备位置',
                          data: item['swz']
                      ),
                      MyIssueComponent.rowItem(
                          title: '设备名称',
                          data:  item['smc']
                      ),
                      MyIssueComponent.rowItem(
                          title: '停用性质',
                          data:  item['tyxz']
                      ),
                      MyIssueComponent.rowItem(
                          title: '申请人员',
                          data:  item['sqry']
                      ),
                      MyIssueComponent.rowItem(
                          title: '停运时间',
                          data:  item['tysj']
                      ),
                      MyIssueComponent.rowItem(
                          title: '预期修复',
                          data:  item['yqxf']
                      ),
                      MyIssueComponent.rowItem(
                          title: '通知业主',
                          data:  item['tzyz'] ? '是': '否'
                      ),
                      MyIssueComponent.rowItem(
                          title: '停运原因',
                          data:  item['tyyy']
                      ),
                    ],
                  )
              );
              },
        ),
      ),
    );
  }
}
