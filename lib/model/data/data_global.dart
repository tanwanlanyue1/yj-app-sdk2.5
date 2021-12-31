import 'dart:io';
import 'package:cs_app/api/Request.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cs_app/model/provider/provider_app.dart';
import 'package:cs_app/utils/storage/data_storageKey.dart';
import 'package:cs_app/utils/storage/storage.dart';
import 'data_jpush.dart';

// 全局配置
class Global {
  // 是否第一次打开
  static bool isFirstOpen = false;

  // 是否离线登录
  static bool isOfflineLogin = false;

  // 是否显示首页警情提示
  static bool showAlarm = true;

  // 当前启动是否已经弹出过app提示
  static bool showAlarmToast = false;

  // provider 应用状态,
  static AppState appState = AppState();

  // 是否 release
  static bool get isRelease => bool.fromEnvironment("dart.vm.product");

  // init 工具统一初始化
  static Future init() async {
    // 运行初始
    WidgetsFlutterBinding.ensureInitialized();

    await JpushData.init();

    // Dio初始化
    Request();

    // 本地存储工具初始化
    await StorageUtil.init();

    // 读取设备第一次打开
    isFirstOpen = !StorageUtil().getBool(StorageKey.STORAGE_DEVICE_ALREADY_OPEN_KEY);
    if (isFirstOpen) {
      StorageUtil().setBool(StorageKey.showAlarm,true);
      StorageUtil().setBool(StorageKey.STORAGE_DEVICE_ALREADY_OPEN_KEY, true);
    }

    // 读取设备是否开启提示
    if (!isFirstOpen) {
      showAlarm = StorageUtil().getBool(StorageKey.showAlarm);
    }

    // android 状态栏为透明的沉浸
    if (Platform.isAndroid) {
      SystemUiOverlayStyle systemUiOverlayStyle =
      SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
  }
  // 改变警情提示弹窗状态
  static changeShowAlarm({required bool show}){
    showAlarm = show;
    StorageUtil().setBool(StorageKey.showAlarm, show);
  }
}