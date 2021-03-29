import 'package:flutter/material.dart';
import 'package:scet_app/pages/UserModule/MyIssue/myIssueComponent.dart';
import 'package:scet_app/utils/tool/screen/Adapter.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';

class MyAbnormalComplaints extends StatefulWidget {
  @override
  _MyAbnormalComplaintsState createState() => _MyAbnormalComplaintsState();
}

class _MyAbnormalComplaintsState extends State<MyAbnormalComplaints> {
  List _data = [
    {
      'stName':'A村附近恶臭味投诉',
      'rwbh':'YS-20201002-B01',
      'tssm':'村防护边界预估最大落地浓度点监测，请前往监测',
      'tsss':'2020-10-02 10:00。。',
      'tsr':'杨村民',
    }
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('异常投诉',style: TextStyle(
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
                        onDetails:(){
                          print('异常投诉');
                        }
                    ),
                    MyIssueComponent.rowItem(
                        title: '任务编号',
                        data: item['rwbh']
                    ),
                    MyIssueComponent.rowItem(
                        title: '投诉说明',
                        isCenter: false,
                        data:  item['tssm']
                    ),
                    MyIssueComponent.rowItem(
                        title: '投诉时间',
                        data:  item['tsss']
                    ),
                    MyIssueComponent.rowItem(
                        title: '投 诉 人 ',
                        data:  item['tsr']
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
