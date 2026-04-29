import 'package:dartz/dartz.dart';
import 'package:shop/core/network/api_helper.dart';
import 'package:shop/core/network/api_response.dart';
import 'package:shop/core/network/end_points.dart';

class RegisterRepo {
  APIHelper apiHelper = APIHelper();
Future<Either<String,String>> register({
 required String name,
 required String phone,
 required String email,
 required String password}) async {
   try {
     var response = await apiHelper.postRequest(endPoint: EndPoints.register,
     data: 
     {
     'name': name,
     'phone': phone,
     'email': email,
     'password': password,
   });
       if(response.status){
        return Right(response.message);
      }else{
        return Left(response.message);
      }
   } catch (e) {
     return Left(ApiResponse.fromError(e).message);
   }
 }
}