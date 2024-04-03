import 'package:dio/dio.dart';
import 'package:studenthub/networks/dio_client.dart';
import 'package:studenthub/stores/user_info/user_info.dart';

class AuthenticationService {
  final UserInfoStore _userInfoStore = UserInfoStore();
  final DioClient _dioClient = DioClient();

  Future<void> signUp(
      String fullname, String email, String password, bool isStudent) async {
    try {
      Response res = await _dioClient.post(
        "/api/auth/sign-up",
        body: {
          "fullname": fullname,
          "email": email,
          "password": password,
          "role": isStudent ? 0 : 1,
        },
      );

      if (res.statusCode! >= 400) {
        List errors = res.data?["errorDetails"];
        String errorMessage = errors.isNotEmpty
            ? errors.join("\n")
            : "Sign up failed, please try again.";
        throw Exception(errorMessage);
      }

      _userInfoStore.setUserType(isStudent ? "Student" : "Company");
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<String> signIn(String email, String password) async {
    try {
      Response response = await _dioClient.post(
        "/api/auth/sign-in",
        body: {
          "email": email,
          "password": password,
        },
      );

      if (response.statusCode! >= 400) {
        // List errors = response.data?["errorDetails"];
        // String errorMessage = errors.isNotEmpty
        //     ? errors.join("\n")
        //     : "Sign in failed, please try again.";
        throw Exception(response.data?["errorDetails"]);
      }

      final String token = response.data?["result"]?["token"];

      return token;
    } catch (_) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getUserInfo(String token) async {
    try {
      Response res = await _dioClient.get(
        "/api/auth/me",
        token: token,
      );

      if (res.statusCode! >= 400) {
        throw Exception("Failed to get user info.");
      }

      print(res.data?["result"]);

      return res.data?["result"];
    } catch (_) {
      rethrow;
    }
  }
}
