import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:scet_app/components/LoadingDialog.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';

class AccessLocate extends StatefulWidget {
  final callback;
  final String? hintStrl;
  AccessLocate({Key? key, this.callback,this.hintStrl});
  @override
  _AccessLocateState createState() => _AccessLocateState();
}

class _AccessLocateState extends State<AccessLocate> {

  String? currentPoint;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            height: px(56.0),
            padding: EdgeInsets.symmetric(vertical: px(10.0), horizontal: px(10.0)),
            decoration: BoxDecoration(
              color: Color(0xffF5F6FA),
              borderRadius: BorderRadius.circular(px(4.0)),
            ),
            child: currentPoint == null ? 
              Text(
                '${widget.hintStrl == null || widget.hintStrl == ''
                    ? '请拾取经纬度坐标'
                    : widget.hintStrl}',
                style: TextStyle(
                  fontSize: sp(28.0),
                  color: Color(0XFFA8ABB3)
                )
              ) 
            : 
              Text(
                '$currentPoint', 
                style: TextStyle(
                  fontSize: sp(26.0),
                  color: Color(0XFF585858)
                ),
                overflow: TextOverflow.ellipsis,
              )
          )
        ),
        Container(
          width: px(120.0),
          height: px(56.0),
          margin: EdgeInsets.only(left: px(24.0)),
          decoration: BoxDecoration(
            color: Color(0XFF4D7CFF),
            borderRadius: BorderRadius.circular(px(4.0)),
          ),
          child: GestureDetector(
            onTap:()  {
              showDialog(
                context: context,
                builder: (context) {
                return LoadingDialog(text: '获取当前定位中');
              });
              Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((position){
                String point = "${position.longitude}, ${position.latitude}";
                widget.callback(position.longitude, position.latitude);
                setState(() {
                  currentPoint = point;
                });
                Navigator.pop(context);
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icon/map/locate.png',
                  width: px(29.0),
                  height: px(32.0),
                ),
                Padding(
                  padding: EdgeInsets.only(left: px(12.0)),
                  child: Text(
                    '定位',
                    style: TextStyle(
                      color:Color(0XFFFFFFFF), 
                      fontSize: sp(24.0),
                      fontWeight: FontWeight.w500
                    )
                  ),
                )
              ]
            ),
          )
        )
      ]
    );
  }
}