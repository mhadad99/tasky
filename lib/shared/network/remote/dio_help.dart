import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:todo_app_task/shared/components/constants.dart';
import 'package:todo_app_task/shared/network/local/cache.dart';
import 'package:todo_app_task/shared/network/remote/end_points.dart';

class DioHelp {
  static late Dio dio;

  static dioInit() {
    dio = Dio(BaseOptions(
      baseUrl: 'https://todo.iraqsapp.com',
      contentType: 'application/json',
    ));
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        options.headers['Accept'] = '*/*';

        accessToken = CacheHelper.getData(key: 'access_token') ?? '';
        options.headers['Authorization'] = 'Bearer $accessToken';
        return handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          final newAccessToken = await refreshTokenFun();
          if (newAccessToken != null) {
            dio.options.headers['Authorization'] = 'Bearer $newAccessToken';
            return handler.resolve(await dio.fetch(error.requestOptions));
          }
        }
        if (error.type == DioExceptionType.connectionError) {
          return handler.next(error);
        }

        return handler.next(error);
      },
    ));
  }

  static Future<String?> refreshTokenFun() async {
    try {
      refreshToken = CacheHelper.getData(key: 'refresh_token');
      final response = await dio.get(
        '${REFRESH_TOKEN}token=$refreshToken',
      );
      final newAccessToken = response.data['access_token'];
      CacheHelper.saveData(key: 'access_token', value: newAccessToken);
      return newAccessToken;
    } catch (exception) {
      CacheHelper.removeData(key: 'access_token');
    }
    return null;
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
  }) async {
    return await dio.get(
      url,
      queryParameters: query,
    );
  }

  static Future<Response> postData({
    required String url,
    Map<String, dynamic>? query,
    required Map<String, dynamic> data,
  }) async {
    dio.options.headers = {
      'Content-Type': 'application/json',
    };
    Response response = await dio.post(
      url,
      queryParameters: query,
      data: data,
    );
    return response;
  }

  static Future<Response> uploadImage(XFile image) async {
    Response response;
    String fileName = image.path.split('/').last;
    String mimeType = lookupMimeType(image.path) ?? 'application/octet-stream';
    FormData formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(
        image.path,
        filename: fileName,
        contentType: MediaType.parse(mimeType),
      ),
    });
    response = await dio.post(UPLOAD_IMAGE,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ));
    return response;
  }

  static Future<Response> deleteData({
    required String url,
  }) async {
    return await dio.delete(
      url,
    );
  }

  static Future<Response> putData({
    required String url,
    required Map<String, dynamic> data,
  }) async {
    return await dio.put(
      url,
      data: data,
    );
  }
}
