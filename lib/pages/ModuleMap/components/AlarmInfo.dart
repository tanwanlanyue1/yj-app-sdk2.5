import 'package:flutter/material.dart';
import 'package:cs_app/utils/screen/screen.dart';

class AlarmInfo extends StatelessWidget {
  final List realAlarm;
  AlarmInfo(this.realAlarm);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: px(550),
        height: px(580),
        color: Colors.white,
        child: Column(
          children: [
            Container(
              height: px(70),
              width: px(550),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: px(10.0)),
                child: Text(
                  '───告警消息推送───',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: sp(28.0),
                      color: Colors.black87
                  ),
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              child: Container(
                // color: Colors.white,
                  height: px(430.0),
                  width: px(550.0),
                  child: realAlarm.length > 0 ?
                  ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      children: [
                        Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: realAlarm.map((item) {
                              return InkWell(
                                  onTap: () {
                                  },
                                  child: Container(
                                      padding: EdgeInsets.symmetric(vertical: px(5.0)),
                                      child: Text.rich(
                                        TextSpan(text: '${item['stName']}：',
                                          style: TextStyle(
                                              fontSize: sp(24.0),
                                              color: Color(0XFF999999)
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(text: '${item['facName']} ${item['value']}${item['unit']}',
                                                style: TextStyle(
                                                    color: Color(0XFF000000),
                                                    fontSize:sp(24.0),
                                                    fontWeight: FontWeight.w400)
                                            )
                                          ],
                                        ),
                                      )
                                  )
                              );
                            }).toList()
                        ),
                      ]
                  )
                      :
                  Center(
                    child: Text(
                        '暂无告警消息！',
                        style: TextStyle(
                            fontSize: sp(24.0),
                            color: Color(0XFF000000)
                        )
                    ),
                  )
              ),
            ),
            Expanded(
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: px(260),
                        child: InkWell(
                          onTap: (){
                            Navigator.pop(context);
                            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false, arguments:{'index': 1,'index1':1},);
                            },
                          child: Container(
                            color: Colors.blueAccent,
                            alignment: Alignment.center,
                            child: Text('立即查看',style: TextStyle(color:Colors.white,fontSize: sp(25),fontWeight: FontWeight.bold),),
                          ),
                        )
                    ),
                  ],
                )
            )
          ],
        ),
      ),
    );
  }
}