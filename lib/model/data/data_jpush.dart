import 'package:cs_app/api/Api.dart';
import 'package:cs_app/api/Request.dart';
import 'package:cs_app/components/ToastWidget.dart';
import 'package:cs_app/utils/screen/screen.dart';
import 'package:cs_app/utils/storage/data_storageKey.dart';
import 'package:cs_app/utils/storage/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jpush_flutter/jpush_flutter.dart';

//极光插件封装
class JpushData{
  static JpushData _instance = new JpushData._();
  factory JpushData() => _instance;
  JpushData._();

  static String debugLable = 'Unknown';
  static String registrationID = '';
  static final JPush jpush = new JPush();
  static Future init() async {
    await initPlatformState();
  }

  // 初始化极光插件
  static Future<void> initPlatformState() async {
    try {
      jpush.addEventHandler(
          onReceiveNotification: (Map<String, dynamic> message) async {
            print("==>flutter onReceiveNotification: $message");
            debugLable = "flutter onReceiveNotification: $message";
            },

          onOpenNotification: (Map<String, dynamic> message) async {
            print("==>flutter onOpenNotification: $message");
            debugLable = "flutter onOpenNotification: $message";
            },

          onReceiveMessage: (Map<String, dynamic> message) async {
            print("==>flutter onReceiveMessage: $message");
            debugLable = "flutter onReceiveMessage: $message";
            },

          onReceiveNotificationAuthorization: (Map<String, dynamic> message) async {
            print("==>flutter onReceiveNotificationAuthorization: $message");
            debugLable = "flutter onReceiveNotificationAuthorization: $message";
          });
    } on PlatformException {
      print("==>Failed to get platform version.");
      debugLable = 'Failed to get platform version.';
    }
    jpush.setup(
      appKey: "ed55900be48cdc15361977f0", //你自己应用的 AppKey
      channel: "developer-default",
      production: false,
      debug: true,
    );
    jpush.applyPushAuthority(new NotificationSettingsIOS(sound: true, alert: true, badge: true));

    // Platform messages may fail, so we use a try/catch PlatformException.
    jpush.getRegistrationID().then((rid) {
      print("==>flutter get registration id : $rid");
      debugLable = "flutter getRegistrationID: $rid";
      registrationID = rid;
    });
  }

  // 调用此 API 检测通知授权状态是否打开 在第一个页面调用
  static Future<void> isNotificationEnabled(BuildContext context) async {
    jpush.isNotificationEnabled().then((bool value) {
      debugLable = "通知授权是否打开: $value";
      print(debugLable);
      if(!value){
        showDialog<Null>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text("温馨提示",style: TextStyle(fontSize:sp(30)),),
              content: new Text("您当前没有开启通知权限",style: TextStyle(fontSize:sp(25)),),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () {
                    openSettingsForNotification();
                    Navigator.pop(context);
                  },
                  child: new Text("去开启"),
                ),
                new FlatButton(
                  onPressed: () {
                    ToastWidget.showToastMsg('请先开启通知权限');
                  },
                  child: new Text("取消"),
                ),
              ],
            );
          },
        );
      }
    }).catchError((onError) {
      debugLable = "通知授权是否打开: ${onError.toString()}";
    });

  }

  // 打开系统设置
  static void openSettingsForNotification() async {
    jpush.openSettingsForNotification();
  }
  // 停止接收推送
  static Future stopPush() async {
    jpush.stopPush();
    return jpushPhone(isPush: 0);
  }

  static Future jpushPhone({required int isPush}) async { // 接口关闭推送
    Map _user = StorageUtil().getJSON(StorageKey.user);
    Map<String, dynamic> params = Map();
    params['phone'] = _user['phone'];
    params['registrationId'] = registrationID;
    params['online'] = isPush;
    return await Request().post(Api.url['jpush'], data: params);
  }

  // 恢复推送功能
  static void resumePush() async {
    await jpushPhone(isPush: 1);
    await jpush.resumePush();
  }
  // 清空通知栏上的所有通知
  static void clearAllNotifications() async {
    await jpush.clearAllNotifications();
  }

  // 设置用户标签
  static void setTags(List<String> list) async {
    jpush.setTags(list).then((map) {
      var tags = map['tags'];
      print('map=${map}');
      debugLable = "set tags success: $map $tags";
    }).catchError((error) {
      print('error=${error}');
      debugLable = "set tags error: $error";
    });
  }

  // iOS Only
  static void getLaunchAppNotification() {
    jpush.getLaunchAppNotification().then((map) {
      print("flutter getLaunchAppNotification:$map");
      debugLable = "getLaunchAppNotification success: $map";
    }).catchError((error) {
      debugLable = "getLaunchAppNotification error: $error";
    });
  }
  // 发本地推送
  static void postJpush({required int id, required String title, required int buildId, required String content, required String subtitle, required int badge, required Map<String, String> extra}) {
    // 1秒后出发本地推送
    var fireDate = DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch + 1000);
    var localNotification = LocalNotification(id: id, title: title, buildId: buildId, content: content, fireTime: fireDate, subtitle: subtitle, badge: badge, extra: {"fa": "0"});
    // var localNotification = LocalNotification(
    //     id: 234,
    //     title: '长寿预警1',
    //     buildId: 1,
    //     content: '长寿预警2',
    //     fireTime: fireDate,
    //     subtitle: '长寿预警3',
    //     badge: 5,
    //     extra: {"fa": "0"});
    jpush.sendLocalNotification(localNotification).then((res) {
      debugLable = res;
    });
  }

  // 添加用户标签
  static void addTags(List<String> list) {
    jpush.addTags(list).then((map) {
      var tags = map['tags'];
      debugLable = "addTags success: $map $tags";
    }).catchError((error) {
        debugLable = "addTags error: $error";
    });
  }

  // 删除标签
  static void deleteTags(List<String> list) {
    jpush.deleteTags(list).then((map) {
      var tags = map['tags'];
      debugLable = "deleteTags success: $map $tags";
    }).catchError((error) {
      debugLable = "deleteTags error: $error";
    });
  }

  // 获取所有当前绑定的 tags
  static void getAllTags() {
    jpush.getAllTags().then((map) {
      print('当前绑定的 tags--${map}');
      debugLable = "getAllTags success: $map";
    }).catchError((error) {
      print('未获取绑定的 tags--${error}');
      debugLable = "getAllTags error: $error";
    });
  }

  // 清空所有 标签。
  static void cleanTags() {
    jpush.cleanTags().then((map) {
      var tags = map['tags'];
      debugLable = "cleanTags success: $map $tags";
    }).catchError((error) {
      debugLable = "cleanTags error: $error";
    });
  }

  // 重置 alias.
  static void setAlias(String data) {
    jpush.setAlias(data).then((map) {
      debugLable = "setAlias success: $map";
    }).catchError((error) {
      debugLable = "setAlias error: $error";
    });
  }

  // 删除原有 alias
  static void deleteAlias() {
    jpush.deleteAlias().then((map) {
      debugLable = "deleteAlias success: $map";
    }).catchError((error) {
      debugLable = "deleteAlias error: $error";
    });
  }

  // 设置应用 Badge（小红点）
  static void setBadge(int badge)  {
    jpush.setBadge(badge).then((map) {
        debugLable = "setBadge success: $map";
    }).catchError((error) {
        debugLable = "setBadge error: $error";
    });
  }
}