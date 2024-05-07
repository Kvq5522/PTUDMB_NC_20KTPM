import 'package:dio/dio.dart';
import 'package:studenthub/networks/dio_client.dart';

class MessageService {
  final DioClient _dioClient = DioClient();

  Future<List<Map<String, dynamic>>> getChatroom({required token}) async {
    try {
      Response res = await _dioClient.get(
        "/api/message",
        token: token,
      );

      if (res.statusCode! >= 400) {
        String errorMessage = res.data?["errorDetails"];
        throw Exception(errorMessage);
      }

      return List<Map<String, dynamic>>.from(res.data?["result"]);
    } catch (_) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getMessages({
    required String token,
    required BigInt projectId,
    required BigInt receiverId,
    required int page,
  }) async {
    try {
      Response res = await _dioClient.get(
        "/api/message/get/page",
        queries: {
          "projectId": projectId,
          "receiverId": receiverId,
          "pageSize": 15,
          "page": page,
        },
        token: token,
      );

      print("Page: $page");

      if (res.statusCode! >= 400) {
        // List errors = res.data?["errorDetails"];
        String errorMessage = res.data?["errorDetails"];
        // ? errors.join("\n")
        // : "Get messages failed, please try again.";
        throw Exception(errorMessage);
      }

      return List<Map<String, dynamic>>.from(res.data?["result"]?["messages"]);
    } catch (_) {
      rethrow;
    }
  }

  Future<dynamic> sendMessage({
    required String token,
    required BigInt projectId,
    required BigInt senderId,
    required BigInt receiverId,
    required String content,
  }) async {
    try {
      Response res = await _dioClient.post(
        "/api/message/sendMessage",
        body: {
          "projectId": projectId.toInt(),
          "senderId": senderId.toInt(),
          "receiverId": receiverId.toInt(),
          "content": content,
          "messageFlag": 0
        },
        token: token,
      );

      if (res.statusCode! >= 400) {
        String errorMessage = res.data?["errorDetails"];
        throw Exception(errorMessage);
      }

      return res.data?["result"];
    } catch (_) {
      rethrow;
    }
  }
}
