import 'package:dio/dio.dart';
import 'api_endpoints.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;

  late Dio dio;

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          "Content-Type": "application/json",
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print("➡️ Request: ${options.uri}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print("✅ Response: ${response.statusCode}");
          return handler.next(response);
        },
        onError: (error, handler) {
          print("❌ Error: ${error.message}");
          return handler.next(error);
        },
      ),
    );
  }
}
