import 'package:flutter/material.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';

class FormCheck {

  static TextStyle nameStyle = TextStyle(fontSize: sp(30), fontWeight: FontWeight.w600,fontFamily: 'Alibaba-PuHuiTi-M, Alibaba-PuHuiTi');
  
  static Widget miniTitle(String title) {
    return Container(
      margin: EdgeInsets.fromLTRB(px(6.0), px(24.0), 0.0, px(12.0)),
      child: Text(
        '$title',
        style: TextStyle(
          fontSize: sp(34),
          fontFamily: 'M'
        )
      )
    );
  }

  static Widget fromCard({Widget child,Function close}) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(px(16.0)))
      ),
      child: Stack(
        children: [
          Container(
              width: Adapt.screenW(),
              padding: EdgeInsets.symmetric(
                horizontal: px(16.0),
                vertical: px(32.0),
              ),
              child: child
          ),
          if( close != null ) Positioned(
            right: 0.0,
            top: 0.0,
            child: InkWell(
              onTap: (){
                close();
              },
              child: Image.asset('assets/icon/other/close.png',width: px(50),height: px(34),),
            ),
          )
        ],
      )
    );
  }
  static Widget formRowItem({bool alignStart = false, bool padding, String title, Widget child}) {
    return Padding(
      padding: padding ? EdgeInsets.symmetric(vertical: px(16.0)) : EdgeInsets.zero,
      child: Row(
        crossAxisAlignment: alignStart ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: px(150.0),
            child: Text(
              '$title：',
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: Color(0XFF45474D),
                fontSize: sp(30.0),
                fontFamily: 'M',
              )
            )
          ),
          Expanded(
            child: child
          )
        ]
      )
    );
  }

  static Widget inputWidget({bool disabled, String hintText, Function onChanged}) {
    return TextFormField(
      enabled: disabled,
      decoration: InputDecoration(
        isCollapsed: true,
        hintText: '$hintText',
        hintStyle: TextStyle(
          color: Color(0XFFB0B2B8),
          fontSize: sp(28.0)
        ),
        contentPadding: EdgeInsets.all(px(10.0)),
        filled: true,
        fillColor: Color(0XffF5F6FA),
        // border: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(px(4.0)),
        //   borderSide: BorderSide(color: Colors.transparent)
        // ),
        border: InputBorder.none,

      ),
      onChanged: onChanged,
      style: TextStyle(
          color: Color(0XFF2E2F33),
          fontSize: sp(28.0),
      )
    );
  }

  static Widget selectWidget({String hintText, List items, String value, Function onChanged}) {
    TextEditingController _controller = TextEditingController();
    // return DownInput(
    //   hitStr: '测试',
    //   data: [
    //     {'title':'測試1'},
    //     {'title':'測試12'},
    //     {'title':'測試123'},
    //     {'title':'測試1234'},
    //     {'title':'測試12345'},
    //   ],
    //   callback: (value)=>onChangeds(value),
    // ),
    return Container(
      padding: EdgeInsets.only(left: px(8.0)),
      height: px(54.0),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Color(0X99A1A6B3)),
        borderRadius: BorderRadius.circular(px(4.0)),
      ),
      child:  DropdownButton(
        isExpanded: true,
        underline: Container(),
        items: items.map((item) => DropdownMenuItem(
          child: Text('${item['name']}'),
          value: '${item['value']}')
        ).toList(),
        hint: Text(
          '$hintText',
          style: TextStyle(
            color: Color(0XFFB0B2B8),
            fontSize: sp(24.0)
          )
        ),
        style: TextStyle(
          color: Color(0XFF45474D),
          fontSize: sp(28.0)
        ),
        onChanged: onChanged,
        value: value,
        iconSize: sp(40.0),
        elevation: 10,
      ),
    );
  }

  static Widget textAreaWidget({String hintText, Function onChanged}) {
    return TextFormField(
      maxLines: 4,
      autofocus: false,
      decoration: InputDecoration(
        isCollapsed: true,
        hintText: '$hintText',
        hintStyle: TextStyle(
          color: Color(0XFFA8ABB3),
          fontSize: sp(28.0)
        ),
        contentPadding: EdgeInsets.all(px(10.0)),
        filled: true,
        fillColor: Color(0X29B8BDCC),
        // border: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(px(4.0)),
        //   borderSide: BorderSide(color: Color(0X29B8BDCC))
        // ),
        border: InputBorder.none
      ),
      style: TextStyle(
        color: Color(0XFF45474D),
        fontSize: sp(28.0)
      ),
      onChanged: onChanged
    );
  }

  static Widget textData({String data}) {
    return Padding(
      padding: EdgeInsets.only(left: px(12.0)),
      child: Text(
        '$data',
        style: TextStyle(
          color: Color(0XFF2E2F33),
          fontSize: sp(28.0),
          fontWeight: FontWeight.w500
        )
      )
    );
  }
  
}