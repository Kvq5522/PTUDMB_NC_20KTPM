import 'package:dio/dio.dart';
import 'package:studenthub/networks/dio_client.dart';

class AuthenticationService {
  final DioClient _dioClient = DioClient();

  Future<bool> signUp(
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

      return true;
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

  Future<String> forgotPassword(String email) async {
    try {
      Response response = await _dioClient.post(
        "/api/user/forgotPassword",
        body: {
          "email": email,
        },
      );

      if (response.statusCode! >= 400) {
        List<dynamic>? errors = response.data["errorDetails"];
        String errorMessage = "Sign in failed, please try again.";
        if (errors != null && errors.isNotEmpty) {
          errorMessage = errors.join("\n");
        }
        throw Exception(errorMessage);
      }

      return "Password reset instructions sent to $email.";
    } catch (e) {
      throw Exception('Failed to send password reset email.');
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

      return res.data?["result"];
    } catch (_) {
      rethrow;
    }
  }
}
