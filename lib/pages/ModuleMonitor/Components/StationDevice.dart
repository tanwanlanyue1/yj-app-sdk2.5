import 'package:scet_dz/components/NoData.dart';
import 'package:scet_dz/utils/dateUtc/dateUtc.dart';
import 'package:flutter/material.dart';
import 'package:scet_dz/utils/screen/screen.dart';


class StationDevice extends StatelessWidget {
  final int? stId;
  final List? deviceList;
  StationDevice({this.stId, this.deviceList});

  var bgColor;
  void colorSelect(int index, int state) {
    if(state == 1) {
      if(index % 2 == 0) {
        bgColor = [Color(0XFF3892F6), Color(0XFF9759EE)];  //蓝紫
      } else {
        bgColor = [Color(0XFF1C80FD), Color(0XFF01CAEE)]; // 蓝
      }
    } else {
      bgColor = [Color(0XFFFD473B), Color(0XFFFD5F50)]; //红色
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: deviceList?.isNotEmpty ?? false
        ? 
          ListView.builder(
            padding: EdgeInsets.only(top: px(20.0)),
            itemCount: deviceList!.length,
            itemBuilder: (context, index) {
              colorSelect(index, deviceList![index]['status']); //颜色选择
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(px(16.0)))
                ),  //设置圆角
                margin: EdgeInsets.fromLTRB(px(16.0), 0.0, px(16.0), 10.0),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: px(30.0), horizontal: px(16.0)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(px(16.0))),
                    gradient: LinearGradient(
                      colors: bgColor, 
                      begin: FractionalOffset(0, 1), 
                      end: FractionalOffset(1, 0)
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start, 
                    children: <Widget>[
                      Text(
                        '${deviceList![index]['name']}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: sp(28.0),
                          fontWeight: FontWeight.w600
                        )
                      ),
                      Divider( color: Colors.white), 
                      _itemDeviceData(
                        leftData: '${deviceList![index]['source']}',
                        rightData: '设备状态：${deviceList![index]['status']  == 1 ? '正常' : '停运'}'
                      ),
                      _itemDeviceData(
                        leftData: '监测设备', 
                        rightData: '出场编号：${deviceList![index]['code']}'
                      ),
                      _itemDeviceData(
                        leftData: '${dateUtc(DateTime.now().toString())}', 
                        rightData: '供应商：广东中联兴环保科技有限公司'
                      )
                    ]
                  )
                )
              );
            },
          )
        : 
          NoData(timeType: true, state: '未获取到监测设备数据！'),
      ),
    );
  }

  Widget _itemDeviceData({String? leftData, String? rightData}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex: 1, 
          child: Text(
            '${leftData ?? '-'}',
            style: TextStyle(
              color: Colors.white, 
              fontSize: sp(24.0), 
              height: 1.5
            )
          )
        ),
        Expanded(
          flex: 2, 
          child: Text(
            '$rightData',
            style: TextStyle(
              color: Colors.white, 
              fontSize: sp(24.0), 
              height: 1.5
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        ),
      ]
    );
  }
}