import 'package:flutter/material.dart';

class UserLogin extends StatefulWidget {
  @override
  _UserLoginState createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {

  final _usernameController = TextEditingController(text: 'toly1994328');
  final _passwordController = TextEditingController(text: '');
  
  bool _showPwd = false;

  void _doUserLogin() {
    print('---用户名:${_usernameController.text}------密码：${_passwordController.text}---');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(height:20,),
        buildUsernameInput(),
        Stack(
          alignment: Alignment(.8,0),
          children: [
            buildPasswordInput(),
            InkWell(
              onTap: ()=> setState(() => _showPwd = !_showPwd),
              child: Icon(_showPwd ? Icons.remove_red_eye : Icons.enhanced_encryption)
            )
          ],
        ),
        Row(
          children: <Widget>[
            Checkbox(value: true, onChanged: (e) => {}),
            Text(
              "自动登录",
              style: TextStyle(color: Color(0xff444444), fontSize: 14),
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(top: 10, left: 10, right: 10,bottom: 0),
          height: 40,
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
            ),
            onPressed: _doUserLogin,
            child: Text(
              "登   录", 
              style: TextStyle(
                color: Colors.white, 
                fontSize: 18
              )
            ),
          ),
        )
      ],
    );
  }

  Widget buildUsernameInput(){
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.withOpacity(0.5),
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(15.0),
          ),
          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                child: Icon(
                  Icons.person_outline,
                  color: Colors.grey,
                ),
              ),
              Container(
                height: 20.0,
                width: 1.0,
                color: Colors.grey.withOpacity(0.5),
                margin: const EdgeInsets.only(left: 00.0, right: 10.0),
              ),
              Expanded(
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '请输入用户名...',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget buildPasswordInput(){
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.withOpacity(0.5),
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(15.0),
          ),
          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                child: Icon(
                  Icons.lock_outline,
                  color: Colors.grey,
                ),
              ),
              Container(
                height: 30.0,
                width: 1.0,
                color: Colors.grey.withOpacity(0.5),
                margin: const EdgeInsets.only(left: 00.0, right: 10.0),
              ),
              Expanded(
                child: TextField(
                  obscureText: !_showPwd,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '请输入密码...',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}