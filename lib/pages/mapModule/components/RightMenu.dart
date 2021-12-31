import 'package:flutter/material.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';

class RightMenu extends StatefulWidget {
  final bool commonMapType;
  final String layerType;
  final Function layerData;
  final Function mapType;
  RightMenu({required this.commonMapType, required this.layerType, required this.layerData, required this.mapType});


  @override
  _RightMenuState createState() => _RightMenuState();
}

class _RightMenuState extends State<RightMenu> {

  List _mapTheme = [
    {
      'title': '标准地图', 
      'icon': 'assets/images/home/standard_map.png'
    },
    {
      'title': '卫星地图', 
      'icon': 'assets/images/home/satellite_map.png'
    }
  ];

  List _stationLayer = [
    {
      'title': '监测站点', 
      'type': 'station',
      'icon': 'assets/images/RightMenu/sites.png',
      'unIcon':'assets/images/RightMenu/unsites.png',
    },
    {
      'title': '企业信息', 
      'type': 'enterprise',
      'icon': 'assets/images/RightMenu/enterprises.png',
      'unIcon':'assets/images/RightMenu/unenterprises.png',
    }
  ];

  List _otherList = [
    {
      "title": "风险物质",
      'type': 'enterprise',
      "icon": "assets/images/RightMenu/danger.png",
    },
    {
      "title": "敏感点位",
      'type': 'enterprise',
      "icon": "assets/images/RightMenu/air.png",
    },
    {
      "title": "废气排口",
      'type': 'enterprise',
      "icon": "assets/images/RightMenu/flue.png",
    },
    {
      "title": "废水排口",
      'type': 'enterprise',
      "icon": "assets/images/RightMenu/effluent.png",
    },
  ]; // 生成其他的列表

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.expand(
        width: px(504),
      ),
      child: Material(
        child: Container(
          padding: appTop(context),
          color: Color(0Xfff5f5f5),
          child: Column(
            children: [
              _title('主题'),
              _checkMap(),
              _title('站点图层'),
              _station(),
              _title('其他'),
              Expanded(
                child: _others(),
              )
            ],
          ),
        ),
      ),
    );
  }

  ///每栏标题
  Widget _title(String title) {
    return Container(
      width: px(504),
      height: px(60),
      padding: EdgeInsets.only(left: px(24)),
      alignment: Alignment.centerLeft,
      child: Text(
        '$title',
        style: TextStyle(fontSize: sp(28)),
      ),
    );
  }

  ///主题
  Widget _checkMap() {
    return Container(
      padding: EdgeInsets.only(left: px(36)),
      height: px(150),
      color: Colors.white,
      child: Row(
      children: _mapTheme.asMap().keys.map((index) {
        var data = _mapTheme[index];
        bool state = index == 0 ? widget.commonMapType : !widget.commonMapType;
        return Container(
          margin: EdgeInsets.only(right: px(32)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                child: Stack(
                  children: [
                    Container(
                      width: px(110),
                      height: px(84),
                      decoration: ShapeDecoration(
                        image: DecorationImage(
                          image: AssetImage('${data['icon']}'),
                          fit: BoxFit.cover
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusDirectional.circular(px(6.0))
                        )
                      ),
                    ),
                    Visibility(
                      visible: state,
                      child: Container(
                        width: px(110),
                        height: px(84),
                        child: Image.asset('assets/images/RightMenu/check.png'),
                      )
                    ),
                  ],
                ),
                onTap: () {
                  bool commonMapType = index == 0 ? true : false;
                  widget.mapType(commonMapType);
                },
              ),
              Padding(
                padding: EdgeInsets.only(top: px(8.0)),
                child: Text(
                  '${data['title']}',
                  style: TextStyle(
                    fontSize: sp(24),
                    color: state ? Color(0xff0066FF) : Color(0xff2E3033)
                  ),
                ),
              )
            ],
          ),
        );
      }).toList()
    ));
  }

  ///站点图层
  Widget _station() {
    return Container(
      height: px(208),
      padding: EdgeInsets.fromLTRB(px(36), px(20.0),px(24), px(20.0)),
      color: Color(0XFFFFFFFF),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: _stationLayer.asMap().keys.map((index) {
          var data = _stationLayer[index];
          bool state = _stationLayer[index]['type'] == widget.layerType;
          return Container(
            margin: EdgeInsets.only(right:px(76) ),
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                    child:Visibility(
                        visible: state,
                        child: Container(
                          width: px(96),
                          height: px(96),
                          child: Image.asset(
                            _stationLayer[index]['icon'],
                            width: px(50),
                            height: px(26),
                          ),
                        ),
                        replacement: Image.asset(
                          _stationLayer[index]['unIcon'],
                          width: px(96),
                          height: px(96),
                        )
                    ),
                    onTap: (){
                      widget.layerData(_stationLayer[index]['type']);
                    }
                ),
                Text(
                  '${_stationLayer[index]['title']}',
                  style: TextStyle(fontSize: sp(24)),
                )
              ],
            ),
          );
        }).toList()
      ));
  }

  ///统一图标样式
  Widget _icons(String icon) {
    return Container(
      width: px(48),
      height: px(48),
      child: Image.asset(icon),
    );
  }

  ///其他
  Widget _others() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: px(36), right: px(24)),
      child: Column(
        children: _otherList.asMap().keys.map((index) => GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/LayerPage',arguments: {'index': index});
          },
          child: Container(
            height: px(48),
            color: Colors.transparent,
            margin: EdgeInsets.only(top: px(32)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _icons('${_otherList[index]['icon']}'),
                Padding(
                  padding: EdgeInsets.only(left: px(12)),
                  child: Text(
                    '${_otherList[index]['title']}',
                    style: TextStyle(fontSize: sp(24),color: Color(0xff2E3033)),
                  ),
                ),
                Spacer(),
                Image.asset(
                  'assets/images/RightMenu/other.png',
                  width: px(24),
                ),
              ],
            ),
          ),
        )).toList(),
      ),
    );
  }
}
