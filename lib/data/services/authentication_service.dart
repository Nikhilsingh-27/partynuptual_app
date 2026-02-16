import 'package:dio/dio.dart';

import '../../core/network/api_endpoints.dart';
import '../../core/network/dio_client.dart';

class AuthenticationService {
  final Dio _dio = DioClient().dio;

  Future<Map<String, dynamic>> checkusername({required String username}) async {
    try {
      print("username is: ${username}");
      final response = await _dio.post(
        ApiEndpoints.checkusername,
        data: {"username": username},
        options: Options(
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            // 🔴 ADD THIS if Postman has it
            "X-Requested-With": "XMLHttpRequest",
          },
        ),
      );
      print(response.data);
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? "Not found");
    }
  }

  Future<Map<String, dynamic>> signup({
    required String username,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.signup,
        data: {
          "username": username,
          "email": email,
          "password": password,
          "user_type": role,
        },
        options: Options(contentType: Headers.jsonContentType),
      );
      print(response.data);
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? "Not found");
    }
  }

  Future<Map<String, dynamic>> loginfun({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.login,
        data: {"email": email, "password": password, "user_type": role},
        options: Options(contentType: Headers.jsonContentType),
      );
      print(response.data);
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? "Not found");
    }
  }

  Future<Map<String, dynamic>> forgotpassfun({required String email}) async {
    try {
      print(email);
      final response = await _dio.post(
        ApiEndpoints.forgot,
        data: {"email": email},
        options: Options(contentType: Headers.jsonContentType),
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? "Not found");
    }
  }
}
