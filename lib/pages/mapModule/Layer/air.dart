import 'package:flutter/material.dart';
import 'package:scet_app/pages/mapModule/components/MapWidget.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';

class Air extends StatefulWidget {
  @override
  _AirState createState() => _AirState();
}

class _AirState extends State<Air> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MapWidget(commonMapType: false,),
          _locationIcons(),
          _bottomCard(),
        ],
      ),
    );
  }
  ///定位图标
  Widget _locationIcons(){
    return Positioned(
      right: px(24),
      bottom: px(270),
      child: Container(
        width: px(74),
        height: px(74),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(px(37))
        ),
        child: Image.asset('assets/icon/map/locations.png')
      ),
    );
  }
  ///底部卡片
  Widget _bottomCard(){
    return  Positioned(
      left: px(24),
      bottom: px(24),
      child: Container(
        width: px(702),
        height: px(221),
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
              '建新子站空气质量',
              style: TextStyle(
                  fontSize: sp(34),
                  fontWeight: FontWeight.bold
              ),
            ),
            Container(
              width: px(48),
              height: px(34),
              color: Color(0xff14CC2E),
              margin: EdgeInsets.only(left: px(24)),
              alignment: Alignment.center,
              child: Text('优',style: TextStyle(fontSize: sp(24),color: Colors.white),),
            ),
            Spacer(),
            Container(
              child: Row(
                children: [
                  Text('全区排名',
                    style: TextStyle(
                        fontSize: sp(24),
                        color: Color(0xff8A9099)
                    ),
                  ),
                  Text('  6',
                    style: TextStyle(
                        fontSize: sp(24),
                        color: Color(0xff45484D)
                    ),
                  ),
                  Text('/20',
                    style: TextStyle(
                        fontSize: sp(24),
                        color: Color(0xff8A9099)
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        Text(
          '空气清新，可以外出或开窗，呼吸新鲜空气。',
          style: TextStyle(
            fontSize: sp(24),
            color: Color(0xff45484D)
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: px(10)),
          child: Row(
            children: [
              _tabTitle('今天','56'),
              _tabTitle('昨天','32'),
              _tabTitle('前天','35'),
              _tabTitle('9.17','58'),
              _tabTitle('9.16','64'),
            ],
          ),
        )
      ],
    );
  }
  ///时间轴样式
  Widget _tabTitle(String title,String str){
    return Expanded(
      child: Column(
        children: [
          Text(
              '${title}',
            style: TextStyle(
              fontSize: sp(28),
              color: Color(0xff5C6066)
            ),
          ),
          Text(
              '${str}',
            style: TextStyle(
                fontSize: sp(36),
                color: Color(0xff14CC2E)
            ),
          )
        ],
      ),
    );
  }
}
