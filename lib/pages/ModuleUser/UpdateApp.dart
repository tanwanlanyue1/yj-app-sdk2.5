import 'dart:io';
import 'package:cs_app/api/Api.dart';
import 'package:cs_app/api/Request.dart';
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

  // 下载安卓更新包
  Future<File?> _downloadAndroid(String url) async {
    Directory? storageDir = await getExternalStorageDirectory();
    String? storagePath = storageDir?.path;
    File file = new File('$storagePath/csappv${_version}.apk');
    if (!file.existsSync()) {
      file.createSync();
    }
    try {
      Response response = await Dio().get(url,
        onReceiveProgress: (num received, num total) {
          if (total != -1) {
            double data = double.parse('${(received / total)}');
            if(data != 1.0) {
              this.setState(() {
                _progress = data;
              });
            } else {
              this.setState(() {
                _progress = data;
              });
            }
          }
        },
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
        )
      );
      file.writeAsBytesSync(response.data);
      return file;
    } catch (e) {
      print(e);
    }
  }

  // 安装apk
  Future<Null> _installApk(String url) async {
    File? _apkFile = await _downloadAndroid(url);
    String? _apkFilePath = _apkFile?.path;

    if (_apkFilePath?.isEmpty ?? true) {
      return;
    }
  }
  //下载apk
  void upgrade(String url) async {
    id = await RUpgrade.upgrade(
        url,
        fileName: 'chongqing.apk',
        isAutoRequestInstall: true,
        notificationVisibility:NotificationVisibility.VISIBILITY_VISIBLE,
        notificationStyle:NotificationStyle.planTime
    );
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
  //重新下载
  void pause(id) async {
    DownloadStatus? status = await RUpgrade.getDownloadStatus(id);
    bool? isSuccess=await RUpgrade.upgradeWithId(id);
    print(">>>>获取下载状态$status");
    print(">>>>重新下载$isSuccess");
    // isSuccess 返回 false 即表示从来不存在此ID
    // 返回 true
    //    调用此方法前状态为 0,4,5 [STATUS_PAUSED/暂停]、[STATUS_FAILED/失败]、[STATUS_CANCEL/取消],将继续下载
    //    调用此方法前状态为 1,2[STATUS_RUNNING]、[STATUS_PENDING]，不会发生任何变化
    //    调用此方法前状态为 3[STATUS_SUCCESSFUL]，将会安装应用
    // 当文件被删除时，重新下载
  }
  @override
  void initState() {
    super.initState();
    _getAppInfo();
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
                          '已下载：${(_progress * 100).toStringAsFixed(2)}%',
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
                              });
                            },
                          ),
                          succeedDialogBtn(
                            str: '更新APP',
                            bgColor:  Color(0xFF4D7CFF),
                            onTap: () {
                              upgrade(appUrl!);
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
