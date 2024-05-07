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

  Future<Map<String, dynamic>> getInterviewById({
    required String token,
    required int interviewId,
  }) async {
    try {
      Response res = await _dioClient.get(
        "/api/interview/$interviewId",
        token: token,
      );

      if (res.statusCode! >= 400) {
        // List errors = res.data?["errorDetails"];
        String errorMessage = res.data?["errorDetails"];
        // ? errors.join("\n")
        // : "Get messages failed, please try again.";
        throw Exception(errorMessage);
      }

      return res.data?["result"];
    } catch (_) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> postInterview(
    String title,
    String content,
    String startTime,
    String endTime,
    int projectId,
    String senderId,
    int receiverId,
    String meetingCode,
    String meetingId,
    String expiredAt,
    String token,
  ) async {
    Response res = await _dioClient.post(
      "/api/interview",
      body: {
        "title": title,
        "content": content,
        "startTime": startTime,
        "endTime": endTime,
        "projectId": projectId,
        "senderId": senderId,
        "receiverId": receiverId,
        "meeting_room_code": meetingId,
        "meeting_room_id": meetingId,
        "expiredAt": expiredAt,
      },
      token: token,
    );
    if (res.statusCode! >= 400) {
      String errorDetailsString = res.data?["errorDetails"];
      List<dynamic> errorDetails = errorDetailsString.split("\n");
      String errorMessage = errorDetails.join("\n");
      throw Exception(errorMessage);
    }

    Map<String, dynamic> result =
        Map<String, dynamic>.from(res.data?["result"] ?? {});

    return result;
  }

  Future<Map<String, dynamic>> patchInterview(
    String title,
    String content,
    String startTime,
    String endTime,
    String token,
    int id,
  ) async {
    Response res = await _dioClient.patch(
      "/api/interview/$id",
      body: {
        "title": title,
        "content": content,
        "startTime": startTime,
        "endTime": endTime,
      },
      token: token,
    );
    if (res.statusCode! >= 400) {
      String errorDetailsString = res.data?["errorDetails"];
      List<dynamic> errorDetails = errorDetailsString.split("\n");
      String errorMessage = errorDetails.join("\n");
      throw Exception(errorMessage);
    }

    Map<String, dynamic> result =
        Map<String, dynamic>.from(res.data?["result"] ?? {});

    return result;
  }

  Future<Map<String, dynamic>> deleteInterview(
    int id,
    String token,
  ) async {
    Response res = await _dioClient.delete(
      "/api/interview/$id",
      token,
    );
    if (res.statusCode! >= 400) {
      String errorDetailsString = res.data?["errorDetails"];
      List<dynamic> errorDetails = errorDetailsString.split("\n");
      String errorMessage = errorDetails.join("\n");
      throw Exception(errorMessage);
    }

    Map<String, dynamic> result =
        Map<String, dynamic>.from(res.data?["result"] ?? {});

    return result;
  }
}
