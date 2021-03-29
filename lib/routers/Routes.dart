import 'package:flutter/material.dart';
import 'package:scet_app/pages/AddModule/AbnormalComplaints.dart';
import 'package:scet_app/pages/AddModule/AddMaintenance.dart';
import 'package:scet_app/pages/AddModule/AddPolling.dart';
import 'package:scet_app/pages/AddModule/InspectTask.dart';
import 'package:scet_app/pages/AddModule/MonitorTask.dart';
import 'package:scet_app/pages/AlarmModule/AlarmHandleProcess.dart';
import 'package:scet_app/pages/AlarmModule/IndustryCenter.dart';
import 'package:scet_app/pages/HomePage.dart';
import 'package:scet_app/pages/UserModule/MyIssue/myAbnormalComplaints.dart';
import 'package:scet_app/pages/UserModule/MyIssue/myIndustryEvent.dart';
import 'package:scet_app/pages/UserModule/MyIssue/myInspectionTasks.dart';
import 'package:scet_app/pages/UserModule/MyIssue/myMaintenanceTask.dart';
import 'package:scet_app/pages/dataModule/StationDetails.dart';
import 'package:scet_app/pages/dataModule/components/PDFView.dart';
import 'package:scet_app/pages/loginModel/guidePage.dart';
import 'package:scet_app/pages/loginModel/loginPage.dart';
import 'package:scet_app/pages/mapModule/Layer/layerPage.dart';
import 'package:scet_app/pages/dataModule/Report.dart';
import 'package:scet_app/pages/dataModule/MonitorStation.dart';
import 'package:scet_app/pages/userModule/Mybacklog/MyBacklog.dart';
import 'package:scet_app/pages/userModule/Mybacklog/TestTaskDetails.dart';
import 'package:scet_app/utils/tool/dev/devPage.dart';

///配置静态路由
final routes = {
  '/': (context) => GuidePage(), //引导页
  '/LoginPage': (context) => LoginPage(), //登录页
  '/HomePage': (context) => HomePage(), //首页
  '/TestPage': (context) => DevPage(), //测试页面
  "/LayerPage": (context, {arguments}) => LayerPage(arguments: arguments), //其他图层

  '/task/inspect': (context) => InspectTask(), //核查任务
  '/task/monitor': (context) => MonitorTask(), //监测任务
  '/add/xunjian': (context) => AddMaintenance(), //添加巡检
  '/add/jianxiu': (context) => AddPolling(), //添加检修
  '/add/complaints': (context) => AbnormalComplaints(), //异常投诉

  "/alarm/industryCenter": (context) => IndustryCenter(), //警情中心
  '/alarm/handleProcess': (context, {arguments}) => AlarmHandleProcess(data: arguments), //警情处理流程

  '/data/station': (context) => MonitorStation(), //监测站点
  '/data/report': (context) => Report(), //数据报告
  '/data/report/details': (context, {arguments}) => PDFView(pathPDF: arguments), //数据报告pdf
  '/TestTaskDetails':(context) => TestTaskDetails(),//监测任务详情
  '/MyBacklog':(context,)=>MyBacklog(),//我的待办
  '/StationDetails':(context,{arguments})=>StationDetails(arguments:arguments),//站点详情

  '/MyMaintenanceTask':(context,{arguments})=>MyMaintenanceTask(),//我发布的：检修任务
  '/MyInspectionTasks':(context,{arguments})=>MyInspectionTasks(),//我发布的：巡检任务
  '/MyIndustryEvent':(context,{arguments})=>MyIndustryEvent(),//我发布的：警情事件
  '/MyAbnormalComplaints':(context,{arguments})=>MyAbnormalComplaints(),//我发布的：异常投诉

  // "/productsPage":(context,{arguments})=>ProductsPage(arguments:arguments),//路由传值
};

///使用
// Navigator.pushNamed(context, '/productsPage',arguments: val);

/// 统一处理
var onGenerateRoute = (RouteSettings settings) {
  final String name = settings.name;
  final Function pageContentBuilder = routes[name];
  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      final Route route = MaterialPageRoute(
          builder: (context) =>
              pageContentBuilder(context, arguments: settings.arguments));
      return route;
    } else {
      final Route route = MaterialPageRoute(builder: (context) => pageContentBuilder(context));
      return route;
    }
  }
};
