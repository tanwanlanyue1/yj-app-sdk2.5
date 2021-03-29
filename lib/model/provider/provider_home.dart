import 'package:flutter/material.dart';
import 'package:scet_app/utils/api/Api.dart';
import 'package:scet_app/utils/api/Request.dart';
import 'package:scet_app/utils/tool/storage/data_storageKey.dart';
import 'package:scet_app/utils/tool/storage/storage.dart';

///首页配置
class HomeModel with ChangeNotifier {

  String _pageType = '1'; //首页数据
  bool _showBottom = false; // 上拉抽屉是否显示
  List _siteList =[]; //站点信息

  // bool showMarkerCluster = false; //点聚合

  get pageType => _pageType;
  get siteList => _siteList;
  get showBottom => _showBottom;

  void setPageType(String type){
    _pageType = type ;
    notifyListeners();
  }

  //更新上拉抽屉状态
  void setBottomDrawer(bool state){
    _showBottom = state ;
    notifyListeners();
  }

  //获取缓存的站点信息
  void getSiteList(List list) {
    _siteList = list;
    notifyListeners();
  }
}