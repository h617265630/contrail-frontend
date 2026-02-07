import 'dart:convert';

import 'package:dio/dio.dart';

import 'app_config.dart';

typedef TokenProvider = String? Function();
typedef AuthErrorHandler = void Function();

class ApiClient {
  ApiClient({
    required TokenProvider tokenProvider,
    required AuthErrorHandler onUnauthorized,
    Dio? dio,
  })  : _tokenProvider = tokenProvider,
        _onUnauthorized = onUnauthorized,
        _dio = dio ?? Dio() {
    _dio.options = BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
      responseType: ResponseType.json,
      headers: {
        'Accept': 'application/json',
      },
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _tokenProvider();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          // Default to JSON for map payloads; Dio will override for FormData.
          if (options.data is Map || options.data is List) {
            options.headers.putIfAbsent('Content-Type', () => 'application/json');
          }
          handler.next(options);
        },
        onError: (error, handler) {
          final status = error.response?.statusCode;
          final path = error.requestOptions.path;
          final isAuthRoute = path.contains('/users/login') || path.contains('/users/register');
          if (status == 401 && !isAuthRoute) {
            _onUnauthorized();
          }
          handler.next(error);
        },
      ),
    );
  }

  final Dio _dio;
  final TokenProvider _tokenProvider;
  final AuthErrorHandler _onUnauthorized;

  Dio get dio => _dio;

  Never _throwApiError(DioException e) {
    final status = e.response?.statusCode;
    final data = e.response?.data;
    String message = 'Request failed';

    if (data is Map && data['detail'] != null) {
      message = '${data['detail']}';
    } else if (data is String && data.trim().isNotEmpty) {
      message = data;
    } else if (e.message != null && e.message!.trim().isNotEmpty) {
      message = e.message!;
    }

    throw ApiException(statusCode: status, message: message, raw: data);
  }

  Future<T> getJson<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic data)? decoder,
  }) async {
    try {
      final res = await _dio.get<dynamic>(path, queryParameters: queryParameters, options: options);
      final data = res.data;
      if (decoder != null) return decoder(data);
      return data as T;
    } on DioException catch (e) {
      _throwApiError(e);
    }
  }

  Future<T> postJson<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic data)? decoder,
  }) async {
    try {
      final res = await _dio.post<dynamic>(path, data: data, queryParameters: queryParameters, options: options);
      final body = res.data;
      if (decoder != null) return decoder(body);
      return body as T;
    } on DioException catch (e) {
      _throwApiError(e);
    }
  }

  Future<T> putJson<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic data)? decoder,
  }) async {
    try {
      final res = await _dio.put<dynamic>(path, data: data, queryParameters: queryParameters, options: options);
      final body = res.data;
      if (decoder != null) return decoder(body);
      return body as T;
    } on DioException catch (e) {
      _throwApiError(e);
    }
  }

  Future<T> patchJson<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic data)? decoder,
  }) async {
    try {
      final res = await _dio.patch<dynamic>(path, data: data, queryParameters: queryParameters, options: options);
      final body = res.data;
      if (decoder != null) return decoder(body);
      return body as T;
    } on DioException catch (e) {
      _throwApiError(e);
    }
  }

  Future<void> deleteVoid(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      await _dio.delete<dynamic>(path, data: data, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      _throwApiError(e);
    }
  }

  Future<String> getText(String url) async {
    try {
      final res = await _dio.get<String>(
        url,
        options: Options(responseType: ResponseType.plain),
      );
      return res.data ?? '';
    } on DioException catch (e) {
      _throwApiError(e);
    }
  }

  String encodeJson(Object value) => jsonEncode(value);
  dynamic decodeJson(String value) => jsonDecode(value);
}

class ApiException implements Exception {
  ApiException({required this.message, this.statusCode, this.raw});

  final int? statusCode;
  final String message;
  final dynamic raw;

  @override
  String toString() => 'ApiException($statusCode): $message';
}
