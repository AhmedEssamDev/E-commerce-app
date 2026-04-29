import 'package:dartz/dartz.dart';
import 'package:shop/core/network/api_helper.dart';
import 'package:shop/core/network/api_response.dart';
import 'package:shop/core/network/end_points.dart';
import 'package:shop/features/home/data/models/category_model.dart';
import 'package:shop/features/home/data/models/sliders_model.dart';

class HomeRepo {
  APIHelper apiHelper = APIHelper();
  Future<Either<String, List<CategoryModel>>> getCategories() async {
   try {
     var response = await apiHelper.getRequest
     (endPoint: EndPoints.categories);
     if (response.status) {
       var categoriesResponse = CategoriesResponseModel.fromJson(response.data);
       return Right(categoriesResponse.categories!);
     } else {
       return Left(response.message);
     }
   } catch (e) {
     return Left(ApiResponse.fromError(e).message);
   }
 }
}
  class SlidersRepo {
  final APIHelper apiHelper;
  SlidersRepo({APIHelper? apiHelper}) : apiHelper = apiHelper ?? APIHelper();

  Future<Either<String, List<SliderModel>>> getSliders() async {
    try {
      var response = await apiHelper.getRequest(
        endPoint: EndPoints.getSliders,
      );
      if (response.status) {
        var slidersResponse = SlidersResponseModel.fromJson(response.data);
        return Right(slidersResponse.sliders!);
      } else {
        return Left(response.message);
      }
    } catch (e) {
      return Left(ApiResponse.fromError(e).message);
    }
  }
}