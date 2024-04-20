import 'package:dio/dio.dart';
import 'package:studenthub/networks/dio_client.dart';
// import 'package:studenthub/stores/user_info/user_info.dart';

class ProjectService {
  // final UserInfoStore _userInfoStore = UserInfoStore();
  final DioClient _dioClient = DioClient();

  //Get all project
  Future<List<Map<String, dynamic>>> getAllProject(
      {required String token}) async {
    try {
      Response res = await _dioClient.get("/api/project", token: token);

      if (res.statusCode! >= 400) {
        // List errors = res.data?["errorDetails"];
        String errorMessage = res.data?["errorDetails"];
        // ? errors.join("\n")
        // : "Get skill set failed, please try again.";
        throw Exception(errorMessage);
      }

      return List<Map<String, dynamic>>.from(res.data?["result"]);
    } catch (_) {
      rethrow;
    }
  }

  //Get all Saved project
  Future<List<Map<String, dynamic>>> getAllSavedProject(
      {required String studentId, required String token}) async {
    try {
      Response res =
          await _dioClient.get("/api/favoriteProject/$studentId", token: token);

      if (res.statusCode! >= 400) {
        // List errors = res.data?["errorDetails"];
        String errorMessage = res.data?["errorDetails"];
        // ? errors.join("\n")
        // : "Get skill set failed, please try again.";
        throw Exception(errorMessage);
      }
      var data = List<Map<String, dynamic>>.from(res.data?["result"]);

      // print(data);
      return data;
    } catch (_) {
      rethrow;
    }
  }

// Get detail project
  Future<Map<String, dynamic>> getProjectDetail(
      {required String projectId, required String token}) async {
    try {
      final response =
          await _dioClient.get('/api/project/$projectId', token: token);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data['result'];
        return responseData;
      } else {
        throw Exception(
            'Failed to load project details: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to load project details: $error');
    }
  }

  // Search by title
  Future<List<Map<String, dynamic>>> searchProjectByTitle(
      {required String title, required String token}) async {
    try {
      Response res =
          await _dioClient.get("/api/project?title=$title", token: token);

      if (res.statusCode == 200) {
        List<Map<String, dynamic>> projects =
            List<Map<String, dynamic>>.from(res.data?["result"]);
        return projects;
      } else {
        throw Exception('Failed to search projects: ${res.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to search projects: $error');
    }
  }

  Future<List<Map<String, dynamic>>> filterProject(
      {required int projectScopeFlag,
      required int numberOfStudents,
      required int proposalsLessThan,
      required String token}) async {
    try {
      Response res = await _dioClient.get(
          "/api/project?projectScopeFlag=$projectScopeFlag&numberOfStudents=$numberOfStudents&proposalsLessThan=$proposalsLessThan",
          token: token);

      if (res.statusCode == 200) {
        List<Map<String, dynamic>> projects =
            List<Map<String, dynamic>>.from(res.data?["result"]);
        return projects;
      } else {
        throw Exception('Failed to search projects: ${res.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to search projects: $error');
    }
  }

  Future<void> updateFavoriteProject({
    required String studentId,
    required int projectId,
    required int disableFlag,
    required String token,
  }) async {
    try {
      final response = await _dioClient.patch(
        '/api/favoriteProject/$studentId',
        body: {
          "projectId": projectId,
          "disableFlag": disableFlag,
        },
        token: token,
      );

      if (response.statusCode == 200) {
        // Handle success
        print('Favorite project updated successfully');
      } else {
        // Handle failure
        throw Exception(
            'Failed to update favorite project: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to update favorite project: $error');
    }
  }

  Future<Map<String, dynamic>> postStudentProposal(
    String projectId,
    String studentId,
    String coverLetter,
    int statusFlag,
    int disableFlag,
    String token,
  ) async {
    Response res = await _dioClient.post("/api/proposal",
        body: {
          "projectId": projectId,
          "studentId": studentId,
          "coverLetter": coverLetter,
          "statusFlag": statusFlag,
          "disableFlag": disableFlag,
        },
        token: token);
    if (res.statusCode! >= 400) {
      String errorMessage = res.data?["errorDetails"];
      throw Exception(errorMessage);
    }

    Map<String, dynamic> result =
        Map<String, dynamic>.from(res.data?["result"] ?? {});

    return result;
  }
}
