import 'package:get/get.dart';
import 'package:dio/dio.dart';

import '../../core/network/dio_client.dart';
import '../../core/network/api_endpoints.dart';

class AuthenticationService {
  final Dio _dio = DioClient().dio;

  Future<Map<String,dynamic>>signup({required String username,required String email,required String password,required String role})async{
    try{
      final response = await _dio.post(
        ApiEndpoints.signup,
        data:{
          "username":username,
          "email":email,
          "password":password,
          "user_type":role
        },
      );
      return response.data;
    }on DioException catch(e){
      throw Exception(e.response?.data??"Not found");
    }
  }

  Future<Map<String,dynamic>>loginfun({required String email,required String password,required String role})async{
    try{
      final response = await _dio.post(
        ApiEndpoints.login,
        data:{
          "email":email,
          "password":password,
          "user_type":role
        }
      );
      return response.data;
    }on DioException catch(e){
      throw Exception(e.response?.data??"Not found");
    }

  }

}