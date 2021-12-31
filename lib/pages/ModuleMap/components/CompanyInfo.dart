import 'package:flutter/material.dart';
import 'package:cs_app/utils/screen/screen.dart';

class CompanyInfo extends StatelessWidget {

  final Map company;
  CompanyInfo(this.company);

  TextStyle nameStyle = TextStyle(color: Colors.black54, fontSize: sp(24.0), fontWeight: FontWeight.w500);
  TextStyle valueStyle = TextStyle(color: Colors.black87, fontSize: sp(26.0), fontWeight: FontWeight.w400);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        height: px(580.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget> [
            Container(
              width: Adapt.screenW(),
              child: Text(
                '${company['name']}',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize:  sp(30.0),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: ListView(
                children: <Widget> [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 6.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Text.rich(
                            TextSpan(text: '应急联系人：',
                              style: nameStyle,
                              children: <TextSpan>[
                                TextSpan(text: '${company['emergencyContact'] != null ? company['emergencyContact'] : '空'}' , style: valueStyle)
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text.rich(
                            TextSpan(text: '应急联系电话：',
                              style: nameStyle,
                              children: <TextSpan>[
                                TextSpan(text: '${company['emergencyPhone'] != null ? company['emergencyPhone'] : '空'}' , style: valueStyle)
                              ],
                            ),
                          ),
                        ),
                      ]
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text.rich(
                          TextSpan(text: '企业法人：',
                            style: nameStyle,
                            children: <TextSpan>[
                              TextSpan(text: '${company['legalPerson'] != null ? company['legalPerson'] : '空'}' , style: valueStyle)
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text.rich(
                          TextSpan(text: '经营状态：',
                            style: nameStyle,
                            children: <TextSpan>[
                              TextSpan(text: '${company['managementState'] != null ? company['managementState'] : '空'}' , style: valueStyle)
                            ],
                          ),
                        ),
                      ),
                    ]
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 6.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Text.rich(
                            TextSpan(text: '成立时间：',
                              style: nameStyle,
                              children: <TextSpan>[
                                TextSpan(text: '${company['establishmentTime'] != null ? company['establishmentTime'] : '空'}' , style: valueStyle)
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text.rich(
                            TextSpan(text: '投产时间：',
                              style: nameStyle,
                              children: <TextSpan>[
                                TextSpan(text: '${company['commissioningTime'] != null ? company['commissioningTime'] : '空'}' , style: valueStyle)
                              ],
                            ),
                          ),
                        ),
                      ]
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 6.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Text.rich(
                            TextSpan(text: '信用代码：',
                              style: nameStyle,
                              children: <TextSpan>[
                                TextSpan(text: '${company['creditCode'] != null ? company['creditCode'] : '空'}' , style: valueStyle)
                              ],
                            ),
                          ),
                        ),
                      ]
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text.rich(
                          TextSpan(text: '行业类型：',
                            style: nameStyle,
                            children: <TextSpan>[
                              TextSpan(text: '${company['industryType'] != null ? company['industryType'] : '空'}' , style: valueStyle)
                            ],
                          ),
                        ),
                      ),
                    ]
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 6.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Text.rich(
                            TextSpan(text: '排污许可：',
                              style: nameStyle,
                              children: <TextSpan>[
                                TextSpan(text: '${company['pollutantsDischarge'] != null ? company['pollutantsDischarge'] : '空'}' , style: valueStyle)
                              ],
                            ),
                          ),
                        ),
                      ]
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text.rich(
                          TextSpan(text: '重大风险源：',
                            style: nameStyle,
                            children: <TextSpan>[
                              TextSpan(text: '${company['majorSources'] != null ? company['majorSources'] : '空'}' , style: valueStyle)
                            ],
                          ),
                        ),
                      ),
                    ]
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 6.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Text.rich(
                            TextSpan(text: '企业概述：',
                              style: nameStyle,
                              children: <TextSpan>[
                                TextSpan(text: '${company['remark'] != null ? company['remark'] : '空'}' , style: valueStyle)
                              ],
                            ),
                          ),
                        ),
                      ]
                    ),
                  ),
                ]
              )
            )
          ]
        ),
      ),
    );
  }
}