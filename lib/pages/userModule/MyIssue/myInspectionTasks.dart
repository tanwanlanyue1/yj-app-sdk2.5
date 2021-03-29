import 'package:flutter/material.dart';
import 'package:scet_app/pages/UserModule/MyIssue/myIssueComponent.dart';
import 'package:scet_app/utils/tool/screen/Adapter.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';

class MyInspectionTasks extends StatefulWidget {
  @override
  _MyInspectionTasksState createState() => _MyInspectionTasksState();
}

class _MyInspectionTasksState extends State<MyInspectionTasks> {
  List _data = [
    {
      'status':'2',
      'stName':'瀛海子站巡检任务',
      'xjwz':'瀛海子站',
      'xjry':'张晓阳',
      'xjms':'瀛海子站站点日常巡检任务。。',
      'xjsj':'2020-10-02 10:00~14:00',
      'fbr':'杨大锤',
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('巡检任务',style: TextStyle(
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
                        title: '巡检位置',
                        data: item['xjwz']
                    ),
                    MyIssueComponent.rowItem(
                        title: '巡检人员',
                        data:  item['xjry']
                    ),
                    MyIssueComponent.rowItem(
                        title: '巡检描述',
                        isCenter: false,
                        data:  item['xjms']
                    ),
                    MyIssueComponent.rowItem(
                        title: '巡检时间',
                        data:  item['xjsj']
                    ),
                    MyIssueComponent.rowItem(
                        title: '发 布 人 ',
                        data:  item['fbr']
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
