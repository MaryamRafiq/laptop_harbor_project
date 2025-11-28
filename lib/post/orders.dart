import 'package:laptor_harbor/post/posts.dart';

class OrderModel {
  final String orderId;
  final List<Post> items;
  final double total;
  final String status; // Processing, Shipped, Delivered
  final DateTime createdAt;

  OrderModel({
    required this.orderId,
    required this.items,
    required this.total,
    required this.status,
    required this.createdAt,
  });
}
