import 'package:flutter/material.dart';

/// 系统相应状态配置
class AppState with ChangeNotifier {
  bool _isGrayFilter = false;

  get isGrayFilter => _isGrayFilter;

  AppState({bool isGrayFilter = false}) {
    this._isGrayFilter = isGrayFilter;
  }

  /// 切换灰色滤镜夜晚模式
  switchGrayFilter() {
    _isGrayFilter = !_isGrayFilter;
    notifyListeners();
  }
}
