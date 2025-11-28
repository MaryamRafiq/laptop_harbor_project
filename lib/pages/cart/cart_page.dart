import 'package:flutter/material.dart';
import 'package:laptor_harbor/post/posts.dart';
import 'package:laptor_harbor/services/cart_service.dart';
import '../checkout/checkout_page.dart';

class CartPage extends StatelessWidget {
  CartPage({super.key});

  final CartService _cartService = CartService.instance;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return ValueListenableBuilder<List<Post>>(
      valueListenable: _cartService.cart,
      builder: (context, cartItems, _) {
        final total = cartItems.fold<double>(
          0,
          (sum, post) => sum + post.price * post.quantity,
        );

        return Column(
          children: [
            Expanded(
              child: cartItems.isEmpty
                  ? const Center(child: Text("Cart is empty"))
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final post = cartItems[index];
                        return CartItemCard(
                          image: post.image,
                          name: post.name,
                          spec: post.specification,
                          qty: post.quantity,
                          price: (post.price) ,
                          onRemove: () => _cartService.removeItem(post),
                        );
                      },
                    ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 8,
                    offset: const Offset(0, -3),
                    color: Colors.black.withOpacity(0.08),
                  ),
                ],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      Text(
                        '\$${total}',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primary),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const CheckoutPage()),
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 173, 0, 35),
                              Color.fromARGB(255, 110, 2, 18),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.redAccent.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.lock_outline,
                                color: Colors.white, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Proceed to Checkout',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class CartItemCard extends StatelessWidget {
  final String image;
  final String name;
  final String spec;
  final int qty;
  final double price;
  final VoidCallback? onRemove;

  const CartItemCard(
      {super.key,
      required this.image,
      required this.name,
      required this.spec,
      required this.qty,
      required this.price,
      this.onRemove});

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).cardColor;
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFef4444), Color(0xFFb91c1c)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(1.5),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      image,
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                    ),
                  ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14.5)),

                  const SizedBox(height: 4),

                  Text(spec,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey[600])),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      color: primary.withOpacity(0.08),
                    ),
                    child: Text(
                      'Qty: $qty',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: primary),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('\$${price.toStringAsFixed(0)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 6),
                IconButton(
                  onPressed: onRemove,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.delete_outline,
                      size: 20, color: Colors.redAccent),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
