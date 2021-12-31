import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:cs_app/utils/storage/storage.dart';
import 'package:cs_app/components/Loading.dart';
import 'package:cs_app/components/ToastWidget.dart';
import 'package:cs_app/main.dart';
import 'package:cs_app/utils/storage/data_storageKey.dart';
import 'Api.dart';

class Request {

  static Request _instance = Request._internal();

  factory Request() => _instance;

  Dio dio = Dio();

  Request._internal() {
    dio = new Dio(
      new BaseOptions(
        baseUrl: Api.BASE_URL_APP,
        // 连接服务器超时时间，单位是毫秒.
        connectTimeout: 10000,
        // 响应流上前后两次接受到数据的间隔，单位为毫秒。
        receiveTimeout: 5000,
        // 以哪种格式接受响应数据。4种`json`, `stream`, `plain`, `bytes`. 默认 `json`
        responseType: ResponseType.json,
      ),
    );

    // 添加拦截器
    dio.interceptors.add(InterceptorsWrapper(
        onRequest: (RequestOptions options,RequestInterceptorHandler handler) {
          BotToast.showCustomLoading(
              ignoreContentClick: true,
              toastBuilder: (cancelFunc) {
                return Loading(cancelFunc: cancelFunc);
              }
          );
          dio.lock();
          Future<dynamic> future = Future(() async {
            return StorageUtil().getString(StorageKey.Token) ?? "";
          });
          future.then((value) {
            options.headers["token"] = value;
            return options;
          }).whenComplete(() => dio.unlock());
          return handler.next(options);
        },
        onResponse: (Response response,ResponseInterceptorHandler handler) {
          if (response.data is Map && response.data['code'] == 302) {
            ToastWidget.showToastMsg('用户信息过时，请重新登录！');
            BuildContext context = navigatorKey.currentState!.overlay!.context;
            Future.delayed(Duration(seconds: 0)).then((onValue) {
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            });
          }
          BotToast.closeAllLoading();
          return handler.next(response);
        },
        onError: (DioError e,ErrorInterceptorHandler  handler) {
          BotToast.closeAllLoading();
          ErrorEntity eInfo = createErrorEntity(e);
          ToastWidget.showToastMsg(eInfo.message!);
          return handler.next(e);
        }
    ));
  }

  // post请求 默认json 如果是from表单 true
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
      return {'code':null};
    }
  }

  // get请求
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
      return {'code':null};
    }
  }

  // 下载文件 savePath 文件保存的路径
  download(urlPath, savePath) async {
    Response response;
    try {
      response = await dio.download(urlPath, savePath,
          onReceiveProgress: (int count, int total) {
            print("下载进度：$count /""+""$total");
          });
      return response.data;
    } on DioError catch (e) {
      print("download错误-->$e");
    }
  }

  // 下载图片字节 （保存图片时使用）
  getbytes(url, {data}) async {
    Response response;
    Options option = Options();
    try {
      if (null == data) {
        response = await dio.get(url, options: Options(responseType: ResponseType.bytes));
      } else {
        response = await dio.get(url, queryParameters: data, options: Options(responseType: ResponseType.bytes));
      }
      return response.data;
    } on DioError catch (e) {
      print("getbytes错误-->$e");
      return null;
    }
  }

  // 上传文件  filePath：文件路径
  upfile(url, filePath) async {
    if (filePath == null) {
      return;
    }
    Options option = Options();
    Response response;
    FormData formdata = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        filePath, // 路径
        filename: filePath.split("/")[filePath.split("/").length - 1], // 名称
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
      case DioErrorType.connectTimeout:
        {
          return ErrorEntity(code: -1, message: "连接超时");
        }
      case DioErrorType.sendTimeout:
        {
          return ErrorEntity(code: -1, message: "请求超时");
        }
      case DioErrorType.receiveTimeout:
        {
          return ErrorEntity(code: -1, message: "响应超时");
        }
      case DioErrorType.response:
        {
          try {
            int? errCode = error.response!.statusCode;
            switch (errCode) {
              case 400:
                {
                  return ErrorEntity(code: errCode, message: "请求语法错误");
                }
              case 401:
                {
                  return ErrorEntity(code: errCode, message: "没有权限");
                }
              case 403:
                {
                  return ErrorEntity(code: errCode, message: "服务器拒绝执行");
                }
              case 404:
                {
                  return ErrorEntity(code: errCode, message: "无法连接服务器");
                }
              case 405:
                {
                  return ErrorEntity(code: errCode, message: "请求方法被禁止");
                }
              case 500:
                {
                  return ErrorEntity(code: errCode, message: "服务器内部错误");
                }
              case 502:
                {
                  return ErrorEntity(code: errCode, message: "无效的请求");
                }
              case 503:
                {
                  return ErrorEntity(code: errCode, message: "服务器挂了");
                }
              case 505:
                {
                  return ErrorEntity(code: errCode, message: "不支持HTTP协议请求");
                }
              default:
                {
                  return ErrorEntity(code: errCode, message: error.response?.statusMessage);
                }
            }
          } on Exception catch (_) {
            return ErrorEntity(code: -1, message: "未知错误");
          }
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
