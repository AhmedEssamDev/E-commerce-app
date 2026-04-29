import 'package:dartz/dartz.dart';
import 'package:shop/core/network/api_helper.dart';
import 'package:shop/core/network/api_response.dart';
import 'package:shop/core/network/end_points.dart';
import 'package:shop/features/auth/login/data/model/user_model.dart';

class UserRepo {
  final APIHelper apiHelper;
  UserRepo({APIHelper? apiHelper}) : apiHelper = apiHelper ?? APIHelper();

  Future<Either<String, UserModel>> getUserData() async {
    try {
      var response = await apiHelper.getRequest(endPoint: EndPoints.userData);
      print('--- User Response : ${response.data}');
      if (response.status) {
        var user = UserModel.fromJson(response.data['user']); // ✅ تصحيح اللينك
        return Right(user);
      } else {
        return Left(response.message);
      }
    } catch (e) {
      return Left(ApiResponse.fromError(e).message);
    }
  }
}