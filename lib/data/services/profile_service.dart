import 'package:get/get.dart';
import 'package:dio/dio.dart';

import '../../core/network/dio_client.dart';
import '../../core/network/api_endpoints.dart';

class ProfileService {
  final Dio _dio = DioClient().dio;

  Future<Map<String, dynamic>> updateInfo({
    required String userId,
    required String firstName,
    required String lastName,
    required String gender,
    required String address,
    required String zipCode,
    required String email,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.updagteinfo,
        data: {
          "user_id": userId,
          "first_name": firstName,
          "last_name": lastName,
          "gender": gender,
          "address": address,
          "zip_code": zipCode,
          "email": email,
        },
        options: Options(
          contentType: Headers.jsonContentType,
        ),
      );

      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? "API Error");
    }
  }

  Future<Map<String, dynamic>> updatepasswordfun({required String user_id,
    required String old_password, required String new_password}) async {
    try {
      final response = await _dio.post(
          ApiEndpoints.updatepassword,
          data: {
            "user_id": user_id,
            "old_password": old_password,
            "new_password": new_password
          },
          options: Options(
              contentType: Headers.jsonContentType
          )
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? "Api Error");
    }
  }

  Future<Map<String, dynamic>> updateimage({required String user_id,
    required String profile_image}) async {
    try {
      print("oo");
      print(user_id);
      print(profile_image);
      final response = await _dio.post(
          ApiEndpoints.updateimage,
          data: {
            "user_id": user_id,
            "profile_image": profile_image
          },
          options: Options(
              contentType: Headers.jsonContentType
          )
      );
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? "Api Error");
    }
  }

  Future<Map<String, dynamic>> deleteAccountfun({required String id}) async {
    try {
      print(id);
      final response = await _dio.post(
        ApiEndpoints.deleteaccount,
        data: {
          "user_id": id,
        },
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "User-Agent":
            "Mozilla/5.0 (Linux; Android 13; Mobile) AppleWebKit/537.36 Chrome/120.0",
            "Accept": "application/json",
          },
        ),
      );

      print(response.data);
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? "Api Error");
    }
  }
  Future<Map<String, dynamic>> addReviewFun({
    required String vendorId,
    required String listingId,
    required String rating,
    required String review,
    required String name,
    required String email,
    required String phone,
    required String userId,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.addreview,
        data: {
          "vendor_id": vendorId,
          "listing_id": listingId,
          "rating": rating,
          "review": review,
          "name": name,
          "email": email,
          "phone": phone,
          "user_id": userId,
        },
      );
      print(response.data);
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? "Failed to submit review");
    }
  }

}

