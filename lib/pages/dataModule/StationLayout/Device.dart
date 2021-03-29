import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scet_app/utils/api/Api.dart';
import 'package:scet_app/utils/api/Request.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';

class Device extends StatefulWidget {
  final int stId;
  Device({this.stId});
  @override
  _DeviceState createState() => _DeviceState();
}

class _DeviceState extends State<Device> {

  List diviceList = [];

  @override
  void initState(){
    super.initState();
    _getCurrentStationDevice(stId: widget.stId);
  }

  void _getCurrentStationDevice({int stId}) async {
    var response = await Request().get(Api.url['stationDevice']  + '/$stId');
    if(response['code'] == 200) {
      setState(() {
        diviceList = response['data'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return diviceList.length > 0 ?
      ListView.builder(
        itemCount: diviceList.length,
        padding: EdgeInsets.only(top: px(24.0)),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            width: Adapt.screenW(),
            height: px(306.0),
            margin: EdgeInsets.only(bottom: px(20.0)),
            padding: EdgeInsets.all(px(24.0)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(px(10.0))),
              image: DecorationImage(
                image: AssetImage('assets/images/station/device.png'),
                fit: BoxFit.fill,
              )
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: px(70.0),
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/images/station/device-icon.png', 
                        width: px(34.0), 
                        height: px(34.0),
                        fit: BoxFit.contain
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${diviceList[index]['name']}',
                        style: TextStyle(
                          fontSize: sp(28.0),
                          color: Color(0XFFF5F7FF),
                          fontFamily: "M"
                        )
                      ),
                    ),
                    Container(
                      width: px(100.0),
                      height: px(36.0),
                      margin: EdgeInsets.only(right: px(8.0)),
                      decoration: BoxDecoration(
                        color: Color(0XFFFFFFFF),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(px(12.0)), 
                          bottomRight: Radius.circular(px(12.0))
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${diviceList[index]['status'] == 1 ? '正常' : '停用'}', 
                          style: TextStyle(
                            color: diviceList[index]['status'] == 1 ? Color(0XFF90CC00) : Colors.red, 
                            fontSize: sp(24.0),
                          ),
                          textAlign: TextAlign.center,
                        )
                      )
                    )
                  ]
                ),
                Container(
                  margin: EdgeInsets.only(left: px(70.0), top: px(24.0)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _itemData(name: '监测设备', value: '${diviceList[index]['source']}'),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: px(12.0)),
                        child: _itemData(name: '出场编号', value: '${diviceList[index]['code']}'),
                      ),
                      _itemData(name: '供  应  商', value: '广东中联兴环保科技有限公司'),
                    ],
                  )
                ),
                Container(
                  padding: EdgeInsets.only(top: px(16.0)),
                  alignment: Alignment.bottomRight,
                  child: Text(
                    '${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())}',
                    style: TextStyle(
                      fontSize: sp(22.0),
                      color: Color(0X99F0F4FF)
                    )
                  )
                )
              ]
            )
          );
        }
      )
    : Container();
  }

  Widget _itemData({String name, String value}) {
    return Text.rich(
      TextSpan(text: '$name：',
        style: TextStyle(
          fontSize: sp(26.0),
          color: Color(0XffCCD9FF)
        ),
        children: <TextSpan>[
          TextSpan(text: '$value', 
            style: TextStyle(
              fontSize: sp(28.0),
              color: Color(0XFFFFFFFF)
            )
          )
        ],
      ),
    );
  }

}
