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
    String token,
  ) async {
    Response res = await _dioClient.patch(
      "/api/project/$id",
      body: {
        "projectScopeFlag": projectScopeFlag,
        "title": title,
        "description": description,
        "numberOfStudents": numberOfStudents,
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
      BigInt studentId, int typeFlag, String token) async {
    Response res = await _dioClient.get(
      "/api/proposal/project/$studentId",
      queries: {
        "studentId": studentId,
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
}
