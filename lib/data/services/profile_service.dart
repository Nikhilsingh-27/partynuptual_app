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
      print('Deleting account for user: $id');

      // ✅ CHANGE: Call YOUR backend instead of partynuptual directly
      // Your backend then proxies the request, bypassing the firewall
      final response = await _dio.post(
        "https://partynuptual.com/api/delete_account",
        // Use your own backend endpoint
        data: {
          "user_id": id,
        },
        options: dio.Options(
          contentType: dio.Headers.jsonContentType,
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
        ),
      );

      print('Delete response: ${response.data}');

      // ✅ Validate response
      if (response.data is! Map) {
        throw Exception('Invalid response format');
      }

      return Map<String, dynamic>.from(response.data);
    } on dio.DioException catch (e) {
      print('DioException: ${e.message}');
      print('Status code: ${e.response?.statusCode}');
      print('Response error: ${e.response?.data}');
      throw Exception(e.response?.data?['message'] ?? e.message ?? "Api Error");
    } catch (e) {
      print('Error: $e');
      throw Exception(e.toString());
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
      // ✅ Validate file exists
      if (!imageFile.existsSync()) {
        throw Exception('Image file not found');
      }

      final fileName = imageFile.path
          .split('/')
          .last;
      print('Uploading image: $fileName for user: $userId');

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
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
        ),
      );

      print('Response: ${response.data}');

      // ✅ Validate response
      if (response.data is! Map) {
        throw Exception('Invalid response format');
      }

      return Map<String, dynamic>.from(response.data);
    } on dio.DioException catch (e) {
      print('DioException: ${e.message}');
      print('Response error: ${e.response?.data}');
      throw Exception(e.response?.data?['message'] ?? e.message ?? "Api Error");
    } catch (e) {
      print('Error: $e');
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> likedislikefun({
    required String user_id,
    required String idea_id,
    required String action,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.likedislike,
        data: {
          "user_id": user_id,
          "idea_id": idea_id,
          "action": action,
        },
        options: dio.Options(
          contentType: dio.Headers.jsonContentType,
        ),
      );
      print(response.data);
      return response.data;
    } on dio.DioException catch (e) {
      throw Exception(e.response?.data ?? "API Error");
    }
  }

  Future<Map<String, dynamic>> submitideafun({
    required String party_theme,
    required String venue,
    required String description,
    required String user_id,
    required File image,
  }) async {
    try {
      final dio.FormData formData = dio.FormData();

      formData.fields.addAll([
        MapEntry("party_theme", party_theme),
        MapEntry("venue", venue),
        MapEntry("description", description),
        MapEntry("user_id", user_id),
      ]);

      formData.files.add(
        MapEntry(
          "main_image",
          await dio.MultipartFile.fromFile(
            image.path,
            filename: image.path
                .split('/')
                .last,
          ),
        ),
      );

      final response = await _dio.post(
        ApiEndpoints.submitIdea,
        data: formData,
        options: dio.Options(
          contentType: dio.Headers.multipartFormDataContentType,
        ),
      );

      return response.data;
    } on dio.DioException catch (e) {
      throw Exception(e.response?.data ?? "API Error");
    }
  }

  Future<Map<String, dynamic>> getsingleidea({
    required String idea_id,
    required String user_id,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.getSingleIdea,
        data: {
          "idea_id": idea_id,
          "user_id": user_id,
        },
        options: dio.Options(
          contentType: dio.Headers.jsonContentType,
        ),
      );

      print(response.data);
      return response.data;
    } on dio.DioException catch (e) {
      throw Exception(e.response?.data ?? "API Error");
    }
  }

  Future<Map<String, dynamic>> editmyidea({
    required String party_theme,
    required String venue,
    required String description,
    required String user_id,
    File? image,                 // 👈 optional for edit
    required String idea_id,
  }) async {
    try {
      final dio.FormData formData = dio.FormData();

      // 🔹 Text fields
      formData.fields.addAll([
        MapEntry("party_theme", party_theme),
        MapEntry("venue", venue),
        MapEntry("description", description),
        MapEntry("user_id", user_id),
        MapEntry("idea_id", idea_id),
      ]);


      if (image != null) {
        formData.files.add(
          MapEntry(
            "main_image",
            await dio.MultipartFile.fromFile(
              image.path,
              filename: image.path.split('/').last,
            ),
          ),
        );
      }

      final response = await _dio.post(
        ApiEndpoints.editIdea, // 🔥 your edit API endpoint
        data: formData,
        options: dio.Options(
          contentType: dio.Headers.multipartFormDataContentType,
        ),
      );

      print(response.data);
      return response.data;
    } on dio.DioException catch (e) {
      throw Exception(e.response?.data ?? "API Error");
    }
  }

  Future<Map<String,dynamic>>deleteideafun({
    required String idea_id,
    required String user_id,
})async{

      try{
        final response=await _dio.post(
          ApiEndpoints.deleteIdea,
          data: {
            "idea_id":idea_id,
            "user_id":user_id,
          },
          options: dio.Options(
            contentType: dio.Headers.jsonContentType,
          ),
        );
        print(response.data);
        return response.data;
      }on dio.DioException catch(e){
        throw Exception(e.response?.data ?? "API Error");
      }
  }

  Future<Map<String, dynamic>> getpartythemesfun() async {
    try{
      final response = await _dio.get(
        ApiEndpoints.getpartythemes,
      );
      print(response.data);
      return response.data;
    }on dio.DioException catch(e){
      throw Exception(e.response?.data ?? "API Error");
    }
  }


  Future<Map<String,dynamic>>addlistingfun(
      {
        required String userId,
        required String categoryId,
        required String companyName,
        required String email,
        required String phoneNumber,
        required String officeAddress,
        required String tagLine,
        required String countryId,
        required String state,
        required String aboutCompany,
        required String image,
        required String latitude,      // ✅ ADD THIS
        required String longitude,
      }
      )async{

    try{
      print(image);
      final response = await _dio.post(
        ApiEndpoints.addListing,
        data:{
          "user_id":userId,
          "category_id":categoryId,
          "company_name":companyName,
          "email":email,
          "phone_number":phoneNumber,
          "office_address":officeAddress,
          "tag_line":tagLine,
          "country_id":countryId,
          "state":state,
          "about_company":aboutCompany,
          "image":image,
          "latitude":latitude,
          "longitude":longitude
        },
        options: dio.Options(
          contentType: dio.Headers.jsonContentType,
        ),

      );
      return response.data;
    }on dio.DioException catch(e){
      throw Exception(e.response?.data ?? "API Error");
    }
  }


  Future<Map<String, dynamic>> getmylistingfun({required String id}) async {
    try {
      final response = await _dio.get(
          "${ApiEndpoints.getmylistings}/$id"
      );
      print(response.data);
      return response.data;
    } on dio.DioException catch (e) {
      throw Exception(e.response?.data ?? "Api error");
    }
  }

  Future<Map<String,dynamic>>deletelistingfun({required String id})async{
    try{
      final response = await _dio.get(
        "${ApiEndpoints.deletelisting}/$id"
      );
      return response.data;
    }on dio.DioException catch(e){
      throw Exception(e.response?.data??"Api error");
    }
  }




}



