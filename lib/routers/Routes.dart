import 'package:flutter/material.dart';
import 'package:scet_dz/pages/HomePage.dart';
import 'package:scet_dz/pages/ModuleAlarm/Components/AlarmView.dart';
import 'package:scet_dz/pages/ModuleInfo/Components/UploadInspection.dart';
import 'package:scet_dz/pages/ModuleMap/components/Layer/LayerPage.dart';
import 'package:scet_dz/pages/ModuleMonitor/Components/UploadMaintain.dart';
import 'package:scet_dz/pages/ModuleMonitor/StationDetails.dart';
import 'package:scet_dz/pages/ModuleUser/UserCenter.dart';
import 'package:scet_dz/pages/ModuleUser/UserLogin.dart';

// 配置静态路由
final routes = {
  '/': (context) => HomePage(), // 首页
  '/login': (context) => UserLogin(), // 登录
  '/mine': (context) => UserCenter(), // 个人中心
  '/map/layerPage': (context, {arguments}) => LayerPage(arguments: arguments), // 其他图层
  '/alarm/dataView': (context, {arguments}) => AlarmView(data: arguments), // 警情视图
  '/station/details': (context, { arguments }) => StationDetails(data: arguments), // 站点详情
  '/upload/inspection': (context) => UploadInspection(), // 站点巡检上传
  '/upload/maintain': (context, { arguments }) => UploadMaintain(arguments: arguments), // 设备检修上传
};

// 使用
// Navigator.pushNamed(context, '/productsPage',arguments: val);

// 统一处理
Function onGenerateRoute = (RouteSettings settings) {
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
