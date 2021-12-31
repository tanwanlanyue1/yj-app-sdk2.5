import 'package:flutter/material.dart';
import 'package:cs_app/utils/screen/screen.dart';

class WidgetCheck {

  static TextStyle nameStyle = TextStyle(fontSize: sp(30), fontWeight: FontWeight.w600,fontFamily: 'Alibaba-PuHuiTi-M, Alibaba-PuHuiTi');

  static Widget rowItem({bool alignStart = false, required bool padding, bool expanded = true,required String title, required Widget child}) {
    return Padding(
      padding: padding ? EdgeInsets.symmetric(vertical: px(24.0)) : EdgeInsets.zero,
      child: Row(
        crossAxisAlignment: alignStart ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: px(145.0),
            child: Text(
              '$title：',
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: Color(0XFF787A80),
                fontSize: sp(28.0),
                fontWeight: FontWeight.w500
              )
            )
          ),
          expanded ? Expanded(child: child) : child
        ]
      )
    );
  }

  static Widget fromCard({required Widget child,Function? close}) {
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

  static Widget inputWidget({bool? disabled, String? hintText, Function? onChanged}) {
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
        onChanged: (val){
          onChanged?.call(val);
        },
      style: TextStyle(
          color: Color(0XFF2E2F33),
          fontSize: sp(28.0),
      )
    );
  }

  static Widget selectWidget({String? hintText, required List items,  String? value, Function? onChanged}) {
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
        onChanged: (val){
          onChanged?.call(val);
        },
        value: value,
        iconSize: sp(40.0),
        elevation: 10,
      ),
    );
  }

  static Widget textAreaWidget({String? hintText, Function? onChanged}) {
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
      onChanged: (val){
        onChanged?.call(val);
      },
    );
  }
}