import 'dart:async';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:scet_app/pages/LoginModel/components/addFont.dart';
import 'package:scet_app/routers/Routes.dart';
import 'model/data/data_global.dart';
import 'model/provider/provider.dart';
import 'model/provider/provider_app.dart';

void main() {
  /// 自定义报错页面（打包后显示）
  if (kReleaseMode) {
    ErrorWidget.builder = (FlutterErrorDetails flutterErrorDetails) {
      debugPrint(flutterErrorDetails.toString());
      return Material(
        child: Center(
          child: Text(
            "发生了没有处理的错误\n请通知开发者",
            textAlign: TextAlign.center,
          )
        )
      );
    };
  }

  // 捕获并上报 Dart 异常（开发版）
  runZonedGuarded(() async {
    await Global.init();
    runApp(
        MultiProvider(
            providers: [
              ChangeNotifierProvider<AppState>.value(value: Global.appState,),
              ChangeNotifierProvider<HomeModel>.value(value: HomeModel(),),
            ],
            child: MyApp(
              isLogin: Global.isOfflineLogin,
            ),
          ),
    );
  }, (Object error, StackTrace stack) {
    print('出错：error==>,$error \n 出错：stack==>,$stack\n');
  });
}

class MyApp extends StatelessWidget {
  final bool isLogin;

  MyApp({this.isLogin});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: '园区预警',
        builder: BotToastInit(),
        navigatorKey: Global.navigatorKey,
        navigatorObservers: [BotToastNavigatorObserver()],
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: [
          Locale('en', 'US'),
          Locale('zh', 'CH'),
        ],
        locale: Locale('zh'),
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Color(0XFF4D7CFF),
          /*字体选择类型
          *  B : Alibaba-PuHuiTi-Bold
          *  M : Alibaba-PuHuiTi-Medium
          *  R : Alibaba-PuHuiTi-Regular
          */
          fontFamily: 'R',
          visualDensity: VisualDensity.adaptivePlatformDensity,
          scaffoldBackgroundColor: Color(0XFFF2F4FA),
        ),
        initialRoute: isLogin ? '/HomePage' : '/',
        onGenerateRoute: onGenerateRoute,
    );
  }
}
