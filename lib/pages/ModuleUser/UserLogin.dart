import 'package:flutter/material.dart';
import 'package:scet_dz/api/Api.dart';
import 'package:scet_dz/api/Request.dart';
import 'package:scet_dz/components/ToastWidget.dart';
import 'package:scet_dz/utils/screen/screen.dart';
import 'package:scet_dz/utils/storage/storage.dart';

class UserLogin extends StatefulWidget {
  @override
  _UserLoginState createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _userName, _passWord;

  bool _isCheck = true;

  void _forSubmitted() {
    var _form = _formKey.currentState;
    _form?.save();
    _postLogin(_userName, _passWord);
  }

  void _postLogin(String? userName, String? passWord) async {
    if(userName?.isEmpty ?? true) {
      ToastWidget.showToastMsg('请输入您的登录账号！');
    } else if(passWord?.isEmpty ?? true){
      ToastWidget.showToastMsg('请输入您的登录密码！');
    } else if((userName?.isNotEmpty ?? false) && (passWord?.isNotEmpty ?? false)) {
      Map<String, String> params = Map();
      params['name'] = userName!;
      params['password'] = passWord!;
      var response = await Request().post(Api.url['userLogin'], data: params);
      if(response['code'] == 200) {
        StorageUtil().setString('token', response['data']['token']);
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: Adapt.screenW(),
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget> [
              Image.asset(
                'lib/assets/images/login_bg.png',
                fit: BoxFit.contain,
                width: Adapt.screenW(),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.15,
                left: MediaQuery.of(context).size.width / 2 - MediaQuery.of(context).size.width * 0.86 / 2 - 5.0,
                child: Opacity(
                  opacity: 0.87,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(px(20.0)),
                    child: Container(
                      margin: EdgeInsets.all(5.0),
                      width: MediaQuery.of(context).size.width * 0.86,
                      height: MediaQuery.of(context).size.height * 0.7,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [BoxShadow(color: Color(0xFFBBDEFB), blurRadius: 1.0, spreadRadius: 2.0), ],
                        color: Color(0XFFFFFFFF),
                      ),
                      child: _userForm()
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: MediaQuery.of(context).size.height * 0.05,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    '© 广东中联兴环保科技有限公司',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: sp(32.0),
                      color: Colors.blue,
                    )
                  ),
                )
              ),
            ],
          ),
        ),
      )
    );
  }
  
  Widget _userForm() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(10.0, 30.0, 0.0, 10.0), 
                child: Text(
                  'YUJING',
                  style: TextStyle(
                    fontSize: sp(100.0), 
                    color: Colors.blue,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'STHupo'
                  )
                )
              ),
              Padding(
                padding: EdgeInsets.all(px(20.0)),
                child: TextFormField(
                  style: TextStyle(textBaseline: TextBaseline.alphabetic),
                  decoration: InputDecoration(
                    hintText: '请输入账号',
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none
                    ),
                    prefixIcon: Icon(Icons.person, size: sp(56)),
                    filled: true,
                    fillColor: Color(0xffe3f2fd),
                  ),
                  onSaved: (val) {
                    _userName = val;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(px(20.0)),
                child: TextFormField(
                  style: TextStyle(textBaseline: TextBaseline.alphabetic),
                  decoration: InputDecoration(
                    hintText: '请输入密码',
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none
                    ),
                    prefixIcon: Icon(Icons.lock, size: sp(56)),
                    filled: true,
                    fillColor: Color(0xffe3f2fd),
                  ),
                  obscureText: true, 
                  onSaved: (val) {
                    _passWord = val;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 40.0),
                child: Row(
                  children: <Widget> [
                    Checkbox(
                      value: _isCheck,
                      activeColor: Colors.blue,
                      onChanged: (bool){
                        setState(() {
                          _isCheck = bool!;
                        });
                      },
                    ),
                    Text(
                      '记住密码',
                      style: TextStyle(
                        color: Colors.blue,
                      )
                    )
                  ]
                )
              ),
            ],
          ),
          Container(
            height: px(110.0),
            width: Adapt.screenW(),
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
            margin: EdgeInsets.only(bottom: px(60.0)),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Color(0XFF2288F4)),
              ),
              onPressed: _forSubmitted,
              child: Text(
                '登录',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: sp(32.0)
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

}


