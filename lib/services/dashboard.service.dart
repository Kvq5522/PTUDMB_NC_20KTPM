import 'package:dio/dio.dart';
import 'package:studenthub/networks/dio_client.dart';

class DashBoardService {
  final DioClient _dioClient = DioClient();
  //Company Dashboard
  Future<List<Map<String, dynamic>>> getCompanyProjectsDashBoard(
      BigInt companyId, int typeFlag, String token) async {
    Response res = await _dioClient.get(
      "/api/project/company/$companyId",
      queries: {
        "companyId": companyId,
        "typeFlag": typeFlag,
      },
      token: token,
    );
    if (res.statusCode! >= 400) {
      String errorMessage = res.data?["errorDetails"];

      throw Exception(errorMessage);
    }
    return List<Map<String, dynamic>>.from(res.data?["result"]);
  }

  Future<List<Map<String, dynamic>>> getProposals(
      String projectId, String token) async {
    Response res = await _dioClient.get(
      "/api/proposal/getByProjectId/$projectId",
      queries: {
        "companyId": projectId,
        // "q": "all",
        "offset": 0,
        "limit": 100,
        "order": "createdAt:DESC",
        // "statusFlag": "all",
      },
      token: token,
    );

    if (res.statusCode! >= 400) {
      String errorMessage = res.data?["errorDetails"];

      throw Exception(errorMessage);
    }
    var result =
        List<Map<String, dynamic>>.from(res.data?["result"]["items"] ?? []);
    // print("===================");
    // print(result);
    // print("===================");
    return result;
  }

  Future<Map<String, dynamic>> getProjectDetails(
      int projectId, String token) async {
    Response res = await _dioClient.get(
      "/api/project/$projectId",
      token: token,
    );

    if (res.statusCode! >= 400) {
      String errorMessage = res.data?["errorDetails"];

      throw Exception(errorMessage);
    }
    Map<String, dynamic> result =
        Map<String, dynamic>.from(res.data?["result"] ?? {});

    return result;
  }

  Future<List<Map<String, dynamic>>> getProjectMessages(
      BigInt projectId, String token) async {
    Response res = await _dioClient.get(
      "/api/message/$projectId",
      token: token,
    );

    return (res.data?["result"] as List)
        .map((item) => item as Map<String, dynamic>)
        .toList();
  }

  Future<Map<String, dynamic>> patchProposalDetails(
    int id,
    String coverLetter,
    int statusFlag,
    int disableFlag,
    String token,
  ) async {
    Response res = await _dioClient.patch(
      "/api/proposal/$id",
      body: {
        "coverLetter": coverLetter,
        "statusFlag": statusFlag,
        "disableFlag": disableFlag,
      },
      token: token,
    );

    print(res.toString());

    if (res.statusCode! >= 400) {
      String errorMessage = res.data?["errorDetails"];
      throw Exception(errorMessage);
    }

    Map<String, dynamic> result =
        Map<String, dynamic>.from(res.data?["result"] ?? {});

    return result;
  }

  Future<Map<String, dynamic>> patchProjectDetails(
    int id,
    int projectScopeFlag,
    String title,
    String description,
    int numberOfStudents,
    int typeFlag,
    int status,
    String token,
  ) async {
    Response res = await _dioClient.patch(
      "/api/project/$id",
      body: {
        "projectScopeFlag": projectScopeFlag,
        "title": title,
        "description": description,
        "numberOfStudents": numberOfStudents,
        "typeFlag": typeFlag,
        "status": status,
      },
      token: token,
    );

    if (res.statusCode! >= 400) {
      String errorMessage = res.data?["errorDetails"];
      throw Exception(errorMessage);
    }

    Map<String, dynamic> result =
        Map<String, dynamic>.from(res.data?["result"] ?? {});

    return result;
  }

  Future<Map<String, dynamic>> deleteProject(
    int id,
    String token,
  ) async {
    Response res = await _dioClient.deleteQ(
      "/api/project/$id",
      token: token,
    );

    if (res.statusCode! >= 400) {
      String errorMessage = res.data?["errorDetails"];
      throw Exception(errorMessage);
    }

    Map<String, dynamic> result =
        Map<String, dynamic>.from(res.data?["result"] ?? {});

    return result;
  }

  Future<Map<String, dynamic>> postProject(
    int companyId,
    int projectScopeFlag,
    String title,
    int numberOfStudents,
    String description,
    int typeFlag,
    String token,
  ) async {
    Response res = await _dioClient.post(
      "/api/project",
      body: {
        "companyId": companyId,
        "projectScopeFlag": projectScopeFlag,
        "title": title,
        "numberOfStudents": numberOfStudents,
        "description": description,
        "typeFlag": typeFlag
      },
      token: token,
    );
    if (res.statusCode! >= 400) {
      String errorMessage = res.data?["errorDetails"];
      throw Exception(errorMessage);
    }

    Map<String, dynamic> result =
        Map<String, dynamic>.from(res.data?["result"] ?? {});

    return result;
  }

  Future<Map<String, dynamic>> getProposalById(
    int id,
    String token,
  ) async {
    Response res = await _dioClient.get(
      "/api/proposal/$id",
      token: token,
    );

    if (res.statusCode! >= 400) {
      String errorMessage = res.data?["errorDetails"];
      throw Exception(errorMessage);
    }

    Map<String, dynamic> result =
        Map<String, dynamic>.from(res.data?["result"] ?? {});

    return result;
  }

  //Student Dashboard
  Future<List<Map<String, dynamic>>> getStudentProposals(
      {required BigInt studentId,
      int? typeFlag,
      int? statusFlag,
      int? disableFlag,
      required String token}) async {
    Map<String, dynamic> queries = {
      "studentId": studentId,
    };

    if (typeFlag != null) {
      queries["typeFlag"] = typeFlag;
    }
    if (statusFlag != null) {
      queries["statusFlag"] = statusFlag;
    }
    if (disableFlag != null) {
      queries["disableFlag"] = disableFlag;
    }

    Response res = await _dioClient.get(
      "/api/proposal/project/$studentId",
      queries: queries,
      token: token,
    );
    if (res.statusCode! >= 400) {
      String errorMessage = res.data?["errorDetails"];

      throw Exception(errorMessage);
    }

    return List<Map<String, dynamic>>.from(res.data?["result"]);
  }

  Future<List<Map<String, dynamic>>> getStudentProjects(
      BigInt studentId, int typeFlag, String token) async {
    try {
      Response res = await _dioClient.get(
        "/api/proposal/project/$studentId",
        queries: {
          "studentId": studentId,
          "typeFlag": typeFlag,
          "disableFlag": 0,
          // "statusFlag": 3,
        },
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

  Future<Map<String, dynamic>> getStudentProfile(
      String studentId, String token) async {
    Response res = await _dioClient.get(
      "/api/profile/student/$studentId",
      token: token,
    );

    print(res);

    if (res.statusCode! >= 400) {
      String errorMessage = res.data?["errorDetails"];

      throw Exception(errorMessage);
    }

    return Map<String, dynamic>.from(res.data?["result"]);
  }

  Future<Map<String, dynamic>> getProposal(
      String proposalId, String token) async {
    Response res = await _dioClient.get(
      "/api/proposal/$proposalId",
      token: token,
    );

    if (res.statusCode! >= 400) {
      String errorMessage = res.data?["errorDetails"];

      throw Exception(errorMessage);
    }
    Map<String, dynamic> result =
        Map<String, dynamic>.from(res.data?["result"] ?? {});

    return result;
  }

  Future<String> getResume(String studentId, String token) async {
    try {
      Response res = await _dioClient.get(
        "/api/profile/student/$studentId/resume",
        token: token,
      );

      if (res.statusCode! >= 400) {
        String errorMessage = res.data?["errorDetails"];
        throw Exception(errorMessage ?? "Unknown error");
      }

      dynamic responseData = res.data;
      if (responseData is String) {
        // Nếu phản hồi là một chuỗi, đây là URL của tệp PDF
        return responseData;
      } else {
        throw Exception("Invalid response format");
      }
    } catch (e) {
      throw Exception("Failed to fetch resume: $e");
    }
  }

  Future<Map<String, dynamic>> getTranscript(
      String studentId, String token) async {
    Response res = await _dioClient.get(
      "/api/profile/student/$studentId/transcript",
      token: token,
    );

    if (res.statusCode! >= 400) {
      String errorMessage = res.data?["errorDetails"];

      throw Exception(errorMessage);
    }
    Map<String, dynamic> result =
        Map<String, dynamic>.from(res.data?["result"] ?? {});

    return result;
  }
}
