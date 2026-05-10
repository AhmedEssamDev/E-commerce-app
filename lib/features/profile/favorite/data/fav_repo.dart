import 'package:dartz/dartz.dart';
import 'package:shop/core/network/api_helper.dart';
import 'package:shop/core/network/api_response.dart';
import 'package:shop/core/network/end_points.dart';

class FavRepo {
  final APIHelper apiHelper;
  FavRepo({APIHelper? apiHelper}) : apiHelper = apiHelper ?? APIHelper();

  Future<Either<String, String>> addToFavorite(int productId) async {
    try {
      var response = await apiHelper.postRequest(
        endPoint: EndPoints.addToFavorite,
        data: {'product_id': productId},
      );
      print('--- Add to Favorite Response : ${response.data}');
      if (response.status) {
        return Right(response.message);
      } else {
        return Left(response.message);
      }
    } catch (e) {
      return Left(ApiResponse.fromError(e).message);
    }
  }
}