import 'package:flutter/material.dart';
import 'package:cs_app/pages/HomePage.dart';
import 'package:cs_app/pages/ModuleAlarm/Components/AlarmView.dart';
import 'package:cs_app/pages/ModuleInfo/Components/PDFView.dart';
import 'package:cs_app/pages/ModuleInfo/Components/UploadInspection.dart';
import 'package:cs_app/pages/ModuleMap/components/Layer/LayerPage.dart';
import 'package:cs_app/pages/ModuleMonitor/Components/UploadMaintain.dart';
import 'package:cs_app/pages/ModuleMonitor/StationDetails.dart';
import 'package:cs_app/pages/ModuleUser/UserCenter.dart';
import 'package:cs_app/pages/ModuleUser/UserLogin.dart';

// 配置静态路由
final routes = {
  '/': (context, {arguments}) => HomePage(arguments: arguments), // 首页
  '/login': (context) => UserLogin(), // 登录
  '/mine': (context) => UserCenter(), // 个人中心
  '/map/layerPage': (context, {arguments}) => LayerPage(arguments: arguments), // 其他图层
  '/alarm/dataView': (context, {arguments}) => AlarmView(data: arguments), // 警情视图
  '/report/details': (context, { arguments }) => PDFView(pathPDF: arguments), // 报告详情
  '/station/details': (context, { arguments }) => StationDetails(data: arguments), // 站点详情
  '/upload/inspection': (context) => UploadInspection(), // 站点巡检上传
  '/upload/maintain': (context, { arguments }) => UploadMaintain(arguments: arguments), // 设备检修上传
};

// 使用
// Navigator.pushNamed(context, '/productsPage',arguments: val);

// 统一处理
var onGenerateRoute = (RouteSettings settings) {
  final String? name = settings.name;
  final Function? pageContentBuilder = routes[name];
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
