import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioRequestUtil {
  static final DioRequestUtil _instance = DioRequestUtil._internal();
  late Dio dio;

  factory DioRequestUtil() => _instance;

  DioRequestUtil._internal() {
    BaseOptions options = BaseOptions(
      baseUrl: 'https://api.example.com', // Replace with your base URL
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    dio = Dio(options);

    // Add Interceptors
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (kDebugMode) {
          print('REQUEST[${options.method}] => PATH: ${options.path}');
        }
        // Add token or other logic here
        // options.headers['Authorization'] = 'Bearer YOUR_TOKEN';
        return handler.next(options);
      },
      onResponse: (response, handler) {
        if (kDebugMode) {
          print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
        }
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        if (kDebugMode) {
          print('ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}');
        }
        // Handle global error here
        String errorMessage = _handleDioError(e);
        return handler.next(e.copyWith(message: errorMessage));
      },
    ));
  }

  String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return '网络连接超时';
      case DioExceptionType.sendTimeout:
        return '请求发送超时';
      case DioExceptionType.receiveTimeout:
        return '响应接收超时';
      case DioExceptionType.badResponse:
        int? statusCode = error.response?.statusCode;
        switch (statusCode) {
          case 400: return '错误请求';
          case 401: return '未授权，请登录';
          case 403: return '拒绝访问';
          case 404: return '请求错误,未找到该资源';
          case 500: return '服务器内部错误';
          case 503: return '服务不可用';
          default: return '网络响应错误($statusCode)';
        }
      case DioExceptionType.cancel:
        return '请求已取消';
      case DioExceptionType.connectionError:
        return '网络连接错误';
      default:
        return '未知错误: ${error.message}';
    }
  }

  // Generic Request methods
  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? queryParameters, Options? options}) {
    return dio.get<T>(path, queryParameters: queryParameters, options: options);
  }

  Future<Response<T>> post<T>(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) {
    return dio.post<T>(path, data: data, queryParameters: queryParameters, options: options);
  }

  Future<Response<T>> put<T>(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) {
    return dio.put<T>(path, data: data, queryParameters: queryParameters, options: options);
  }

  Future<Response<T>> delete<T>(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) {
    return dio.delete<T>(path, data: data, queryParameters: queryParameters, options: options);
  }
}
