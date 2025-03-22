import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'api_config.dart';

// A generic interface for decoding API responses
abstract class Decodable<T> {
  T fromJson(Map<String, dynamic> json);
}

class ApiClient {
  final Dio _dio;

  ApiClient._internal(this._dio);

  // Singleton instance
  static final ApiClient _instance = ApiClient._internal(
    _createDio(
      ApiConfig.baseUrl,
    ),
  );

  // factory ApiClient() => _instance;

  factory ApiClient({String? baseUrl}) {
    if (baseUrl != null) {
      return ApiClient._internal(_createDio(baseUrl));
    }
    return _instance;
  }

  static Dio _createDio(String baseUrl) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(minutes: 1),
        receiveTimeout: const Duration(minutes: 1),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (options.queryParameters.isNotEmpty) {
          final queryParams = options.queryParameters.entries
              .map((e) => '${e.key}=${e.value}')
              .join('&');
          options.path = '${options.path}?$queryParams';
          options.queryParameters
              .clear(); // Clear original query parameters to avoid double encoding
        }

        final curl = StringBuffer(
            'curl -X ${options.method} \'${options.baseUrl}${options.path}\'');

        options.headers.forEach((key, value) {
          curl.write(' -H \'$key: $value\'');
        });

        if (options.data != null) {
          curl.write(' -d \'${options.data}\'');
        }

        print(curl.toString());

        handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        if (e.error is SocketException) {
          return handler.reject(
            DioException(
              requestOptions: e.requestOptions,
              error: 'No Internet Connection',
              type: DioExceptionType.connectionError,
            ),
          );
        } else if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          return handler.reject(
            DioException(
              requestOptions: e.requestOptions,
              error: 'Connection Timeout',
              type: DioExceptionType.connectionTimeout,
            ),
          );
        }
        return handler.next(e);
      },
    ));

    return dio;
  }

  Future<T> request<T extends Decodable<T>>({
    required String endpoint,
    required String method,
    dynamic data,
    Map<String, dynamic>? queryParams,
    required T model,
    ValueChanged<double>? progress,
  }) async {
    try {
      Response response;

      if (method == 'GET') {
        response = await _dio.get(
          endpoint,
          queryParameters: queryParams,
        );
      } else if (method == 'POST') {
        response = await _dio
            .post(endpoint, data: data, queryParameters: queryParams,
            onSendProgress: (int sent, int total) {
              if (progress != null) {
                progress(sent / total);
              }
            });
      } else if (method == 'PUT') {
        response = await _dio.put(
          endpoint,
          data: data,
          queryParameters: queryParams,
        );
      } else if (method == 'DELETE') {
        response = await _dio.delete(
          endpoint,
          data: data,
          queryParameters: queryParams,
        );
      } else {
        throw UnsupportedError('Method not supported');
      }
      // log('Client side response ${response.data.toString()}');
      return model.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e, s) {
      log('Client ${e.error}');
      log(s.toString());
      if (e.error is SocketException ||
          e.type == DioExceptionType.connectionError) {
        throw InternetException();
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw TimeoutException();
      } else if (e.type == DioExceptionType.unknown &&
          e.error == 'Version Error') {
        throw VersionException();
      } else {
        throw ApiException('${e.error ?? e.response?.data['message']}');
      }
    } catch (e, s) {
      log('In $endpoint Client exception: ${s.toString()}');
      throw ApiException('Oops! We’re having trouble connecting to the server. '
          'Please check your internet connection and try again.');
    }
  }
}

// Custom Exception class for API error
class ApiException implements Exception {
  final String message;

  ApiException(this.message);

  @override
  String toString() => message;
}

// Custom Exception class for Internet error
class InternetException implements Exception {}

// Custom Exception class for timeout error
class TimeoutException implements Exception {}

// Custom Exception class for timeout error
class VersionException implements Exception {}