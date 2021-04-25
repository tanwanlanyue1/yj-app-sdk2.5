import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scet_app/components/DownInput.dart';
import 'package:scet_app/components/DialogPages.dart';
import 'package:scet_app/components/CasingPly.dart';
import 'package:scet_app/pages/mapModule/components/BotttomDrag.dart';
import 'package:scet_app/utils/api/Api.dart';
import 'package:scet_app/utils/api/Request.dart';
import 'package:scet_app/utils/tool/dev/SeletInputs.dart';
import 'package:scet_app/utils/tool/dev/pageView.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';
import 'package:scet_app/utils/tool/storage/data_storageKey.dart';
import 'package:scet_app/utils/tool/storage/storage.dart';

//测试工程
class DevPage extends StatefulWidget {
  @override
  _DevPageState createState() => _DevPageState();
}

class _DevPageState extends State<DevPage> {
  Map respone = {'测试':'dio点击开始获取数据'};
  onChangeds(val){
    print('==>选中$val');
  }
  List _data = [
    {
      'id': 1,
      'name':'李国庆1',
      'gender': '男',
      'unit': '沧州临港经济技术开发区',
      'position': '副主任',
      'phone': 13503270271,
      'class': '领导层',
      'parkId': '40300083-16d1-408a-90b7-2cc35a65cc2c'
    },
    {
      'id': 1,
      'name':'李国庆2',
      'gender': '男',
      'unit': '沧州临港经济技术开发区',
      'position': '副主任',
      'phone': 13503270271,
      'class': '领导层',
      'parkId': '40300083-16d1-408a-90b7-2cc35a65cc2c'
    },
  ];

  List<int> _li = [22,55,66,88];

  List list = [];
  Map item = {'a':'','b':''};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    list.add(item);
  }

  Future myDialog(context){
    return showDialog<Null>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return GestureDetector(							// 手势处理事件
            onTap: (){
              Navigator.of(context).pop();				//退出弹出框
            },
            child: Container(								//弹出框的具体事件
              child: Material(
                color: Color.fromRGBO(0, 0, 0, 0.5),
                child: Center(
                  child: Container(
                    width: px(540),
                    height: px(625),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/home/bgImage.png'),
                        fit: BoxFit.fill
                      )
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: px(20)
                                ),
                                child: Text(
                                  '发布成功',
                                  style: TextStyle(
                                      fontSize: sp(32),
                                      fontFamily: "M",
                                      color: Color(0xFF2E2F33)
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  bottom: px(40)
                                ),
                                child: Text(
                                  '前往“我发布的”查看详情',
                                  style: TextStyle(
                                      fontSize: sp(22),
                                      fontFamily: "M",
                                      color: Color(0xFFA8ABB3)
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    child: Container(
                                      width: px(270),
                                      height: px(86),
                                      alignment: Alignment.center,
                                      color: Color(0xFF8F98B3),
                                      child: Text(
                                        '返回首页',
                                        style:TextStyle(
                                            fontSize: sp(30),
                                          color: Color(0xFFFFFFFF)
                                        ) ,
                                      ),
                                    ),
                                    onTap: (){

                                    },
                                  ),
                                  InkWell(
                                    child: Container(
                                      width: px(270),
                                      height: px(86),
                                      alignment: Alignment.center,
                                      color: Color(0xFF4D7CFF),
                                      child: Text(
                                        '立即查看',
                                        style:TextStyle(
                                            fontSize: sp(30),
                                            color: Color(0xFFFFFFFF)
                                        ) ,
                                      ),
                                    ),
                                    onTap: (){},
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
        );

      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, //输入框抵住键盘 内容不随键盘滚动
      appBar: AppBar(
        title: Text('测试页面'),
      ),
      backgroundColor: Colors.white,
      body: BottomDragWidget(
          // key:childKey,
          body:Container(
              // color: Colors.brown,
              width: px(750),
              height: px(1334),
              // padding: EdgeInsets.all(30),
              child: ListView(
                children: [
                  DownInput(
                    data: [
                      {'name':'測試1', 'value': 1},
                      {'name':'測試12', 'value': 2},
                      {'name':'測試123', 'value': 3},
                      {'name':'測試1234', 'value': 4},
                      {'name':'測試12345', 'value': 5},
                    ],
                    callback: (value)=>onChangeds(value),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () async{
                      StorageUtil().setString('token', 'U2FsdGVkX1+QriixONYQqwOueGChjuoQVtxsxJoUGY0=');
                      respone = await Request().get(
                          Api.url['realStationInfo']
                      );
                      setState(() {});
                    },
                    child: Text('${respone.toString()}'),
                  ),
                  InkWell(
                    onTap: () async{
                      DialogPages.succeedDialog(context);
                    },
                    child: Text('立即发布'),
                  ),
                  InkWell(
                    onTap: () async{
                      StorageUtil().remove(StorageKey.Token);
                      print('删除StorageKey.Token成功');
                      setState(() {});
                    },
                    child: Text('删除缓存token'),
                  ),
                  InkWell(
                    onTap: () async{
                      StorageUtil().remove(StorageKey.RealStationInfo);
                      print('删除StorageKey.RealStationInfo成功');
                      setState(() {});
                    },
                    child: Text('删除缓存站点'),
                  ),
                  InkWell(
                    onTap: () async{
                      StorageUtil().setString('ceshi', json.encode(_li));
                      // myDialog(context);
                      print('缓存成功');
                      DialogPages.succeedDialog(
                        context,
                        title: '缓存成功',
                        back: (){
                          Navigator.pop(context);
                        }
                      );
                      setState(() {});
                    },
                    child: Text('缓存测试'),
                  ),
                  InkWell(
                    onTap: () async{
                      List<int> liInt;
                      var li =  json.decode(StorageUtil().getString('ceshi'));
                      liInt =  List<int>.from(li);
                      print(liInt);
                      setState(() {});
                    },
                    child: Text('读取缓存测试'),
                  ),
                  Column(
                    children: _data.asMap().keys.map((i) {
                      return test1(data: _data,);
                    }).toList()
                  ),
                  InkWell(
                    child: Text('刷新其中一项'),
                    onTap: (){
                      list[0]['a']='浅拷贝了你   ';
                      setState(() {});
                    },
                  ),
                  Column(
                      children: list.asMap().keys.map((i) {
                        return Row(
                          children: [
                            Text('a:'),
                            Text('${list[i]['a']}'),
                            Text('b:'),
                            Text('${list[i]['b']}'),
                          ],
                        );
                      }).toList()
                  ),
                  InkWell(
                    child: Text('添加一个空对象'),
                    onTap: (){
                      list.add(item);
                      setState(() {});
                    },
                  ),
                  Container(
                    height: px(500),
                    child: MyHomePage(),
                  ),
                  Skeleton(),
                  CasingPly.casingPly1(length: 1),
                  CasingPly.casingPly2(length: 1),
                  CasingPly.casingPly3(length: 1),
                  CasingPly.casingPly4(length: 2),
                ],
              )
          ),
          dragContainer: DragContainer(
            drawer: getListView(),
            defaultShowHeight: px(113),
            height: px(1172),
          )),
    );
  }

  Widget getListView() {
    return Container(
      ///总高度
      color: Colors.amberAccent,
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.deepOrangeAccent,
            height: px(32),
          ),
          Container(
            color: Colors.cyan,
            height: px(60),
          ),
          Expanded(child: newListView())
        ],
      ),
    );
  }

  Widget newListView() {
    return OverscrollNotificationWidget(
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Text('data=$index');
        },
        itemCount: 100,
        physics: const ClampingScrollPhysics(),
      ),
      // scrollListener: _scrollListener,
    );
  }
}

class test1 extends StatefulWidget {
  final List data;
  test1({this.data});
  @override
  _test1State createState() => _test1State();
}

class _test1State extends State<test1> {
  GlobalKey _globalKey= GlobalKey();
  Map da = {'name':' 模拟下拉测试数据 '};
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async{
        print('---$da');
        SelectInput.showProgress(
            context,
            key: _globalKey,
            data: widget.data,
            currentData: da,
            more: false,
            onTabs: (val){
              da = val;
              print('--1-$da');
              setState(() {});
              // print('---$val');

            }
        );
        setState(() {});
      },
      child: Text(da == null ? ' 1 ':da['name'],
        key:_globalKey
      ),
    );
  }
}

class Skeleton extends StatefulWidget {
  final double height;
  final double width;

  Skeleton({Key key, this.height = 20, this.width = 200 }) : super(key: key);

  createState() => SkeletonState();
}

class SkeletonState extends State<Skeleton> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  Animation gradientPosition;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: Duration(milliseconds: 1500), vsync: this);

    gradientPosition = Tween<double>(
      begin: -3,
      end: 10,
    ).animate(
      CurvedAnimation(
          parent: _controller,
          curve: Curves.linear
      ),
    )..addListener(() {
     if(mounted) setState(() {});
    });

    _controller.repeat();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width:  widget.width,
      height: widget.height,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment(gradientPosition.value, 0),
              end: Alignment(-1, 0),
              colors: [Colors.black12, Colors.black26, Colors.black12]
          )
      ),
    );
  }
}