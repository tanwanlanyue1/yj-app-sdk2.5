import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scet_app/components/ToastWidget.dart';
import 'package:scet_app/model/provider/provider.dart';
import 'package:scet_app/pages/LoginModel/components/addFont.dart';
import 'package:scet_app/pages/loginModel/loginPage.dart';
import 'package:scet_app/routers/router_animation/router_animate.dart';
import 'package:scet_app/utils/api/Api.dart';
import 'package:scet_app/utils/api/Request.dart';
import 'package:scet_app/utils/tool/screen/Adapter.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';
import 'package:provider/provider.dart';
import 'package:scet_app/utils/tool/storage/data_storageKey.dart';
import 'package:scet_app/utils/tool/storage/storage.dart';
class GuidePage extends StatefulWidget {
  @override
  _GuidePageState createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {

  void _loginPage() async {
    Navigator.of(context).pushAndRemoveUntil(
        CustomRoute(LoginPage()),
        (router) => router == null);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //App首次启动的资源下载弹框
    if(StorageUtil().getBool(StorageKey.STORAGE_DEVICE_ALREADY_OPEN_KEY) != true){
      Future.microtask((){
        showDialog<Null>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return GestureDetector(
                onTap: () {},
                child:Material(
                  color: Color.fromRGBO(0, 0, 0, 0.5),
                  child: AddFont(),
                )
            );
          },
        );
      });
    }else{
     //App更新预留弹框
      Future.microtask(() =>context.read<AppState>().checkystem(context));
    }
  }
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(Adapter.designWidth, Adapter.designHeight), allowFontScaling: false);
    return Scaffold(
      body: Container(
        color: Colors.white,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _bgimg(),
            _text(),
            _login(),
          ],
        ),
      ),
    );
  }

  ///背景图
  Widget _bgimg() {
    return Image.asset(
      'assets/images/login/guide.png',
      width: px(616),
      height: px(639),
    );
  }

  ///内容
  Widget _text() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: px(101)),
          child: Text(
            '全新上线',
            style: TextStyle(
                fontSize: sp(56), color: Color(0xFF2A2A2A), fontFamily: "B"),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: px(20)),
          child: Text(
            '掌握园区状态，提高效率',
            style: TextStyle(
              fontSize: sp(30),
              color: Color(0xFF999999),
            ),
          ),
        ),
      ],
    );
  }

  ///登录按钮
  Widget _login() {
    return Padding(
        padding: EdgeInsets.only(top: px(128)),
        child: InkWell(
          onTap: () => _loginPage(),
          child: Container(
            width: px(262),
            height: px(76),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Color(0xFF4D7CFF),
                borderRadius: BorderRadius.all(Radius.circular(px(6)))),
            child: Text(
              '登录/注册',
              style: TextStyle(
                fontSize: sp(30),
                color: Color(0xFFffffff),
              ),
            ),
          ),
        )
    );
  }
}