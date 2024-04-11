import 'package:dio/dio.dart';
import 'package:studenthub/models/dto/profile_default.dto.dart';
import 'package:studenthub/networks/dio_client.dart';

class UserService {
  final DioClient _dioClient = DioClient();

  // Get student profile
  Future<Map<String, dynamic>> getStudentProfile({
    required String token,
    required BigInt studentId,
  }) async {
    try {
      Response res = await _dioClient.get(
        "/api/profile/student/$studentId",
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

  // Create or update student profile
  Future<Map<String, dynamic>> createOrUpdateStudentProfile(
      {required String token,
      required dynamic techStackId,
      required List<dynamic> skillsetIds,
      required bool hasProfile,
      BigInt? studentId}) async {
    try {
      Response res = hasProfile
          ? await _dioClient.put(
              "/api/profile/student/$studentId",
              body: {
                "techStackId": techStackId,
                "skillSets": skillsetIds,
              },
              token: token,
            )
          : await _dioClient.post(
              "/api/profile/student",
              body: {
                "techStackId": techStackId,
                "skillSets": skillsetIds,
              },
              token: token,
            );

      if (res.statusCode! >= 400) {
        String errorMessage = "";

        dynamic errorDetails = res.data?["errorDetails"];

        if (errorDetails is List) {
          errorMessage = errorDetails.join("\n");
        } else if (errorDetails is String) {
          errorMessage = errorDetails;
        }

        throw Exception(errorMessage);
      }

      return res.data?["result"];
    } catch (_) {
      rethrow;
    }
  }

  //Create or a company profile
  Future<Map<String, dynamic>> createOrUpdateCompanyProfile({
    required String token,
    required String companyName,
    required int size,
    required String website,
    required String description,
    required bool hasProfile,
    BigInt? companyId,
  }) async {
    try {
      Response res = hasProfile
          ? await _dioClient.put(
              "/api/profile/company/$companyId",
              body: {
                "companyName": companyName,
                "size": size,
                "website": website,
                "description": description,
              },
              token: token,
            )
          : await _dioClient.post(
              "/api/profile/company",
              body: {
                "companyName": companyName,
                "size": size,
                "website": website,
                "description": description,
              },
              token: token,
            );

      if (res.statusCode! >= 400) {
        String errorMessage = "";

        dynamic errorDetails = res.data?["errorDetails"];

        if (errorDetails is List) {
          errorMessage = errorDetails.join("\n");
        } else if (errorDetails is String) {
          errorMessage = errorDetails;
        }

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

      if (res.statusCode! >= 400) {
        String errorMessage = "";

        dynamic errorDetails = res.data?["errorDetails"];

        if (errorDetails is List) {
          errorMessage = errorDetails.join("\n");
        } else if (errorDetails is String) {
          errorMessage = errorDetails;
        }

        throw Exception(errorMessage);
      }

      return res.data?["result"];
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

      if (res.statusCode! >= 400) {
        String errorMessage = "";

        dynamic errorDetails = res.data?["errorDetails"];

        if (errorDetails is List) {
          errorMessage = errorDetails.join("\n");
        } else if (errorDetails is String) {
          errorMessage = errorDetails;
        }

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

      if (res.statusCode! >= 400) {
        String errorMessage = "";

        dynamic errorDetails = res.data?["errorDetails"];

        if (errorDetails is List) {
          errorMessage = errorDetails.join("\n");
        } else if (errorDetails is String) {
          errorMessage = errorDetails;
        }

        throw Exception(errorMessage);
      }

      return List<Map<String, dynamic>>.from(res.data?["result"]);
    } catch (_) {
      rethrow;
    }
  }

  // Update user language
  Future<List<Map<String, dynamic>>> updateUserLanguage({
    required String token,
    required BigInt userId,
    required List<StudentLanguageDto> languages,
  }) async {
    try {
      Response res = await _dioClient.put(
        "/api/language/updateByStudentId/$userId",
        body: {
          "languages": languages,
        },
        token: token,
      );

      if (res.statusCode! >= 400) {
        String errorMessage = "";

        dynamic errorDetails = res.data?["errorDetails"];

        if (errorDetails is List) {
          errorMessage = errorDetails.join("\n");
        } else if (errorDetails is String) {
          errorMessage = errorDetails;
        }

        throw Exception(errorMessage);
      }

      print(res.data?["result"]);

      return (res.data?["result"] as List)
          .map((item) => item as Map<String, dynamic>)
          .toList();
    } catch (_) {
      rethrow;
    }
  }

  // Update user education
  Future<List<Map<String, dynamic>>> updateUserEducation({
    required String token,
    required BigInt userId,
    required List<StudentEducationDto> education,
  }) async {
    try {
      Response res = await _dioClient.put(
        "/api/education/updateByStudentId/$userId",
        body: {
          "education": education,
        },
        token: token,
      );

      if (res.statusCode! >= 400) {
        String errorMessage = "";

        dynamic errorDetails = res.data?["errorDetails"];

        if (errorDetails is List) {
          errorMessage = errorDetails.join("\n");
        } else if (errorDetails is String) {
          errorMessage = errorDetails;
        }

        throw Exception(errorMessage);
      }

      return (res.data?["result"] as List)
          .map((item) => item as Map<String, dynamic>)
          .toList();
    } catch (_) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> updateUserExperience({
    required String token,
    required BigInt userId,
    required List<StudentExperienceDto> experience,
  }) async {
    try {
      Response res = await _dioClient.put(
        "/api/experience/updateByStudentId/$userId",
        body: {
          "experience": experience,
        },
        token: token,
      );

      if (res.statusCode! >= 400) {
        String errorMessage = "";

        dynamic errorDetails = res.data?["errorDetails"];

        if (errorDetails is List) {
          errorMessage = errorDetails.join("\n");
        } else if (errorDetails is String) {
          errorMessage = errorDetails;
        }

        throw Exception(errorMessage);
      }

      return (res.data?["result"] as List)
          .map((item) => item as Map<String, dynamic>)
          .toList();
    } catch (_) {
      rethrow;
    }
  }
}
