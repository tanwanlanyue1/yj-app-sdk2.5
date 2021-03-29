import 'package:flutter/material.dart';
import 'package:scet_app/pages/mapModule/components/MapWidget.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';

class Sensitive extends StatefulWidget {
  @override
  _SensitiveState createState() => _SensitiveState();
}

class _SensitiveState extends State<Sensitive> {

 bool _backPark = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MapWidget(
            commonMapType: false,
            backPark: _backPark,
            layerType: 'sensitive'
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
      bottom: px(48),
      child: GestureDetector(
        onTap: () {
          this.setState(() {
            _backPark = !_backPark;
          });
        },
        child: Container(
          width: px(74),
          height: px(74),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(px(37))
          ),
          child: Image.asset('assets/icon/map/locations.png')
        ),
      )
    );
  }
}