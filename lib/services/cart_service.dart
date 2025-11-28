import 'package:flutter/material.dart';
import 'package:laptor_harbor/post/posts.dart';

class CartService {
  // -------- SINGLETON --------
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  static CartService get instance => _instance;

  // Using ValueNotifier instead of StreamController
  final ValueNotifier<List<Post>> cart = ValueNotifier<List<Post>>([]);

  void addItem(Post post) {
    final index = cart.value.indexWhere((p) => p.name == post.name);

    if (index >= 0) {
      cart.value[index] = Post(
        image: post.image,
        name: post.name,
        specification: post.specification,
        price: post.price,
        rating: post.rating,
        configuration: post.configuration,
        description: post.description,
        category: post.category,
        quantity: cart.value[index].quantity + 1,
      );
    } else {
      cart.value.add(post);
    }

    cart.notifyListeners();
  }

  void removeItem(Post post) {
    cart.value.removeWhere((p) => p.name == post.name);
    cart.notifyListeners();
  }

  List<Post> getCartItems() => List.from(cart.value);
}
