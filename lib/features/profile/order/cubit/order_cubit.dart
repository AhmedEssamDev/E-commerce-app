// orders_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/features/profile/order/cubit/order_state.dart';
import 'package:shop/features/profile/order/data/order_model.dart';
import 'package:shop/features/profile/order/data/order_repo.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final OrdersRepo ordersRepo;
  OrdersCubit(this.ordersRepo) : super(OrdersInitial());

  static OrdersCubit get(context) => BlocProvider.of(context);

  OrderModel? orders;

  Future<void> getOrders() async {
    emit(OrdersLoading());
    var result = await ordersRepo.getOrders();
    result.fold(
      (error) => emit(OrdersError(error: error)),
      (data) {orders = data;emit(OrdersSuccess(orders: data));
      },
    );
  }
}