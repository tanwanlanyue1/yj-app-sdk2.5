import 'package:flutter/material.dart';
import 'package:scet_app/components/ToastWidget.dart';
import 'package:scet_app/pages/alarmModule/components/WidgetCheck.dart';
import 'package:scet_app/utils/api/Api.dart';
import 'package:scet_app/utils/api/Request.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';

class MsdsSuggest extends StatefulWidget {
  final Map data;
  MsdsSuggest({this.data});
  @override
  _MsdsSuggestState createState() => _MsdsSuggestState();
}

class _MsdsSuggestState extends State<MsdsSuggest> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _actionAdvices();
  }

  Map _actionAdvice = {};// MSDS建议

  /// MSDS建议
  void _actionAdvices() async{
    Map<String, String> _data = Map();
    _data['code'] = widget.data['eventCode'];
    var response = await Request().get(Api.url['actionAdvice'], data: _data);
    if(response['code'] == 200 && mounted){
      _actionAdvice = response['data'][0];
      if(response['data'] == null ) {
        ToastWidget.showToastMsg('暂无数据');
        Navigator.pop(context);
      }
      setState(() { });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: px(24.0)),
      children: [
        WidgetCheck.miniTitle(
            'MSDS建议',
            icon: 'assets/icon/alarm/MsdsSuggest.png'
        ),
        _itemCard(title: '皮肤接触急救措施', data: ['${_actionAdvice['skinContact'] == null ? '': _actionAdvice['skinContact']}']),
        _itemCard(title: '眼睛接触急救措施', data: ['${_actionAdvice['eyeContact']== null ? '': _actionAdvice['eyeContact']}']),
        _itemCard(title: '吸入急救措施', data: ['${_actionAdvice['indraft']== null ? '': _actionAdvice['indraft']}']),
        _itemCard(title: '食入急救措施', data: ['${_actionAdvice['eat']== null ? '': _actionAdvice['eat']}']),
        _itemCard(title: '泄露应急处置', data: ['${_actionAdvice['emDeal']== null ? '': _actionAdvice['emDeal']}']),
      ],
    );
  }

  Widget _itemCard({String title, List data}) {
    return WidgetCheck.fromCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icon/alarm/MsdsSuggestIcon.png',
                width: px(16.0),
                height: px(22.0),
              ),
              Padding(
                padding: EdgeInsets.only(left: px(12.0)),
                child: Text(
                  '$title：',
                  style: TextStyle(
                    color: Color(0XFF2E2F33),
                    fontSize: sp(30.0),
                    fontFamily: 'M'
                  )
                )
              )
            ]
          ),
          Container(
            padding: EdgeInsets.only(left: px(26.0)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: data.map((item) {
                return Container(
                  padding: EdgeInsets.only(top: px(16.0)),
                    child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '●', 
                        style: TextStyle(
                          height: 2.2,
                          color: Color(0XFF8A8E99), 
                          fontSize: sp(10.0)
                        )
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: px(10.0)),
                          child: Text(
                            '$item',
                            style: TextStyle(
                              color: Color(0XFF45474D),
                              fontSize: sp(28.0),
                              fontWeight: FontWeight.w500
                            )
                          )
                        )
                      )
                    ],
                  ),
                );
              }).toList()
            )
          )
        ],
      )
    );
  }
}