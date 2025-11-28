import 'package:laptor_harbor/post/orders.dart';

class OrderService {
  static final OrderService instance = OrderService._internal();
  OrderService._internal();

  final List<OrderModel> _orders = [];

  List<OrderModel> get orders => _orders;

  void addOrder(OrderModel order) {
    _orders.insert(0, order); // latest first
  }
}
