import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DioClient {
  final Dio _dio;

  DioClient()
      : _dio = Dio(BaseOptions(
          validateStatus: (status) {
            return true;
          },
        )) {
    _dio.options.baseUrl = dotenv.env['BASE_URL'] as String;
  }

  Dio get dio => _dio;

  Future<Response> post(String path, {dynamic body, String token = ""}) async {
    try {
      return await _dio.post(path,
          data: body,
          options: Options(headers: {"Authorization": "Bearer $token"}));
    } on DioException catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<Response> get(String path,
      {dynamic queries, String token = ""}) async {
    try {
      // return await _dio.get(path, queryParameters: queries);
      return await _dio.get(path,
          queryParameters: queries,
          options: Options(headers: {"Authorization": "Bearer $token"}));
    } on DioException catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<Response> put(String path, {dynamic body, String token = ""}) async {
    try {
      return await _dio.put(path,
          data: body,
          options: Options(
            headers: {"Authorization": "Bearer $token"},
          ));
    } on DioException catch (e) {
      debugPrint(e.toString());

      rethrow;
    }
  }

  Future<Response> delete(String path) async {
    try {
      return await _dio.delete(path);
    } on DioException catch (e) {
      debugPrint(e.toString());

      rethrow;
    }
  }

  Future<Response> patch(String path, {dynamic body}) async {
    try {
      return await _dio.patch(path, data: body);
    } on DioException catch (e) {
      debugPrint(e.toString());

      rethrow;
    }
  }
}
