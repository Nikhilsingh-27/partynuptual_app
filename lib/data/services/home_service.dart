import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../core/network/dio_client.dart';
import '../../core/network/api_endpoints.dart';
import '../models/home_model.dart';

class HomeService {
  final Dio _dio = DioClient().dio;

  Future<HomeModel> fetchHomeData() async {
    try {
      final response = await _dio.get(ApiEndpoints.home);

      return HomeModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? "API Error");
    }
  }
  Future<Map<String, dynamic>> contactus({
    required String name,
    required String email,
    required String phone,
    required String subject,
    required String message,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.contactus,
        data: {
          "name": name,
          "email": email,
          "phone": phone,
          "subject": subject,
          "message": message,
        },
        options: Options(
          contentType: Headers.jsonContentType,
        ),
      );

      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? "Contact API Error");
    }
  }

  Future<Map<String,dynamic>> subscribefun({required String email})async{
    try{
      final response = await _dio.post(
        ApiEndpoints.subscribe,
        data:{
          "email":email,
        },
        options:Options(
          contentType:Headers.jsonContentType,
        )
      );

      return response.data;
    }on DioException catch(e){
      throw Exception(e.response?.data??"subscribe API Error");
    }
  }

  Future<Map<String, dynamic>> categoryShowById({
    required int categoryId,
    required int page,
    required int limit,
  }) async {
    try {
      final response = await _dio.get(
        "${ApiEndpoints.categoryid}/$categoryId",
        queryParameters: {
          "page": page,
          "limit": limit,
        },
      );
      // print(response.data);
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? "Category listing API error");
    }
  }
  Future<Map<String, dynamic>> shareideasfun({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await _dio.get(
        "${ApiEndpoints.ideas}",
        queryParameters: {
          "page": page,
          "limit": limit,
        },
      );
      // print(response.data);
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? "Category listing API error");
    }
  }
  Future<Map<String, dynamic>> blogsfun({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await _dio.get(
        "${ApiEndpoints.blogs}",
        queryParameters: {
          "page": page,
          "limit": limit,
        },
      );
      // print(response.data);
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? "Category listing API error");
    }
  }

  Future<Map<String,dynamic>>getstates({required int id})async{
    try{
      final response = await _dio.get(
        "${ApiEndpoints.states}/$id"
      );
      // print(response.data);
      return response.data;
    } on DioException catch(e){
      throw Exception(e.response?.data??"State not Found");
    }
  }

  Future<Map<String,dynamic>>getvideos()async{
    try{
      final response = await _dio.get(
        ApiEndpoints.videos
      );
      //print(response.data);
      return response.data;
    } on DioException catch(e){
      throw Exception(e.response?.data??"vido not Found");
    }
  }

  Future<Map<String,dynamic>>getlistingbyid({required String id})async{
    try{
      final response = await _dio.get(
        "${ApiEndpoints.listing}/$id"
      );

      return response.data;
    }on DioException catch(e){
      throw Exception(e.response?.data??"Not found");
    }
  }

  Future<Map<String,dynamic>>gallerybyid({required String id})async{
    try{
      final response = await _dio.get(
        "${ApiEndpoints.gallery}/$id"
      );
      print(response.data);
      return response.data;
    }on DioException catch(e){
      throw Exception(e.response?.data??"Not found");
    }
  }
  
  
  

}
