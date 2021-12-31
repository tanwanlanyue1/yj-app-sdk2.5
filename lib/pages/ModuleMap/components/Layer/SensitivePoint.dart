import 'package:flutter/material.dart';
import 'package:cs_app/pages/ModuleMap/components/MapWidget.dart';
import 'package:cs_app/utils/screen/screen.dart';

class SensitivePoint extends StatefulWidget {
  @override
  _SensitivePointState createState() => _SensitivePointState();
}

class _SensitivePointState extends State<SensitivePoint> {

 bool _backPark = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MapWidget(
            commonMapType: false,
            backPark: _backPark,
            layerType: 'sensitivePoint'
          ),
          _locationIcons(),
        ],
      ),
    );
  }
  
  // 定位图标
  Widget _locationIcons(){
    return Positioned(
      right: px(24),
      bottom: px(200),
      child: GestureDetector(
        onTap: () {
          this.setState(() {
            _backPark = !_backPark;
          });
        },
        child: ClipOval(
          child: Container(
            width: px(75.0),
            height: px(75.0),
            color: Color(0XFFFFFFFF),
            child: Icon(Icons.reply,  size: sp(40.0), color: Color(0XFF1D7DFE),)
          ),
        )
      )
    );
  }
}