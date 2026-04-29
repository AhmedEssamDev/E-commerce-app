class OrdersResponseModel {
  final OrderModel? orders;

  OrdersResponseModel({this.orders});

  factory OrdersResponseModel.fromJson(Map<String, dynamic> json) {
    return OrdersResponseModel(
      orders: OrderModel.fromJson(json['orders']),
    );
  }
}

class OrderModel {
  final List<dynamic>? active;
  final List<dynamic>? canceled;
  final List<dynamic>? completed;

  OrderModel({this.active, this.canceled, this.completed});

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      active: json['active'] ?? [],
      canceled: json['canceled'] ?? [],
      completed: json['completed'] ?? [],
    );
  }
}