// import 'package:dio/dio.dart';
// import 'package:shop/core/app_router/app_router_keys.dart';
// import 'package:shop/core/cache/cache_helper.dart';
// import 'package:shop/core/cache/cache_keys.dart';
// import 'api_response.dart';
// import 'end_points.dart';

// class APIHelper {
//   // declaring dio
//   static final Dio _dio = Dio(BaseOptions(baseUrl: EndPoints.baseUrl));

//   static Future init() async {
//     _dio.interceptors.add(
//       InterceptorsWrapper(
//         onRequest: (options, handler) async {
//           print("--- Headers : ${options.headers.toString()}");
//           print("--- endpoint : ${options.path.toString()}");
//           final isAuthorized = options.extra['isAuthorized'] ?? true;
//           if (isAuthorized) {
//             options.headers['Authorization'] =
//                 'Bearer ${await CacheHelper.getValue(Cachekeys.accessToken) ?? ''}';
//           }
//           return handler.next(options);
//         },
//         onResponse: (response, handler) {
//           print("--- Response : ${response.data.toString()}");
//           return handler.next(response);
//         },
//         onError: (DioException error, handler) async {
//           print("--- Error : ${error.response?.data.toString()}");
//           var errorResponse = error.response?.data as Map<String, dynamic>;
//           try {
//             if (errorResponse['message'].toString().contains(
//               'Token has expired.',
//             )) {
//               if (error.requestOptions.path.contains('refresh_token')) {
//                 return handler.reject(error);
//               }

//               var result = await _dio.post(
//                 EndPoints.refreshToken,
//                 options: Options(
//                   headers: {
//                     'Authorization':
//                         'Bearer ${await CacheHelper.getValue(Cachekeys.refreshToken)}',
//                   },
//                 ),
//               );
//               var accessData = result.data as Map<String, dynamic>;
//               await CacheHelper.setValue(
//                 Cachekeys.accessToken,
//                 accessData['access_token'],
//               );

//               // Retry original request
//               final options = error.requestOptions;

//               if (options.data is FormData) {
//                 final oldFormData = options.data as FormData;

//                 // Convert FormData to map so it can be rebuilt
//                 final Map<String, dynamic> formMap = {};
//                 for (var entry in oldFormData.fields) {
//                   formMap[entry.key] = entry.value;
//                 }

//                 // Add files if any
//                 for (var file in oldFormData.files) {
//                   formMap[file.key] = file.value;
//                 }

//                 // Rebuild new FormData
//                 options.data = FormData.fromMap(formMap);
//               }
//               options.headers['Authorization'] =
//                   'Bearer ${CacheHelper.getValue(Cachekeys.accessToken) ?? ''}';
//               final response = await _dio.fetch(options);
//               return handler.resolve(response);
//             }
//           } catch (e) {
//             return handler.reject(error);
//           }

//           return handler.next(error);
//         },
//       ),
//     );
//   }

//   // get request

//   Future<ApiResponse> getRequest({
//     required String endPoint,
//     Map<String, dynamic>? queryParams,
//     bool isFormData = true,
//     bool isAuthorized = true,
//   }) async {
//     try {
//       var response = await _dio.get(
//         endPoint,
//         queryParameters: queryParams,
//         options: Options(extra: {'isAuthorized': isAuthorized}),
//       );
//       return ApiResponse.fromResponse(response);
//     } catch (e) {
//       return ApiResponse.fromError(e);
//     }
//   }

//   // post

//   Future<ApiResponse> postRequest({
//     required String endPoint,
//     Map<String, dynamic>? data,
//     bool isFormData = true,
//     bool isAuthorized = true,
//   }) async {
//     try {
//       var response = await _dio.post(
//         endPoint,
//         data:
//             data == null
//                 ? null
//                 : isFormData
//                 ? FormData.fromMap(data)
//                 : data,
//       );
//       return ApiResponse.fromResponse(response);
//     } catch (e) {
//       // ignore: avoid_print
//       return ApiResponse.fromError(e);
//     }
//   }

//   Future<ApiResponse> putRequest({
//     required String endPoint,
//     Map<String, dynamic>? data,
//     bool isFormData = true,
//     bool isAuthorized = true,
//   }) async {
//     try {
//       var response = await _dio.put(
//         endPoint,
//         data:
//             data == null
//                 ? null
//                 : isFormData
//                 ? FormData.fromMap(data)
//                 : data,
//       );
//       return ApiResponse.fromResponse(response);
//     } catch (e) {
//       return ApiResponse.fromError(e);
//     }
//   }

//   Future<ApiResponse> deleteRequest({
//     required String endPoint,
//     Map<String, dynamic>? data,
//     bool isFormData = true,
//     bool isAuthorized = true,
//   }) async {
//     try {
//       var response = await _dio.delete(
//         endPoint,
//         data:
//             data == null
//                 ? null
//                 : isFormData
//                 ? FormData.fromMap(data)
//                 : data,
//       );
//       return ApiResponse.fromResponse(response);
//     } catch (e) {
//       return ApiResponse.fromError(e);
//     }
//   }
// }
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shop/core/app_router/app_router.dart';
import 'package:shop/core/app_router/app_router_keys.dart';
import 'package:shop/core/cache/cache_helper.dart';
import 'package:shop/core/cache/cache_keys.dart';
import 'api_response.dart';
import 'end_points.dart';

class APIHelper {
  static final Dio _dio = Dio(BaseOptions(baseUrl: EndPoints.baseUrl));
  
  // متغير لمنع محاولات التجديد المتزامنة
  static bool _isRefreshing = false;
  
  // قائمة لتخزين الطلبات المعلقة أثناء التجديد
  static final List<_PendingRequest> _pendingRequests = [];

  static Future init() async {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          print("--- endpoint : ${options.path.toString()}");
          print("--- Headers : ${options.headers.toString()}");
          
          final isAuthorized = options.extra['isAuthorized'] ?? true;
          if (isAuthorized) {
            final token = await CacheHelper.getValue(Cachekeys.accessToken);
            if (token != null && token.toString().isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }
          return handler.next(options);
        },
        
        onResponse: (response, handler) {
          print("--- Response : ${response.data.toString()}");
          return handler.next(response);
        },
        
        onError: (DioException error, handler) async {
          print("--- Error : ${error.response?.data.toString()}");
          
          // لو مش خطأ 401 أو مش رسالة "Token has expired"، نكمله عادي
          if (error.response?.statusCode != 401) {
            return handler.next(error);
          }
          
          final errorData = error.response?.data;
          if (errorData == null || 
              !errorData.toString().contains('Token has expired')) {
            return handler.next(error);
          }
          
          print("----- Handle Server Error Token has expired.");
          
          // لو الطلب الحالي هو refresh_token نفسه وفشل
          if (error.requestOptions.path.contains('refresh_token')) {
            print("----- Refresh token itself is expired!");
            // الـ refresh token نفسه منتهي، لازم نعمل تسجيل خروج
            await _forceLogout();
            return handler.reject(error);
          }
          
          // حاول تجديد التوكن
          try {
            // لو في عملية تجديد شغالة بالفعل
            if (_isRefreshing) {
              // خزن الطلب ده عشان نعيده بعد ما التجديد يخلص
              _pendingRequests.add(_PendingRequest(
                options: error.requestOptions,
                handler: handler,
              ));
              return;
            }
            
            _isRefreshing = true;
            
            // نجيب الـ refresh token
            final refreshToken = await CacheHelper.getValue(Cachekeys.refreshToken);
            
            if (refreshToken == null || refreshToken.toString().isEmpty) {
              print("----- لا يوجد refresh token");
              _isRefreshing = false;
              await _forceLogout();
              return handler.reject(error);
            }
            
            print("----- جاري محاولة تجديد التوكن...");
            
            // نعمل طلب تجديد التوكن
            final result = await _dio.post(
              EndPoints.refreshToken,
              options: Options(
                headers: {
                  'Authorization': 'Bearer $refreshToken',
                },
                extra: {'isAuthorized': false}, // مهم عشان مايدخلش في حلقة
              ),
            );
            
            // نجح التجديد
            final accessData = result.data as Map<String, dynamic>;
            final newAccessToken = accessData['access_token'];
            final newRefreshToken = accessData['refresh_token']; // لو بيرجع refresh token جديد
            
            await CacheHelper.setValue(Cachekeys.accessToken, newAccessToken);
            if (newRefreshToken != null) {
              await CacheHelper.setValue(Cachekeys.refreshToken, newRefreshToken);
            }
            
            print("----- تم تجديد التوكن بنجاح");
            
            // إعادة الطلب الأصلي بالتوكن الجديد
            final retryOptions = error.requestOptions;
            retryOptions.headers['Authorization'] = 'Bearer $newAccessToken';
            
            // إعادة بناء FormData لو موجودة
            if (retryOptions.data is FormData) {
              retryOptions.data = _rebuildFormData(retryOptions.data as FormData);
            }
            
            // تنفيذ الطلب الأصلي مرة تانية
            final retryResponse = await _dio.fetch(retryOptions);
            handler.resolve(retryResponse);
            
            // معالجة الطلبات المعلقة
            _processPendingRequests(newAccessToken);
            
          } catch (e) {
            print("----- فشل تجديد التوكن: $e");
            // فشل التجديد، نعمل تسجيل خروج
            await _forceLogout();
            
            // رفض كل الطلبات المعلقة
            _rejectAllPendingRequests(error);
            
            return handler.reject(error);
          } finally {
            _isRefreshing = false;
          }
        },
      ),
    );
  }
  
  // إعادة بناء FormData
  static dynamic _rebuildFormData(FormData oldFormData) {
    final Map<String, dynamic> formMap = {};
    
    for (var entry in oldFormData.fields) {
      formMap[entry.key] = entry.value;
    }
    
    for (var file in oldFormData.files) {
      formMap[file.key] = file.value;
    }
    
    return FormData.fromMap(formMap);
  }
  
  // معالجة الطلبات المعلقة بعد تجديد التوكن
  static Future<void> _processPendingRequests(String newToken) async {
    final pendingRequests = List<_PendingRequest>.from(_pendingRequests);
    _pendingRequests.clear();
    
    for (var pending in pendingRequests) {
      try {
        pending.options.headers['Authorization'] = 'Bearer $newToken';
        
        if (pending.options.data is FormData) {
          pending.options.data = _rebuildFormData(pending.options.data as FormData);
        }
        
        final response = await _dio.fetch(pending.options);
        pending.handler.resolve(response);
      } catch (e) {
        pending.handler.reject(DioException(
          requestOptions: pending.options,
          error: e,
        ));
      }
    }
  }
  
  // رفض كل الطلبات المعلقة
  static void _rejectAllPendingRequests(DioException error) {
    for (var pending in _pendingRequests) {
      pending.handler.reject(error);
    }
    _pendingRequests.clear();
  }
  
  // تسجيل الخروج الإجباري
  static Future<void> _forceLogout() async {
    print("----- جاري تسجيل الخروج...");
    
    // مسح التوكنز
    await CacheHelper.removeValue(Cachekeys.accessToken);
    await CacheHelper.removeValue(Cachekeys.refreshToken);
    
    // التوجيه لصفحة تسجيل الدخول
    if (navigatorKey.currentContext != null) {
      appRouter.go(AppRouterKeys.auth);
    }
  }

  // دوال الطلبات زي ما هي
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

  Future<ApiResponse> postRequest({
    required String endPoint,
    Map<String, dynamic>? data,
    bool isFormData = true,
    bool isAuthorized = true,
  }) async {
    try {
      var response = await _dio.post(
        endPoint,
        data: data == null
            ? null
            : isFormData
                ? FormData.fromMap(data)
                : data,
        options: Options(extra: {'isAuthorized': isAuthorized}),
      );
      return ApiResponse.fromResponse(response);
    } catch (e) {
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
        data: data == null
            ? null
            : isFormData
                ? FormData.fromMap(data)
                : data,
        options: Options(extra: {'isAuthorized': isAuthorized}),
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
        data: data == null
            ? null
            : isFormData
                ? FormData.fromMap(data)
                : data,
        options: Options(extra: {'isAuthorized': isAuthorized}),
      );
      return ApiResponse.fromResponse(response);
    } catch (e) {
      return ApiResponse.fromError(e);
    }
  }
}

// كلاس لتخزين الطلبات المعلقة
class _PendingRequest {
  final RequestOptions options;
  final ErrorInterceptorHandler handler;
  
  _PendingRequest({
    required this.options,
    required this.handler,
  });
}