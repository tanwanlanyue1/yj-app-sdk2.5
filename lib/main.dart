import 'dart:async';
import 'package:bot_toast/bot_toast.dart';
import 'package:cs_app/utils/screen/Adapter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:cs_app/routers/Routes.dart';
import 'model/data/data_global.dart';
import 'model/provider/provider.dart';
import 'model/provider/provider_app.dart';

void main() {
  // 自定义报错页面（打包后显示）
  if (kReleaseMode) {
    ErrorWidget.builder = (FlutterErrorDetails flutterErrorDetails) {
      debugPrint(flutterErrorDetails.toString());
      return Material(
        child: Center(
          child: Text("发生了没有处理的错误\n请通知开发者", textAlign: TextAlign.center,)
        ),
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
        child: MyApp()
      ),
    );
  }, (Object error, StackTrace stack) {
    print('出错：error==>,$error \n 出错：stack==>,$stack\n');
  });
}

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  ScreenUtilInit(
        designSize: const Size(Adapter.designWidth, Adapter.designHeight),
        minTextAdapt: false,
        splitScreenMode: true,
        builder: (context, child) => MaterialApp(
          title: '长寿预警',
          navigatorKey: navigatorKey,
          builder: BotToastInit(),
          navigatorObservers: [BotToastNavigatorObserver()],
          debugShowCheckedModeBanner: false,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('en', 'US'),
            Locale('zh', 'CH'),
          ],
          locale: Locale('zh'),
          theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: Color(0XFF4D7CFF),
            visualDensity: VisualDensity.adaptivePlatformDensity,
            scaffoldBackgroundColor: Color(0XFFF2F4FA),
          ),
          initialRoute: '/',
          // onGenerateRoute: onGenerateRoute,
          onGenerateRoute:(RouteSettings settings) =>onGenerateRoute(settings),
          )
        );
  }
}
 