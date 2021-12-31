import 'package:flutter/material.dart';
import 'package:scet_dz/pages/ModuleMap/components/MapWidget.dart';
import 'package:scet_dz/utils/screen/screen.dart';

class MonitorDevice extends StatefulWidget {
  @override
  _MonitorDeviceState createState() => _MonitorDeviceState();
}

class _MonitorDeviceState extends State<MonitorDevice> {

  bool _backPark = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MapWidget(
            commonMapType: false,
            backPark: _backPark,
            layerType: 'monitorDevice'
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