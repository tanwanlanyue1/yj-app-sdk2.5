import 'package:flutter/material.dart';
import 'package:scet_app/pages/userModule/components/UserComponents.dart';
import 'package:scet_app/pages/userModule/components/indicator.dart';
import 'package:scet_app/utils/tool/myPainter/MyPainter.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';
class UserCenter extends StatefulWidget {
  @override
  _UserCenterState createState() => _UserCenterState();
}
class _UserCenterState extends State<UserCenter> {

  Map _releaseItem = {
    'page1':[
      {'title':'警情事件','icon':'assets/icon/user/alert.png','path':'/MyIndustryEvent',},
      {'title':'异常投诉','icon':'assets/icon/user/abnormal.png','path':'/MyAbnormalComplaints',},
      {'title':'核查任务','icon':'assets/icon/user/inspect.png','path':'/task/inspect',},
      {'title':'监测任务','icon':'assets/icon/user/monitor.png','path':'/task/monitor',},
    ],
    'page2':[
      {'title':'巡检任务','icon':'assets/icon/user/service.png','path':'/MyInspectionTasks',},
      {'title':'检修任务','icon':'assets/icon/user/polling.png','path':'/MyMaintenanceTask',},
    ],
  };

  final _controller = new PageController();

  int _nowIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F4FA),
      body: Stack(
        children: [
          CustomPaint(painter: MyPainter(),),
          _topBody()
        ],
      )
    );
  }
  ///内容区域
  Widget _topBody(){
    return Container(
      padding: EdgeInsets.only(
        left:px(24),
        right: px(24),
        top: appTopPadding(context)+px(24)
      ),
      child: Column(
        children: [
          _setting(),
          _header(),
          _jop(),
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  _release(),
                  _backlog(),
                  _report()
                ],
              ),
            )
          )
        ],
      ),
    );
  }

  ///设置按钮
  Widget _setting(){
    return Container(
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/TestPage',);
        },
        child: Image.asset('assets/images/user/setting.png',
          width: px(30),
          height: px(30),
        ),
      ),
      alignment: Alignment.centerRight,
    );
  }
  ///头部
  Widget _header(){
    return Container(
      height: px(100),
      width: double.infinity,
      margin: EdgeInsets.only(bottom:px(24)),
      child: Row(
        children: [
          Container(
            width: px(100),
            height: px(100),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius:BorderRadius.all(Radius.circular(px(150))),
              border: Border.all(width: px(2),color: Colors.white)
            ),
            child: Image.asset('assets/images/user/header.png',
              width: px(30),
              height: px(30),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: px(25)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '杨大锤',
                    style: TextStyle(
                        fontSize: sp(36),
                        color: Color(0xffFFFFFF),
                        fontFamily: "M"
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: px(10.0)),
                    child: Text('职务：技术工程师',style: TextStyle(fontSize: sp(28),color: Color(0xffFFFFFF))),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  ///工作台
  Widget _jop(){
    return UserComments.bgCard(
      children:  [
        UserComments.titles(title: '工作台',),
        Container(
          height: px(140),
          width: px(702),
          child: Row(
            children: [
              UserComments.jopItem(
                  img:'assets/images/user/warning.png',
                  title:'预警中心',
                  onTab:(){
                    Navigator.pushNamed(context, "/alarm/industryCenter");
                  }
              ),
              UserComments.jopItem(
                  img:'assets/images/user/supervise.png',
                  title:'监测站点',
                  onTab:(){
                    Navigator.pushNamed(context, "/data/station");
                  }
              ),
              UserComments.jopItem(
                  img:'assets/images/user/monitor.png',
                  title:'监察中心',
                  onTab:(){
                    print('123');
                  }
              ),
            ],
          ),
        )
      ],
    );
  }

  /// 我发布的
  Widget _release(){
    return UserComments.bgCard(
      children: [
        UserComments.titles(
          title: '我发布的',
        ),
        Container(
          height: px(200.0),
          padding: EdgeInsets.only(left: px(40.0), right: px(0.0),top: px(30.0)),
          child: Column(
            children: <Widget>[
              Container(
                height: px(130.0),
                child: PageView(
                  controller: _controller,
                  physics: AlwaysScrollableScrollPhysics(),
                  children: _pages(),
                  onPageChanged: (int index){
                    _nowIndex = index;
                    setState(() { });
                  },
                )
              ),
              Indicator(
                itemCount: _pages().length,
                controller: _controller,
                nowIndex: _nowIndex,
              )
            ],
          ),
        ),
      ],
    );
  }

  /// 我发布的两个分页
  List<Widget> _pages() {
    return <Widget>[
      new Container(
        child: Row(
          children: List<Widget>.from(
            _releaseItem['page1'].asMap().keys.map((i) {
              return UserComments.releaseItem(
                title: _releaseItem['page1'][i]['title'],
                icon: _releaseItem['page1'][i]['icon'],
                onTap:(){
                  Navigator.pushNamed(context, _releaseItem['page1'][i]['path']);
                },
              );
            }).toList()
          )
        ),
      ),
      Container(
        child: Row(
          children: List<Widget>.from(
            _releaseItem['page2'].asMap().keys.map((i) {
              return UserComments.releaseItem(
                title: _releaseItem['page2'][i]['title'],
                icon: _releaseItem['page2'][i]['icon'],
                onTap:(){
                  Navigator.pushNamed(context, _releaseItem['page2'][i]['path']);
                },
              );
            }).toList()
          )
        ),
      ),
    ];
  }

  /// 待办
  Widget _backlog(){
    return UserComments.bgCard(
      children:  [
        UserComments.titles(
          title: '我的待办',
          other: '任务列表',
          onTab: () {
            Navigator.pushNamed(context, '/MyBacklog');
          }
        ),
        Container(
          margin: EdgeInsets.only(left: px(38), right: px(26)),
          padding: EdgeInsets.only(top: px(23)),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Color(0xff0A002480)))
          ),
          child: Column(
            children: [
              UserComments.backlogRowItem(
                title: 'NH3泄露位置核查任务',
                other: '详情',
                onTab: () {}
              ),
              UserComments.backlogRowItem(
                title: 'A村最大落地浓度点监测任务',
                other: '去执行',
                onTab: () {}
              ),
              UserComments.backlogRowItem(
                title: 'NH3泄露位置核查任务',
                other: '详情',
                onTab: () {}
              ),
              UserComments.backlogRowItem(
                title: 'A村最大落地浓度点监测任务',
                other: '详情',
                onTab: () {
                  Navigator.pushNamed(context, '/TestTaskDetails');
                }
              ),
            ],
          ),
        )
      ],
    );
  }

  /// 报告
  Widget _report(){
    return UserComments.bgCard(
      children: [
        UserComments.titles(
          title: '报告',
          other: '报告列表',
          onTab: (){
            Navigator.pushNamed(context, "/data/report");
          }
        ),
      ],
    );
  }
}

