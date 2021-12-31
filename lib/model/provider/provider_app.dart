import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scet_app/components/DialogPages.dart';

// 系统相应状态配置
class AppState with ChangeNotifier {
  bool? _isGrayFilter;

  get isGrayFilter => _isGrayFilter;

  AppState({bool isGrayFilter = false}) {
    this._isGrayFilter = isGrayFilter;
  }

  // 切换灰色滤镜夜晚模式
  switchGrayFilter() {
    _isGrayFilter = !_isGrayFilter!;
    notifyListeners();
  }

  //判断设备是苹果还是安卓：
  void checkystem(context) async {
    if (Platform.isIOS) {
      print("IOS");
      ///ios端执行程序相关代码
    }
    if (Platform.isAndroid) {
      print("安卓");
      ///android端执行程序相关代码
      var status = await  Future.delayed(Duration(seconds: 2), (){
        print('延时2s 模拟网络版本请求执行');
        return true;
      });

      if(status != null &&  status == true){
        // print('status=>${status}');
        DialogPages.succeedDialog(
            context,
            title:'安卓app更新弹窗预留坑',
            backStr: '不更新',
            succeedStr: '立即更新'
        );
      }
    }
    notifyListeners();
  }
}
