import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scet_app/components/ToastWidget.dart';
import 'package:scet_app/pages/HomePage.dart';
import 'package:scet_app/pages/loginModel/loginComponents.dart';
import 'package:scet_app/routers/router_animation/router_animate.dart';
import 'package:scet_app/utils/api/Api.dart';
import 'package:scet_app/utils/api/Request.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';
import 'package:scet_app/utils/tool/storage/data_storageKey.dart';
import 'package:scet_app/utils/tool/storage/storage.dart';
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String _userName = ''; //账号

  String _password = ''; //密码

  int _PopTrue = 1;//记录返回次数 为3就是退出app
  ///监听返回
  Future<bool> _onWillPop() {
    _PopTrue = _PopTrue+1;
    ToastWidget.showToastMsg('再按一次退出园区预警');
    if(_PopTrue == 3 ) { pop(); }
    return Future.delayed(Duration(seconds: 2), () {
      _PopTrue = 1;
      setState(() {});
      return;
    });
  }

  static Future<void> pop() async {
    await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }
  ///登录
  void _postLogin(String userName, String passWord) async {
    if(userName.isEmpty) {
      ToastWidget.showToastMsg('请输入您的登录账号！');
    } else if(passWord.isEmpty){
      ToastWidget.showToastMsg('请输入您的登录密码！');
    } else if(userName.isNotEmpty && passWord.isNotEmpty) {
      Map<String, String> _data = {
        'name':userName,
        'password':passWord,
      };
      var response = await Request().post(Api.url['login'], data: _data);
      if(response['code'] == 200) {
        saveInfo(response['data']['token'], _data['name'],_data['password']);
        Navigator.of(context).pushAndRemoveUntil(
            CustomRoute(HomePage()),
                (router) => router == null);

      }else if( response['code'] == 500) {
        ToastWidget.showToastMsg('${response['status']}！');
      }
    }
  }
  ///  缓存token
  void saveInfo(token, userName,passWord){
    StorageUtil().setString(StorageKey.Token, token.toString());
    StorageUtil().setString('userName', userName.toString());
    StorageUtil().setString('password', passWord.toString());
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
        backgroundColor: Colors.white,
          body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              },
            child: SingleChildScrollView(
              child: Container(
                child: Stack(
                  children: [
                    _topLogos(),
                    _loginInput()
                  ],
                ),
              ),
            ),
          )
      )
    );
  }
  ///顶部背景logo
  Widget _topLogos() {
    return Container(
      height: px(518),
      padding: EdgeInsets.only(left: px(60)),
      alignment: Alignment.bottomLeft,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/login/bgImage.png'),
              fit: BoxFit.fill)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Image.asset(
            'assets/images/login/logos.png',
            width: px(120),
            height: px(121),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: px(23),
              bottom: px(124),
            ),
            child: Text(
              '欢迎登录预警系统',
              style: TextStyle(
                  fontSize: sp(30),
                  fontFamily: "B",
                  color: Color(0xFFFFFFFF)
              ),
            ),
          )
        ],
      ),
    );
  }

  ///登录框
  Widget _loginInput() {
    return Positioned(
      child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: px(438)),
          padding: EdgeInsets.only(top: px(200)),
          // alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(px(46),),
              topRight: Radius.circular(px(46),),
            ),
            color: Colors.white,
          ),
          child: Column(
            children: [
              LoginComponents.loginInput(
                icon: 'assets/icon/login/people.png',
                hitStr: '请输入账号',
                onChange: (val){
                  _userName = val;
                  setState(() {});
                }
              ),
              LoginComponents.loginInput(
                  icon: 'assets/icon/login/password.png',
                  hitStr: '请输入密码',
                  isPassWord: true,
                  onChange: (val){
                    _password = val;
                    setState(() {});
                  }
              ),
              LoginComponents.loginBtn(
                onTap: (){
                  _postLogin(_userName,_password);
                },
              )
            ],
          )
      ),
    );
  }
}
