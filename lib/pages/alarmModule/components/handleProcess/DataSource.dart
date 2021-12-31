import 'package:flutter/material.dart';
import 'package:scet_app/pages/alarmModule/components/WidgetCheck.dart';
import 'package:scet_app/utils/api/Api.dart';
import 'package:scet_app/utils/api/Request.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';

class DataSource extends StatefulWidget {
  final Map data;
  final Map? traceSource;
  DataSource({
    required this.data,
    this.traceSource
  });
  @override
  _DataSourceState createState() => _DataSourceState();
}

class _DataSourceState extends State<DataSource> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  Map? _traceSource;// 溯源清单
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _traceSource = widget.traceSource;
  }
  @override
  void didUpdateWidget(DataSource oldWidget) {
    super.didUpdateWidget(oldWidget);
    _traceSource = widget.traceSource;
  }
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: px(24.0)),
      children:[
        WidgetCheck.miniTitle(
            '来源研判-溯源清单',
          icon: 'assets/icon/alarm/DataSource.png'
        ),
        if (widget.traceSource!=null)_answer(_traceSource!['answer']),
      ]
    );
  }
  Widget _answer(int answer){
    switch(answer) {
      case 1:
        return Column(
          children: answer1(),
        );
        break;

      case 2:
        return Container();
        break;

      case 3:
        return answer3();
        break;

      default:
        return Container();
        break;
    }
  }
  ///类型1
  List<Widget> answer1() {
    List<Widget> _li = [];
    for(var i = 0; i<_traceSource!['hasWeaData'].length; i++){
      var item = _traceSource!['hasWeaData'][i];
      List<String> _text = [];
      item.companys.asMap().keys.forEach((index) {
        _text.add(
          '${index + 1}. 疑似${item.companys[index].name}—'
              + '${item.companys[index].place}，距离${item.companys[index].distance}米',
        );
      });
      _li.add(_itemCard(
          title: '主导风向—${item.letter} ${item.name} 风频${item.value}',
          data: _text
      ),);
    }
    return _li;
  }

  ///类型3
  Widget answer3(){
    return _itemCard(
        title: '建议',
        data: ['${_traceSource!['allData']['advice']}']
    );
  }

  Widget _itemCard({String? title, required List data}) {
    return WidgetCheck.fromCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title：',
            style: TextStyle(
              color: Color(0XFF4D7CFF),
              fontSize: sp(30.0),
              fontFamily: 'M'
            )
          ),
          Column(
            children: data.map((item) {
              return Padding(
                padding: EdgeInsets.only(top: px(16.0)),
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '●', 
                      style: TextStyle(
                        height: 1.6,
                        color: Color(0XFF606266),
                        fontSize: sp(16.0)
                      )
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: px(10.0)),
                        child: Text(
                          '$item',
                          style: TextStyle(
                            color: Color(0XFF2E2F33),
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
        ],
      )
    );
  }
}