import 'package:dio/dio.dart';

class DioHelper {
  static Dio? dio;

  static init() {
    dio = Dio(
      BaseOptions(
        // baseUrl: 'http://api.alquran.cloud/v1',
        baseUrl: 'https://api.quran.com/api/v4',
        receiveDataWhenStatusError: true,
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
  }

  static Future<Response> getData(
      {required String url, Map<String, dynamic>? query}) async {
    return await dio!.get(
      url,
      queryParameters: query,
    );
  }
}
