import 'dart:ui';
import 'package:cs_app/model/data/data_jpush.dart';
import 'package:cs_app/utils/storage/data_storageKey.dart';
import 'package:flutter/material.dart';
import 'package:cs_app/api/Api.dart';
import 'package:cs_app/api/Request.dart';
import 'package:cs_app/components/ToastWidget.dart';
import 'package:cs_app/utils/screen/screen.dart';
import 'package:cs_app/utils/storage/storage.dart';

class UserCenter extends StatefulWidget {
  _UserCenterState createState() => _UserCenterState();
}

class _UserCenterState extends State<UserCenter> {

  Map userInfo = {};

  void _getUserInfo() async {
    var response = await Request().get(Api.url['userInfo']);
    if(response['code'] == 200) {
      setState(() {
        userInfo = response['data'];
      });
    } else {
      ToastWidget.showToastMsg(response['status']);
    }
  }

  @override
  void initState() {
    _getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(bottom: px(40.0)),
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: px(480.0),
                  width: Adapt.screenW(),
                  child: Image.asset(
                    'lib/assets/images/personCenter_bg.png',
                    fit: BoxFit.cover,
                  ),
                ),
                // 标题栏
                _topTitle(),
                // 头像部分
                Positioned(
                  top: px(220.0),
                  left: px(40.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(px(20.0)),
                      child: Image.asset(
                      "lib/assets/images/user.jpg",
                      fit: BoxFit.fill,
                      height: px(220.0),
                      width: px(220.0),
                    ) 
                  )
                ),
              ]
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start, 
                children: [
                  Column(
                    children: [
                      // 姓名
                      Container(
                        padding: EdgeInsets.only(left: px(80.0)),
                        child: Row(
                          children: <Widget>[
                            Text(
                              '${userInfo['turename'] ?? '/'}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: sp(40.0),
                                fontWeight: FontWeight.w600,
                              )
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: px(48.0)),
                              child: Text(
                                '编号：scet-001',
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: sp(32.0),
                                )
                              ),
                            )
                          ]
                        )
                      ),
                      _itemInfoCard(0, '职务', userInfo['work'], '电话', userInfo['phone']),
                      _itemInfoCard(1, '单位', userInfo['companyName'], '地址', userInfo['companyAddress']),
                    ],
                  ),
                  // 退出登录
                  Container(
                    height: px(100.0),
                    width: Adapt.screenW(),
                    padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: px(100.0)),
                    child: RaisedButton(
                      color: Color(0xFF1D7DFE),
                      child: Text(
                        '退出登录',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: sp(32.0)
                        ),
                      ),
                      onPressed: (){
                        // jpushPhone(userInfo['phone']);
                        JpushData.stopPush(); // 停止推送
                        StorageUtil().remove(StorageKey.Token);
                        StorageUtil().remove(StorageKey.user,);
                        JpushData.cleanTags();
                        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                      }
                    ),
                  )
                ]
              )
            )
          ]
        ),
      ),
    );
  }

  Widget _topTitle() {
    return Positioned(
      top: MediaQueryData.fromWindow(window).padding.top,
      child: Container(
        width: Adapt.screenW(),
        padding: EdgeInsets.symmetric(horizontal: px(8.0)), 
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center, 
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back, size: sp(50.0), color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Text(
              '个人中心', 
              style: TextStyle(
                fontSize: sp(40.0), 
                color: Colors.white, 
                fontWeight: FontWeight.w400
              )
            ),
            Opacity(
              opacity: 0.0, 
              child: IconButton(
                icon: Icon(Icons.edit, size: sp(50.0), color: Colors.white), 
                onPressed: null
              )
            )
          ]
        ),
      ),
    );
  }

  Widget _itemInfoCard(int index, String firstName, String? firstValue, String? secondName, String? secondValue) {
    return Container(
      margin: EdgeInsets.only(top: px(50.0)),
      padding: EdgeInsets.symmetric(horizontal: px(20.0)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(px(14.0)),
        child: Container(
          height: px(180.0),
          padding: EdgeInsets.only(left: px(20.0)),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: index == 0 
                ? [Color(0xFF0091EA), Color(0XFF29B6F6), Color(0XFF00E5FF)] 
                : [Color(0xFF0091EA), Color(0XFFBA68C8), Color(0XFF8E24AA)], 
              begin: FractionalOffset(0, 1), 
              end: FractionalOffset(1, 0)
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    '$firstName',
                    style: TextStyle(
                      color: Colors.white, 
                      fontSize: sp(30.0)
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: px(30.0)),
                    child: Text(
                      '${firstValue ?? '/'}',
                      style: TextStyle(
                        color: Colors.white, 
                        fontSize: sp(32.0), 
                        fontWeight: FontWeight.w600)
                    )
                  )
                ]
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        '$secondName',
                        style: TextStyle(
                          color: Colors.white, 
                          fontSize: sp(30.0)
                        )
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: px(30.0)),
                        child: Text(
                          '${secondValue ?? '/'}',
                          style: TextStyle(color: 
                            Colors.white,
                            fontSize: sp(32.0), 
                            fontWeight: FontWeight.w600
                          )
                        )
                      )
                    ]
                  ),
                ]
              )
            ]
          )
        ),
      )
    );
  }
}
