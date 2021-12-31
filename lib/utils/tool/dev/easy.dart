import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';

/// 基本示例(经典样式)页面
class BasicPage extends StatefulWidget {
  @override
  _BasicPageState createState() => _BasicPageState();
}

class _BasicPageState extends State<BasicPage> {
  late EasyRefreshController _controller;
  late ScrollController _scrollController;

  // 条目总数
  int _count = 20;
  // 反向
  bool _reverse = false;
  // 方向
  Axis _direction = Axis.vertical;
  // Header浮动
  bool _headerFloat = true;
  // 无限加载
  bool _enableInfiniteLoad = true;
  // 控制结束
  bool _enableControlFinish = false;
  // 任务独立
  bool _taskIndependence = false;
  // 震动
  bool _vibration = true;
  // 是否开启刷新
  bool _enableRefresh = true;
  // 是否开启加载
  bool _enableLoad = true;
  // 顶部回弹
  bool _topBouncing = true;
  // 底部回弹
  bool _bottomBouncing = true;

  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          height: _direction == Axis.vertical ? double.infinity : 210.0,
          child: EasyRefresh.custom(
            enableControlFinishRefresh: true,
            enableControlFinishLoad: true,
            taskIndependence: _taskIndependence,
            controller: _controller,
            scrollController: _scrollController,
            reverse: _reverse,
            scrollDirection: _direction,
            topBouncing: _topBouncing,
            bottomBouncing: _bottomBouncing,
            header: _enableRefresh
                ? ClassicalHeader(
              enableInfiniteRefresh: false,
              bgColor:
              _headerFloat ? Theme.of(context).primaryColor : Colors.transparent,
              infoColor: _headerFloat ? Colors.black87 : Colors.teal,
              float: _headerFloat,
              enableHapticFeedback: _vibration,
              refreshText: "拉动刷新",
              refreshReadyText: "释放刷新",
              refreshingText:  "刷新完成",
              refreshedText: "刷新完成",
              refreshFailedText: "刷新失败",
              noMoreText: "没有更多数据",
              infoText: "更新于 %T",
            )
                : null,
            footer: _enableLoad
                ? ClassicalFooter(
              enableInfiniteLoad: _enableInfiniteLoad,
              enableHapticFeedback: _vibration,
              loadText: '拉动加载',
              loadReadyText: "释放加载",
              loadingText: "正在加载...",
              loadedText: "加载完成",
              loadFailedText: "加载失败",
              noMoreText: "没有更多数据",
              infoText: "更新于 %T",
            )
                : null,
            onRefresh: _enableRefresh
                ? () async {
              await Future.delayed(Duration(seconds: 2), () {
                if (mounted == true) {
                  setState(() {
                    _count = 20;
                  });
                  if (!_enableControlFinish) {
                    _controller.resetLoadState();
                    _controller.finishRefresh();
                  }
                }
              });
            }
                : null,
            onLoad: _enableLoad
                ? () async {
              await Future.delayed(Duration(seconds: 2), () {
                if (mounted == true) {
                  setState(() {
                    _count += 20;
                  });
                  if (!_enableControlFinish) {
                    _controller.finishLoad(noMore: _count >= 80);
                  }
                }
              });
            }
                : null,
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return Container(
                      width: px(100),
                      height: px(100),
                      child: Text('${index}'),
                    );
                  },
                  childCount: _count,
                ),
              ),
            ],
          ),
        ),
      ),
     persistentFooterButtons: <Widget>[
       _enableControlFinish
           ? FlatButton(
               onPressed: () {
                 _controller.resetLoadState();
                 _controller.finishRefresh();
               },
               child: Text('0',
                   style: TextStyle(color: Colors.black)))
           : SizedBox(
               width: 0.0,
               height: 0.0,
             ),
       _enableControlFinish
           ? FlatButton(
               onPressed: () {
                 _controller.finishLoad(noMore: _count >= 80);
               },
               child: Text('1',
                   style: TextStyle(color: Colors.black)))
           : SizedBox(
               width: 0.0,
               height: 0.0,
             ),
       FlatButton(
           onPressed: () {
             _controller.callRefresh();
           },
           child: Text('2',
               style: TextStyle(color: Colors.black))),
       FlatButton(
           onPressed: () {
             _controller.callLoad();
           },
           child: Text('3',
               style: TextStyle(color: Colors.black))),
     ],
    );
  }
}