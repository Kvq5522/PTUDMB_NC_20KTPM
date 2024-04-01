import 'package:dio/dio.dart';
import 'package:studenthub/networks/dio_client.dart';
import 'package:studenthub/stores/user_info/user_info.dart';

class UserService {
  final UserInfoStore _userInfoStore = UserInfoStore();
  final DioClient _dioClient = DioClient();

  //Create a company profile
  Future<Map<String, dynamic>> createCompanyProfile({
    required String token,
    required String companyName,
    required int size,
    required String website,
    required String description,
  }) async {
    try {
      Response res = await _dioClient.post(
        "/api/profile/company",
        body: {
          "companyName": companyName,
          "size": size,
          "website": website,
          "description": description,
        },
        token: token,
      );

      print(res);

      if (res.statusCode! >= 400) {
        // List errors = res.data?["errorDetails"];
        String errorMessage = res.data?["errorDetails"];
        // ? errors.join("\n")
        // : "Create company profile failed, please try again.";
        throw Exception(errorMessage);
      }

      return res.data?["result"];
    } catch (_) {
      rethrow;
    }
  }

  //Get company profile
  Future<Map<String, dynamic>> getCompanyProfile(
      {required String token, required BigInt companyId}) async {
    try {
      Response res =
          await _dioClient.get("/api/profile/company/$companyId", token: token);

      print(res.data?["result"]);

      if (res.statusCode! >= 400) {
        // List errors = res.data?["errorDetails"];
        String errorMessage = res.data?["errorDetails"];
        // ? errors.join("\n")
        // : "Get company profile failed, please try again.";
        throw Exception(errorMessage);
      }

      return res.data?["result"];
    } catch (_) {
      rethrow;
    }
  }

  //Edit company profile
  Future<Map<String, dynamic>> editCompanyProfile({
    required String token,
    required String companyName,
    required int size,
    required String website,
    required String description,
    required BigInt companyId,
  }) async {
    try {
      Response res = await _dioClient.put(
        "/api/profile/company/$companyId",
        body: {
          "companyName": companyName,
          "size": size,
          "website": website,
          "description": description,
        },
        token: token,
      );

      print(res);

      if (res.statusCode! >= 400) {
        // List errors = res.data?["errorDetails"];
        String errorMessage = res.data?["errorDetails"];
        // ? errors.join("\n")
        // : "Edit company profile failed, please try again.";
        throw Exception(errorMessage);
      }

      return res.data?["result"];
    } on DioException {
      rethrow;
    } catch (_) {
      rethrow;
    }
  }

  //Get all techstacks
  Future<List<Map<String, dynamic>>> getAllTechStack(
      {required String token}) async {
    try {
      Response res =
          await _dioClient.get("/api/techstack/getAllTechStack", token: token);

      print(res.data?["result"]);

      if (res.statusCode! >= 400) {
        // List errors = res.data?["errorDetails"];
        String errorMessage = res.data?["errorDetails"];
        // ? errors.join("\n")
        // : "Get tech stack failed, please try again.";
        throw Exception(errorMessage);
      }

      return List<Map<String, dynamic>>.from(res.data?["result"]);
    } catch (_) {
      rethrow;
    }
  }

  //Get user techstacks
  Future<List<Map<String, dynamic>>> getUserTechStack(
      {required String token, required BigInt userId}) async {
    try {
      Response res = await _dioClient.get(
        "/api/techstack/$userId",
        token: token,
      );

      print(res.data?["result"]);

      if (res.statusCode! >= 400) {
        // List errors = res.data?["errorDetails"];
        String errorMessage = res.data?["errorDetails"];
        // ? errors.join("\n")
        // : "Get user tech stack failed, please try again.";
        throw Exception(errorMessage);
      }

      return List<Map<String, dynamic>>.from(res.data?["result"]);
    } catch (_) {
      rethrow;
    }
  }

  //Get all skillsets
  Future<List<Map<String, dynamic>>> getAllSkillSet(
      {required String token}) async {
    try {
      Response res =
          await _dioClient.get("/api/skillset/getAllSkillSet", token: token);

      print(res.data?["result"]);

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

  //Get user skillsets
  Future<List<Map<String, dynamic>>> getUserSkillSet(
      {required String token, required BigInt userId}) async {
    try {
      Response res = await _dioClient.get(
        "/api/profile/student/$userId/techStack",
        token: token,
      );

      print(res.data?["result"]);

      if (res.statusCode! >= 400) {
        // List errors = res.data?["errorDetails"];
        String errorMessage = res.data?["errorDetails"];
        // ? errors.join("\n")
        // : "Get user skill set failed, please try again.";
        throw Exception(errorMessage);
      }

      return List<Map<String, dynamic>>.from(res.data?["result"]);
    } catch (_) {
      rethrow;
    }
  }
}
