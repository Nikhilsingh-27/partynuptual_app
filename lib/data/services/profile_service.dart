import 'dart:io';

import 'package:dio/dio.dart' as dio;

import 'package:get/get.dart';

import '../../core/network/dio_client.dart';
import '../../core/network/api_endpoints.dart';

class ProfileService {
  final _dio = DioClient().dio;

  Future<Map<String, dynamic>> getuserdetailsfun({required String id}) async {
    try {
      final response = await _dio.get(
          "${ApiEndpoints.getuser}/$id"
      );
      print(response.data);
      return response.data;
    } on dio.DioException catch (e) {
      throw Exception(e.response?.data ?? "Api error");
    }
  }

  Future<Map<String, dynamic>> updateInfo({
    required String userId,
    required String firstName,
    required String lastName,
    required String gender,
    required String address,
    required String zipCode,
    required String email,
    required String phone
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
          "phone": phone
        },
        options: dio.Options(
          contentType: dio.Headers.jsonContentType,
        ),
      );

      return response.data;
    } on dio.DioException catch (e) {
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
          options: dio.Options(
              contentType: dio.Headers.jsonContentType
          )
      );
      return response.data;
    } on dio.DioException catch (e) {
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
        options: dio.Options(
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
    } on dio.DioException catch (e) {
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

      return response.data;
    } on dio.DioException catch (e) {
      throw Exception(e.response?.data ?? "Failed to submit review");
    }
  }


  Future<Map<String, dynamic>> getinquiry({required String id}) async {
    try {
      final response = await _dio.get(
          "${ApiEndpoints.getinquiry}/$id"
      );
      print(response.data);
      return response.data;
    } on dio.DioException catch (e) {
      throw Exception(e.response?.data ?? "Api Error");
    }
  }

  Future<Map<String, dynamic>> getmyideafun({required String id}) async {
    try {
      final response = await _dio.get(
          "${ApiEndpoints.getmyidea}/$id"
      );
      print(response.data);
      return response.data;
    } on dio.DioException catch (e) {
      throw Exception(e.response?.data ?? "Api Error");
    }
  }

  Future<Map<String, dynamic>> sendinquiry({
    required String name,
    required String email,
    required String phone,
    required String message,
    required String listing_id,
    required String vendor_id,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.sendinquiry,
        data: {
          "name": name,
          "email": email,
          "phone": phone,
          "message": message,
          "listing_id": listing_id,
          "vendor_id": vendor_id,
        },
      );
      print(response.data);
      // Dio returns response.data directly
      return response.data;
    } on dio.DioException catch (e) {
      return {
        "status": "error",
        "message": e.response?.data?["message"] ??
            e.message ??
            "Something went wrong",
      };
    } catch (e) {
      return {
        "status": "error",
        "message": e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> updateimage({
    required String userId,
    required File imageFile,
  }) async {
    try {
      final fileName = imageFile.path.split('/').last;

      final dio.FormData formData = dio.FormData();

      // ✅ Add normal form field
      formData.fields.add(
        MapEntry('user_id', userId),
      );

      // ✅ Add file
      formData.files.add(
        MapEntry(
          'profile_image',
          await dio.MultipartFile.fromFile(
            imageFile.path,
            filename: fileName,
          ),
        ),
      );

      final response = await _dio.post(
        ApiEndpoints.updateimage,
        data: formData,
        options: dio.Options(
          headers: {
            "Accept": "application/json",
          },

        ),
      );

      print('Response: ${response.data}');
      return Map<String, dynamic>.from(response.data);
    } on dio.DioException catch (e) {
      throw Exception(e.response?.data ?? "Api Error");
    }
  }

}