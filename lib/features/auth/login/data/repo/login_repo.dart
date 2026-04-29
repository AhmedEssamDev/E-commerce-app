import 'package:dartz/dartz.dart';
import 'package:shop/core/cache/cache_helper.dart';
import 'package:shop/core/cache/cache_keys.dart';
import 'package:shop/core/network/api_helper.dart';
import 'package:shop/core/network/api_response.dart';
import 'package:shop/core/network/end_points.dart';
import 'package:shop/features/auth/login/data/model/login_response_model.dart';
import 'package:shop/features/auth/login/data/model/user_model.dart';

class LoginRepo {
  APIHelper apiHelper = APIHelper();
 Future<Either<String, UserModel>> login({required String email, required String password}) async {
    try {
      var response = await apiHelper.postRequest(
        endPoint: EndPoints.login,
        data: {
          'email': email,
          'password': password,
        },   
      );
      if(response.status){
        var loginResponse = LoginResponseModel.fromJson(response.data as Map<String, dynamic>);
      await CacheHelper.setValue(
            Cachekeys.accessToken, loginResponse.accessToken!);
        await CacheHelper.setValue(
            Cachekeys.refreshToken, loginResponse.refreshToken!);

        return Right(loginResponse.userModel!);
      }else{
        return Left(response.message);
      }
    } catch (e) {
      return Left(ApiResponse.fromError(e).message);
    }
 }
 }