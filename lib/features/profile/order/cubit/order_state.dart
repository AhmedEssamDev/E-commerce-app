import 'package:shop/features/profile/order/data/order_model.dart';

abstract class OrdersState {}

class OrdersInitial extends OrdersState {}

class OrdersLoading extends OrdersState {}

class OrdersSuccess extends OrdersState {
  final OrderModel orders;
  OrdersSuccess({required this.orders});
}

class OrdersError extends OrdersState {
  final String error;
  OrdersError({required this.error});
}