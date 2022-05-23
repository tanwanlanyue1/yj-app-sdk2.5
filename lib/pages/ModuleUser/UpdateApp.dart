import 'dart:io';
import 'package:cs_app/api/Api.dart';
import 'package:cs_app/api/Request.dart';
import 'package:cs_app/components/ToastWidget.dart';
import 'package:cs_app/utils/screen/screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:r_upgrade/r_upgrade.dart';
import 'package:path_provider/path_provider.dart';

class UpdateApp extends StatefulWidget {
  @override
  _UpdateAppState createState() => _UpdateAppState();
}

class _UpdateAppState extends State<UpdateApp> {

  bool downloadState = false;
  bool updating = false; //更新中
  String? _version, appUrl;
  double _progress = 0.0;
  int? id;

  // 获取平台信息
  Future<String?> _getAppInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    _version = packageInfo.version;
    // 请求接口
    Map<String, String> params = Map();
    params['type'] = 'app';
    var response = await Request().get(Api.url['versions'], data: params);
    if(response['code'] == 200 && response['data'].isNotEmpty && _version != response['data'][0]['name']) {
      String url = Api.BASE_URL_PC + '/' + response['data'][0]['file']['path'];
      this.setState(() {
        downloadState = true;
        _version = response['data'][0]['name'];
        appUrl = url;
        _progress = 0.0;
      });
    }
  }

  //下载apk
  void upgrade(String url) async {
    id = await RUpgrade.upgrade(
        url,
        fileName: 'yuanquyujing.apk',
        isAutoRequestInstall: true,
        notificationVisibility:NotificationVisibility.VISIBILITY_VISIBLE,
        notificationStyle:NotificationStyle.planTime
    );
    updating = true;
    setState(() {});
    // ios
    //跳转到AppStore进行更新
    // void upgradeFromAppStore() async {
    //   bool isSuccess =await RUpgrade.upgradeFromAppStore(
    //     '您的AppId',
    //   );
    //   print(isSuccess);
    // }
    // 获取AppStore中你的应用最后的版本名
    // void getVersionFromAppStore() async {
    //         String versionName = await RUpgrade.getVersionFromAppStore(
    //                 '您的AppId',
    //                );
    //         print(versionName);
    //     }
  }
  //取消下载apk
  void cancel() async {
    if(id != null){
      RUpgrade.cancel(id!);
    }
  }
  @override
  void initState() {
    super.initState();
    _getAppInfo();
    RUpgrade.stream.listen((DownloadInfo info){
      _progress =  info.percent ?? 0.0;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: downloadState,
        child: Container(
            width: Adapt.screenW(),
            height: Adapt.screenH(),
            color: Colors.black54,
            child: Center(
              child: Container(
                width: px(540),
                height: px(625),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('lib/assets/images/bgImage.png'),
                        fit: BoxFit.fill
                    )
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: px(20)),
                            child: Text(
                              '解决了一些已知的问题！',
                              style: TextStyle(
                                  fontSize: sp(32),
                                  fontFamily: "M",
                                  color: Color(0xFF2E2F33)
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: px(40)),
                            child: Text(
                              '已下载：$_progress%',
                              style: TextStyle(
                                  fontSize: sp(22),
                                  fontFamily: "M",
                                  color: Color(0xFFA8ABB3)
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              succeedDialogBtn(
                                str: '取消',
                                bgColor:  Color(0xFF8F98B3),
                                onTap: () {
                                  setState(() {
                                    downloadState = false;
                                    cancel();
                                  });
                                },
                              ),
                              succeedDialogBtn(
                                str: updating ? '正在更新':'更新APP',
                                bgColor:  Color(0xFF4D7CFF),
                                onTap: () {
                                  if(!updating){
                                    upgrade(appUrl!);
                                  }else{
                                    ToastWidget.showToastMsg('正在更新中');
                                  }
                                },
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
        )
    );
  }

  Widget succeedDialogBtn({String? str, Function? onTap,Color? bgColor}){
    return InkWell(
      child: Container(
        width: px(270),
        height: px(86),
        alignment: Alignment.center,
        color:bgColor,
        child: Text(
          '$str',
          style: TextStyle(
              fontSize: sp(30),
              color: Color(0xFFFFFFFF)
          ),
        ),
      ),
      onTap: (){
        onTap?.call();
      },
    );
  }
}
