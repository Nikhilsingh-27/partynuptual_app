import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../../core/network/api_endpoints.dart';
import '../models/home_model.dart';

class HomeService {
  final Dio _dio = DioClient().dio;

  Future<HomeModel> fetchHomeData() async {
    try {
      final Response response = await _dio.get(ApiEndpoints.home);

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
      print(response.data);
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
      print(response.data);
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
      print(response.data);
      return response.data;
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? "Category listing API error");
    }
  }

}
