import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:scet_app/components/ToastWidget.dart';
import 'package:scet_app/model/data/data_global.dart';
import 'package:scet_app/pages/loginModel/loginPage.dart';

import 'package:scet_app/utils/tool/storage/data_storageKey.dart';
import 'package:scet_app/utils/tool/storage/storage.dart';
import 'Api.dart';

//使用例子  var response = await Request().post(url, data:data);

class Request {
  static Request _instance = Request._internal();

  factory Request() => _instance;

  // 全局变量
  Dio dio = Dio();

  // 初始化
  Request._internal() {
    dio = new Dio(
      new BaseOptions(
        baseUrl: Api.BASE_URL,
        //连接服务器超时时间，单位是毫秒.
        connectTimeout: 10000,
        //响应流上前后两次接受到数据的间隔，单位为毫秒。
        receiveTimeout: 10000,
        //以哪种格式接受响应数据。4种`json`, `stream`, `plain`, `bytes`. 默认 `json`
        responseType: ResponseType.json,
      ),
    );

    /**如果需要添加cookie管理器**/
    // Future(() async {return (await getApplicationDocumentsDirectory()).path;
    // }).then((path) => {
    //   dio.interceptors.add(CookieManager(PersistCookieeJar(dir: path, ignoreExpires: true)))
    // });

    // 添加拦截器
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (RequestOptions options,RequestInterceptorHandler handler) {
        dio.lock();
      Future<dynamic> future = Future(() async {
        return StorageUtil().getString(StorageKey.Token) ?? "";
      });
      future.then((value) {
        options.headers["token"] = value;
        return options;
      }).whenComplete(() => dio.unlock());
      return handler.next(options);
    }, onResponse: (Response response,ResponseInterceptorHandler handler) {
      //统一处理 例如可以跳转登录页
      if (response.data is Map && response.data['code'] == 302) {
        ToastWidget.showToastMsg(response.data['status']);
        Global.navigatorKey.currentState!.pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginPage()),
            (router) => router == null);
        // Global.navigatorKey.currentState.pushNamed("/LoginPage");
      }
      return handler.next(response);
    }, onError: (DioError e,ErrorInterceptorHandler  handler) {
      ErrorEntity eInfo = createErrorEntity(e); // 错误提示
      ToastWidget.showToastMsg(eInfo.message!);
      return handler.next(e);
    }));
  }

  ///  post请求 默认json 如果是from表单 true
  post(url, {data, isForm: false}) async {
    Response response;
    Options option = Options();
    if (isForm) {
      option.contentType = Headers.formUrlEncodedContentType;
    }
    try {
      if (null == data || data.length < 0) {
        response = await dio.post(url, options: option);
      } else {
        response = await dio.post(url, data: data, options: option);
      }
      print('===>$url\n${response.data}');
      return response.data;
    } on DioError catch (e) {
      print("post错误-->$e");
      return {'code': null};
    }
  }

  ///  get请求
  get(url, {data}) async {
    Response response;
    try {
      if (null == data) {
        response = await dio.get(url);
      } else {
        response = await dio.get(url, queryParameters: data);
      }
      print('===>$url\n${response.data}');
      return response.data;
    } on DioError catch (e) {
      print("get错误-->$e");
      return {'code': null};
    }
  }

  /// 下载文件 savePath 文件保存的路径 downloadProgress 进度
  download(urlPath, savePath,{Function? downloadProgress}) async {
    // print("downloadProgress===${downloadProgress}");
    Response response;
    Options option = Options(
      //响应流上前后两次接受到数据的间隔，单位为毫秒。
      receiveTimeout: 150000,
    );
    try {
      response = await dio.download(urlPath, savePath,
          onReceiveProgress: downloadProgress == null ? null : (int count, int total) {
        // print("下载进度：$count/$total");
        downloadProgress("${((count/total)*100).toStringAsFixed(2)}%");
      },
          options: option);
      return response.data;
    } on DioError catch (e) {
      print("download错误-->$e");
    }
  }

  /// 下载图片字节 （保存图片时使用）
  getbytes(url, {data}) async {
    Response response;
    Options option =  Options(responseType: ResponseType.bytes);
    try {
      if (null == data) {
        response = await dio.get(url, options: option);
      } else {
        response = await dio.get(url, queryParameters: data, options:option);
      }
      return response.data;
    } on DioError catch (e) {
      print("getbytes错误-->$e");
      return null;
    }
  }

  /// 上传文件  filePath：文件路径
  upfile(url, filePath) async {
    if (filePath == null) {
      return;
    }
    Options option = Options();
    Response response;
    FormData formdata = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        filePath, //路径
        filename: filePath.split("/")[filePath.split("/").length - 1], //名称
      ),
      "fileName": filePath.split("/")[filePath.split("/").length - 1],
    });
    try {
      response = await dio.post(
        url,
        data: formdata,
        options: option,
        onSendProgress: (int sent, int total) {
          ToastWidget.showToastMsg("${((sent / total) * 100).toStringAsFixed(0)}%");
        },
      );
      return response.data;
    } on DioError catch (e) {
      print("upfile错误-->$e");
    }
  }

  /*
   * error 错误信息统一处理
   */
  ErrorEntity createErrorEntity(DioError error) {
    switch (error.type) {
      case DioErrorType.cancel:
        {
          return ErrorEntity(code: -1, message: "请求取消");
        }
        break;
      case DioErrorType.connectTimeout:
        {
          return ErrorEntity(code: -1, message: "连接超时");
        }
        break;
      case DioErrorType.sendTimeout:
        {
          return ErrorEntity(code: -1, message: "请求超时");
        }
        break;
      case DioErrorType.receiveTimeout:
        {
          return ErrorEntity(code: -1, message: "响应超时");
        }
        break;
      case DioErrorType.response:
        {
          try {
            int errCode = error.response!.statusCode!;
            // String errMsg = error.response.statusMessage;
            // return ErrorEntity(code: errCode, message: errMsg);
            switch (errCode) {
              case 400:
                {
                  return ErrorEntity(code: errCode, message: "请求语法错误");
                }
                break;
              case 401:
                {
                  return ErrorEntity(code: errCode, message: "没有权限");
                }
                break;
              case 403:
                {
                  return ErrorEntity(code: errCode, message: "服务器拒绝执行");
                }
                break;
              case 404:
                {
                  return ErrorEntity(code: errCode, message: "无法连接服务器");
                }
                break;
              case 405:
                {
                  return ErrorEntity(code: errCode, message: "请求方法被禁止");
                }
                break;
              case 500:
                {
                  return ErrorEntity(code: errCode, message: "服务器内部错误");
                }
                break;
              case 502:
                {
                  return ErrorEntity(code: errCode, message: "无效的请求");
                }
                break;
              case 503:
                {
                  return ErrorEntity(code: errCode, message: "服务器挂了");
                }
                break;
              case 505:
                {
                  return ErrorEntity(code: errCode, message: "不支持HTTP协议请求");
                }
                break;
              default:
                {
                  // return ErrorEntity(code: errCode, message: "未知错误");
                  return ErrorEntity(
                      code: errCode, message: error.response!.statusMessage!);
                }
            }
          } on Exception catch (_) {
            return ErrorEntity(code: -1, message: "未知错误");
          }
        }
        break;
    //默认错误类型，一些其他错误。在这种情况下，你可以
    //使用dierror。如果不为空则返回错误。
      case DioErrorType.other:
        {
          return ErrorEntity(code: -1, message: "默认错误类型");
        }
        break;
      default:
        {
          return ErrorEntity(code: -1, message: error.message);
        }
    }
  }
}

// 异常处理
class ErrorEntity implements Exception {
  int? code;
  String? message;

  ErrorEntity({this.code, this.message});

  String toString() {
    if (message == null) return "Exception";
    return "Exception: code $code, $message";
  }
}
