import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scet_app/model/provider/provider_app.dart';
import 'package:scet_app/utils/api/Request.dart';
import 'package:scet_app/utils/tool/storage/data_storageKey.dart';
import 'package:scet_app/utils/tool/storage/storage.dart';

/// 全局配置
class Global {
  /// 用户配置
//  static UserLoginResponseEntity profile = UserLoginResponseEntity(
//    accessToken: null,
//  );
  /// 离线用户token
  static String token;

  /// 是否第一次打开
  static bool isFirstOpen = false;

  /// 是否离线登录
  static bool isOfflineLogin = false;

  /// provider 应用状态,
  static AppState appState = AppState();

  /// 是否 release
  static bool get isRelease => bool.fromEnvironment("dart.vm.product");

  /// app文件本地保存路径
  static String appDownload = '';

  /// 三个字体文件路径
  static String fontFileM = '';
  static String fontFileB = '';
  static String fontFileR = '';

  ///全局的navigatorKey
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  /// init 工具统一初始化
  static Future init() async {
    // 运行初始
    WidgetsFlutterBinding.ensureInitialized();

    appDownload =
        (await getApplicationDocumentsDirectory()).path + "/fontDownload/";

    fontFileM = appDownload + StorageKey.FontMedium;
    fontFileB = appDownload + StorageKey.FontBold;
    fontFileR = appDownload + StorageKey.FontRegular;

    // 本地存储工具初始化
    await StorageUtil.init();

    // dio工具初始化
    Request();

    // 读取设备是否已经打开过
    isFirstOpen =
        StorageUtil().getBool(StorageKey.STORAGE_DEVICE_ALREADY_OPEN_KEY);
    if (isFirstOpen) {
      await readFont(fontFileM, "M");
      await readFont(fontFileB, "B");
      await readFont(fontFileR, "R");
    }

    //读取离线用户token
    var _token = StorageUtil().getString(StorageKey.Token);
    if (_token != null && _token != 'null' && _token != '') {
      token = _token;
      isOfflineLogin = true;
    }

    // android 状态栏为透明的沉浸
    if (Platform.isAndroid) {
      SystemUiOverlayStyle systemUiOverlayStyle =
          SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
  }

  ///  加载字体的方法
  static Future<void> readFont(String path, String name) async {
    print('文件 $path --->读取成功');
    var fontLoader = FontLoader(name);
    fontLoader.addFont(getCustomFont(path));
    await fontLoader.load();
  }

  static Future<ByteData> getCustomFont(String path) async {
    var byteData = await new File(path).readAsBytes();
    return ByteData.view(byteData.buffer);
  }
}
