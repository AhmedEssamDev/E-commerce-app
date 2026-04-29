import 'package:dio/dio.dart';
import 'package:shop/core/cache/cache_helper.dart';
import 'package:shop/core/cache/cache_keys.dart';
import 'api_response.dart';
import 'end_points.dart';

class APIHelper {
  // declaring dio
  static final Dio _dio = Dio(BaseOptions(baseUrl: EndPoints.baseUrl));

  static Future init() async {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          print("--- Headers : ${options.headers.toString()}");
          print("--- endpoint : ${options.path.toString()}");
          final isAuthorized = options.extra['isAuthorized'] ?? true;
          if (isAuthorized) {
            options.headers['Authorization'] =
                'Bearer ${await CacheHelper.getValue(Cachekeys.accessToken) ?? ''}';
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print("--- Response : ${response.data.toString()}");
          return handler.next(response);
        },
        onError: (DioException error, handler) async {
          print("--- Error : ${error.response?.data.toString()}");
          var errorResponse = error.response?.data as Map<String, dynamic>;
          try {
            if (errorResponse['message'].toString().contains(
              'Token has expired.',
            )) {
              if (error.requestOptions.path.contains('refresh_token')) {
                return handler.reject(error);
              }

              var result = await _dio.post(
                EndPoints.refreshToken,
                options: Options(
                  headers: {
                    'Authorization':
                        'Bearer ${await CacheHelper.getValue(Cachekeys.refreshToken)}',
                  },
                ),
              );
              var accessData = result.data as Map<String, dynamic>;
              await CacheHelper.setValue(
                Cachekeys.accessToken,
                accessData['access_token'],
              );

              // Retry original request
              final options = error.requestOptions;

              if (options.data is FormData) {
                final oldFormData = options.data as FormData;

                // Convert FormData to map so it can be rebuilt
                final Map<String, dynamic> formMap = {};
                for (var entry in oldFormData.fields) {
                  formMap[entry.key] = entry.value;
                }

                // Add files if any
                for (var file in oldFormData.files) {
                  formMap[file.key] = file.value;
                }

                // Rebuild new FormData
                options.data = FormData.fromMap(formMap);
              }
              options.headers['Authorization'] =
                  'Bearer ${CacheHelper.getValue(Cachekeys.accessToken) ?? ''}';
              final response = await _dio.fetch(options);
              return handler.resolve(response);
            }
          } catch (e) {
            return handler.reject(error);
          }

          return handler.next(error);
        },
      ),
    );
  }

  // get request

  Future<ApiResponse> getRequest({
    required String endPoint,
    Map<String, dynamic>? queryParams,
    bool isFormData = true,
    bool isAuthorized = true,
  }) async {
    try {
      var response = await _dio.get(
        endPoint,
        queryParameters: queryParams,
        options: Options(extra: {'isAuthorized': isAuthorized}),
      );
      return ApiResponse.fromResponse(response);
    } catch (e) {
      return ApiResponse.fromError(e);
    }
  }

  // post

  Future<ApiResponse> postRequest({
    required String endPoint,
    Map<String, dynamic>? data,
    bool isFormData = true,
    bool isAuthorized = true,
  }) async {
    try {
      var response = await _dio.post(
        endPoint,
        data:
            data == null
                ? null
                : isFormData
                ? FormData.fromMap(data)
                : data,
      );
      return ApiResponse.fromResponse(response);
    } catch (e) {
      // ignore: avoid_print
      return ApiResponse.fromError(e);
    }
  }

  Future<ApiResponse> putRequest({
    required String endPoint,
    Map<String, dynamic>? data,
    bool isFormData = true,
    bool isAuthorized = true,
  }) async {
    try {
      var response = await _dio.put(
        endPoint,
        data:
            data == null
                ? null
                : isFormData
                ? FormData.fromMap(data)
                : data,
      );
      return ApiResponse.fromResponse(response);
    } catch (e) {
      return ApiResponse.fromError(e);
    }
  }

  Future<ApiResponse> deleteRequest({
    required String endPoint,
    Map<String, dynamic>? data,
    bool isFormData = true,
    bool isAuthorized = true,
  }) async {
    try {
      var response = await _dio.delete(
        endPoint,
        data:
            data == null
                ? null
                : isFormData
                ? FormData.fromMap(data)
                : data,
      );
      return ApiResponse.fromResponse(response);
    } catch (e) {
      return ApiResponse.fromError(e);
    }
  }
}
