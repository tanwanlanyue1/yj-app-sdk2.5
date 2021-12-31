import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scet_app/components/DialogPages.dart';
import 'package:scet_app/model/data/data_global.dart';
import 'package:scet_app/utils/api/Api.dart';
import 'package:scet_app/utils/api/Request.dart';
import 'package:scet_app/utils/tool/screen/screen.dart';
import 'package:scet_app/components/ToastWidget.dart';
import 'package:scet_app/utils/tool/storage/data_storageKey.dart';
import 'package:scet_app/utils/tool/storage/storage.dart';
class AddFont extends StatefulWidget {
  @override
  _AddFontState createState() => _AddFontState();
}

class _AddFontState extends State<AddFont> {

  String _progress = '0.0%';
  int _count = 3; //队列
  bool _down = true;
  int _popTrue = 1;//记录返回次数 为3就是退出app
  //下载文件
  downLoad() async {
    bool exist = await isDirectoryExist(Global.appDownload);
    if(!exist){
      await createDirectory(Global.appDownload);
    }
    // 文件1
    await Request().download(Api.url['alibabaBold'], Global.fontFileB,
        downloadProgress:(val){
      checkProgress(val,Global.fontFileB,'B');
    }
    );
    // 文件2
    await Request().download(Api.url['alibabaMedium'], Global.fontFileM,
        downloadProgress:(val){
      checkProgress(val, Global.fontFileM,"M");
    }
    );
    // 文件3
    await Request().download(Api.url['alibabaRegular'],  Global.fontFileR,
        downloadProgress:(val){
          checkProgress(val, Global.fontFileR,"R");
    }
    );
    // 下载完成
    if(_count == 0){
      ToastWidget.showToastMsg('下载完成,欢迎使用!');
      Navigator.pop(context);
      StorageUtil().setBool(StorageKey.STORAGE_DEVICE_ALREADY_OPEN_KEY,true);
    }
  }

  Future<bool> isDirectoryExist(String path) async{
    File file = File(path);
    return await file.exists();
  }

  Future<void> createDirectory(String path) async {
    Directory directory = Directory(path);
    directory.create();
  }

  void checkProgress(String val, String savePath,String name) async {
    _progress = val;
    if(val == '100.00%'){
      _count = _count-1;
      await Global.readFont(savePath,name);
    }
    setState(() {});
  }

  ///监听首页返回
  Future<bool> _onWillPop(){
    ToastWidget.showToastMsg('请先下载!');
    _popTrue = _popTrue + 1;
    if(_popTrue == 3 ) { pop(); }
    return Future.delayed(Duration(seconds: 2), () {
      _popTrue = 1;
      return false;
    });
  }

  Future<void> pop() async {
    await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
        onWillPop: _onWillPop,
        child: Center(
          child: Container(
            width: px(540),
            height: px(625),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/home/bgImage.png'),
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
                          '检测到有${_count}个静态资源未下载',
                          style: TextStyle(
                              fontSize: sp(32),
                              fontFamily: "M",
                              color: Color(0xFF2E2F33)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: px(40)),
                        child: Text(
                          '已下载：$_progress',
                          style: TextStyle(
                              fontSize: sp(22),
                              fontFamily: "M",
                              color: Color(0xFFA8ABB3)),
                        ),
                      ),
                      Row(
                        children: [
                          DialogPages.succeedDialogBtn(
                            str: '拒绝',
                            bgColor:  Color(0xFF8F98B3),
                            onTap: (){
                              ToastWidget.showToastMsg('首次启动App请先下载静态资源');
                            },
                          ),
                          DialogPages.succeedDialogBtn(
                            str: '立即下载',
                            bgColor:  Color(0xFF4D7CFF),
                            onTap: () {
                              if(_down){
                                downLoad();
                                _down = !_down;
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
    );
  }
}
