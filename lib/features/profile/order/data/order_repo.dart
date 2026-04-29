// orders_repo.dart
import 'package:dartz/dartz.dart';
import 'package:shop/core/network/api_helper.dart';
import 'package:shop/core/network/api_response.dart';
import 'package:shop/core/network/end_points.dart';
import 'package:shop/features/profile/order/data/order_model.dart';

class OrdersRepo {
  final APIHelper apiHelper;
  OrdersRepo({APIHelper? apiHelper}) : apiHelper = apiHelper ?? APIHelper();

  Future<Either<String, OrderModel>> getOrders() async {
    try {
      var response = await apiHelper.getRequest(
        endPoint: EndPoints.getOrders,
      );
      if (response.status) {
        var ordersResponse = OrdersResponseModel.fromJson(response.data);
        return Right(ordersResponse.orders!);
      } else {
        return Left(response.message);
      }
    } catch (e) {
      return Left(ApiResponse.fromError(e).message);
    }
  }
}