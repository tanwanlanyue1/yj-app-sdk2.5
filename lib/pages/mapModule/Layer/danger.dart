import 'package:flutter/material.dart';
import 'package:scet_app/pages/mapModule/components/MapWidget.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';

class Dangers extends StatefulWidget {
  @override
  _DangersState createState() => _DangersState();
}

class _DangersState extends State<Dangers> {

  bool _backPark = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MapWidget(
            commonMapType: false, 
            backPark: _backPark,
            layerType: 'riskSource'
          ),
          _locationIcons(),
          _bottomCard(),
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

  ///底部卡片
  Widget _bottomCard(){
    return Positioned(
      left: px(24),
      bottom: px(24),
      child: Container(
        width: px(702),
        height: px(156),
        padding:EdgeInsets.only(left: px(16),top: px(24),right: px(24)) ,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(px(16))
        ),
        child: _cards(),
      ),
    );
  }
  ///卡片內容
  Widget _cards(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '硫酸',
              style: TextStyle(
                fontSize: sp(34),
                fontFamily: "M",
              ),
            ),
            Container(
              width: px(48),
              height: px(34),
              color: Color(0xff4D7CFF),
              margin: EdgeInsets.only(left: px(24)),
              alignment: Alignment.center,
              child: Text('1A',style: TextStyle(fontSize: sp(24),color: Colors.white),),
            ),
            Spacer(),
            Text('查看详情',
              style: TextStyle(
                fontSize: sp(22),
                color: Color(0xff8A9099)
              ),
            ),
            Icon(Icons.keyboard_arrow_right, color: Color(0xff8A9099))
          ],
        ),
        Text(
          '纯品为无色油状液体，有刺激性气味；会造成严重皮肤灼伤和眼损伤。',
          style: TextStyle(
            fontSize: sp(24),
            color: Color(0xff45484D)
          ),
        ),
      ],
    );
  }
}