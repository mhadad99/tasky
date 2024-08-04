import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;
  static init() {
    dio = Dio(BaseOptions(
        baseUrl: 'https://todo.iraqsapp.com',
        receiveDataWhenStatusError: true,
        headers: {
          "Content-Type": "application/json",
        }));
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    dio.options.headers = {
      'Content-Type': ' application / json',
      'Authorization': (token != null) ? 'Bearer $token' : 'Bearer ',
    };
    return await dio.get(
      url,
      queryParameters: query,
    );
  }

  static Future<Response> postData({
    required String url,
    Map<String, dynamic>? query,
    required Map<String, dynamic> data,
    String? token,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': (token != null) ? 'Bearer $token' : 'Bearer ',
    };
    return await dio.post(
      url,
      queryParameters: query,
      data: data,
    );
  }

  Future<void> fetchData() async {
    try {
      Response response = await dio.get('/path/to/your/endpoint');
      print(response.data);
    } on DioException catch (e) {
      print(e.message);
    }
  }
}
