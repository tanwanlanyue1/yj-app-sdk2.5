import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scet_dz/api/Request.dart';
import 'package:scet_dz/model/provider/provider_app.dart';
import 'package:scet_dz/utils/storage/data_storageKey.dart';
import 'package:scet_dz/utils/storage/storage.dart';

// 全局配置
class Global {
  // 是否第一次打开
  static bool isFirstOpen = false;

  // 是否离线登录
  static bool isOfflineLogin = false;

  // provider 应用状态,
  static AppState appState = AppState();

  // 是否 release
  static bool get isRelease => bool.fromEnvironment("dart.vm.product");

  // init 工具统一初始化
  static Future init() async {
    // 运行初始
    WidgetsFlutterBinding.ensureInitialized();

    // 本地存储工具初始化
    await StorageUtil.init();

    // 网络请求初始化
    Request();

    // 读取设备第一次打开
    isFirstOpen = !StorageUtil().getBool(StorageKey.STORAGE_DEVICE_ALREADY_OPEN_KEY);
    if (isFirstOpen) {
      StorageUtil().setBool(StorageKey.STORAGE_DEVICE_ALREADY_OPEN_KEY, true);
    }

    // android 状态栏为透明的沉浸
    if (Platform.isAndroid) {
      SystemUiOverlayStyle systemUiOverlayStyle =
      SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
  }
}