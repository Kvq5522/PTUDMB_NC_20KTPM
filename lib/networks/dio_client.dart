import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';

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

  Future<Response> postFormData(String path,
      {dynamic body, String token = ""}) async {
    try {
      return await _dio.post(path,
          data: FormData.fromMap(body),
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

  Future<File> downloadFile(String path, String saveName) async {
    try {
      Response response = await Dio().get(
        path,
        options: Options(responseType: ResponseType.bytes),
      );

      String? contentDisposition =
          response.headers.value('content-disposition');
      print("Content-Disposition: $contentDisposition");

      Directory? dir = await getExternalStorageDirectory();
      if (dir == null) {
        throw Exception('Cannot get external storage directory');
      }

      String downloadsDirPath = '${dir.path}/Download';
      await Directory(downloadsDirPath).create(recursive: true);

      File file = File('$downloadsDirPath/$saveName');
      await file.writeAsBytes(response.data);

      return file;
    } on DioException catch (e) {
      print(e.toString());
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

  Future<Response> putFormData(String path,
      {dynamic body, String token = ""}) async {
    try {
      return await _dio.put(path,
          data: FormData.fromMap(body),
          options: Options(
            headers: {"Authorization": "Bearer $token"},
          ));
    } on DioException catch (e) {
      debugPrint(e.toString());

      rethrow;
    }
  }

  Future<Response> delete(String path, String token) async {
    try {
      return await _dio.delete(path,
          options: Options(headers: {"Authorization": "Bearer $token"}));
    } on DioException catch (e) {
      debugPrint(e.toString());

      rethrow;
    }
  }

  Future<Response> deleteQ(String path, {String token = ""}) async {
    try {
      return await _dio.delete(path,
          options: Options(headers: {"Authorization": "Bearer $token"}));
    } on DioException catch (e) {
      debugPrint(e.toString());

      rethrow;
    }
  }

  Future<Response> patch(String path, {dynamic body, String token = ""}) async {
    try {
      return await _dio.patch(path,
          data: body,
          options: Options(
            headers: {"Authorization": "Bearer $token"},
          ));
    } on DioException catch (e) {
      debugPrint(e.toString());

      rethrow;
    }
  }
}
