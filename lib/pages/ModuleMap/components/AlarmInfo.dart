import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:scet_dz/utils/screen/screen.dart';
import 'package:scet_dz/utils/easyRefresh/easyRefreshs.dart';
import 'package:scet_dz/api/Api.dart';
import 'package:scet_dz/api/Request.dart';

class AlarmInfo extends StatefulWidget {
  final List? realAlarm;
  final int? params;
  AlarmInfo({this.realAlarm,this.params});

  @override
  _AlarmInfoState createState() => _AlarmInfoState();
}

class _AlarmInfoState extends State<AlarmInfo> {
  List realAlarm = [];
  EasyRefreshController _controller = EasyRefreshController(); // 上拉组件控制器
  bool _enableLoad = true; // 是否开启加载
  int _total = 10;
  int _pageNo = 2;

  //获取警情
  void _getRealTimeAlarm({typeStatus? type}) async{
    Map<String, dynamic> params = Map();
    params['type'] = 'realTime';
    params['pageNo'] = _pageNo;
    params['pageSize'] = 10;
    var response = await Request().get(Api.url['table'], data: params);
    if(response['code'] == 200) {
      _pageNo++;
      List data = response['data']["data"];
      if (mounted) {
        if(type == typeStatus.onRefresh) {
          // 下拉刷新
          refreshPage(data);
        }else if(type == typeStatus.onLoad) {
          // 上拉加载
          _onLoad(data);
        }
      }
      setState(() {});
    }
  }
  //刷新页面
  void refreshPage(List data) {
    realAlarm = data;
    _enableLoad = true;
    _controller.resetLoadState();
    _controller.finishRefresh();
    if(realAlarm.length >= _total){
      _controller.finishLoad(noMore: true);
    }
    setState(() {});
  }
  // 上拉加载
  _onLoad(List data) {
    realAlarm.addAll(data);
    _controller.finishLoadCallBack!();
    if(realAlarm.length >= _total){
      _controller.finishLoad(noMore: true);
      _enableLoad = false;
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    realAlarm = widget.realAlarm ?? [];
    _total = widget.params ?? 0;
    if(realAlarm.length>=_total){
      _enableLoad = false;
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
      child: Container(
        color: Colors.white,
        height: px(200.0),
        width: px(500.0),
        child: EasyRefresh(
            enableControlFinishRefresh: true,
            enableControlFinishLoad: true,
            topBouncing: true,
            controller: _controller,
            taskIndependence: false,
            header: headers(),
            footer: footers(),
            onRefresh: () async{
              _pageNo = 1;
              _getRealTimeAlarm(type: typeStatus.onRefresh,);
            },
            onLoad:  _enableLoad ? () async {
              _getRealTimeAlarm(type: typeStatus.onLoad);
            } : null,
            child: realAlarm.length > 0
                ?
            ListView(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: px(10.0)),
                    child: Text(
                      '───告警消息───',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: sp(28.0),
                          color: Colors.black87
                      ),
                    ),
                  ),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: realAlarm.map((item) {
                        return InkWell(
                            onTap: () {},
                            child: Container(
                                padding: EdgeInsets.symmetric(vertical: px(5.0)),
                                child: Text.rich(
                                  TextSpan(text: '${item['stName']}：',
                                    style: TextStyle(
                                        fontSize: sp(24.0),
                                        color: Color(0XFF999999)
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(text: '${item['facName']} ${item['value']}${item['unit']}',
                                          style: TextStyle(
                                              color: Color(0XFF000000),
                                              fontSize:sp(24.0),
                                              fontWeight: FontWeight.w400)
                                      )
                                    ],
                                  ),
                                )
                            )
                        );
                      }).toList()
                  ),
                ]
            ):
            Center(
              child: Text(
                  '暂无告警消息！',
                  style: TextStyle(
                      fontSize: sp(24.0),
                      color: Color(0XFF000000)
                  )
              ),
            )
        ),

      ),
    );
  }
}
