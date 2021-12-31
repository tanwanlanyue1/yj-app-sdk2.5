import 'dart:convert';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:scet_app/components/ToastWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Api.dart';

class Http {
  static final String GET = "get";
  static final String POST = "post";
  static final String DATA = "data";
  static final String CODE = "code";
  static final String STATUS = "status";

  Dio dio = new Dio();
  late String showMsg;
  late BaseOptions options;
  static Http? _instance;

  static Http getInstance() {
    if (_instance == null) {
      _instance = Http();
    }
    return _instance!;
  }

  Http() {
    options = BaseOptions(
      baseUrl: Api.BASE_URL,
      connectTimeout: 10000,
      receiveTimeout: 5000
    );

    dio = Dio(options);

    // 添加请求拦截器
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (RequestOptions options,RequestInterceptorHandler handler) {
        dio.lock();
        Future<dynamic> future = Future(() async{
          SharedPreferences prefs = await SharedPreferences.getInstance();
          return prefs.getString("token");
        }).then((value) {
          options.headers["token"] = value;
          return options;
        }).whenComplete(() => dio.unlock());
        return handler.next(options);
      }, 
      onResponse: (Response response,ResponseInterceptorHandler handler) {
        BotToast.closeAllLoading();
        return handler.next(response);
      }, 
      onError: (DioError e,ErrorInterceptorHandler  handler) {
        BotToast.closeAllLoading();
        return handler.next(e);
      })
    );
  }

  // get请求
  get(String url, Function successCallBack, {params, Function? errorCallBack}) async {
    _requstHttp(url, successCallBack, GET, params, errorCallBack);
  }

  // post请求
  post(String url, Function successCallBack, {params, Function? errorCallBack}) async {
    _requstHttp(url, successCallBack, POST, params, errorCallBack);
  }

  _requstHttp(String url, Function successCallBack, [String? method, Map<String, dynamic>? params, Function? errorCallBack]) async {
    String errorMsg = ''; 
    try {
     late Response response;

      if (method == GET) {
        if (params != null && params.isNotEmpty) {
          response = await dio.get(url, queryParameters: params);
        } else {
          response = await dio.get(url);
        }
      } else if (method == POST) {
        if (params != null && params.isNotEmpty) {
          response = await dio.post(url, data: params);
        } else {
          response = await dio.post(url);
        }
      }

      if (response.statusCode == 200) {
        String dataStr = json.encode(response.data);
        Map<String, dynamic>? dataMap = json.decode(dataStr);
        if (dataMap != null && dataMap[CODE] != 200) {
          errorMsg = '错误码：' + dataMap[CODE].toString() + '，' + dataMap[STATUS].toString();
          _error(errorCallBack, errorMsg);
          return false;
        } else if (successCallBack != null) {
          successCallBack(dataMap![DATA]);
        }
      } 
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        _error(errorCallBack, '连接服务器超时！');
      } else if (e.type == DioErrorType.sendTimeout) {
        _error(errorCallBack, '请求数据超时！');
      } else if (e.type == DioErrorType.receiveTimeout) {
        _error(errorCallBack, '服务器响应超时！');
      } else if (e.type == DioErrorType.response) {
        _error(errorCallBack, '出现异常！');
      } else if (e.type == DioErrorType.cancel) {
        _error(errorCallBack, '请求取消！');
      } else {
        _error(errorCallBack, '未知错误！');
      }
    }
  }

  _error(Function? errorCallBack, String error) {
    if(showMsg == error.toString()) {
      return false;
    } else {
      showMsg = error.toString();
      ToastWidget.showToastMsg(error.toString());
    }
    if (errorCallBack != null) {
      errorCallBack(error);
    }
  }
}