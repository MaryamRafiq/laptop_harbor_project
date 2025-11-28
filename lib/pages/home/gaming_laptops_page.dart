import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:laptor_harbor/post/posts.dart';
import 'package:laptor_harbor/services/cart_service.dart';
import '../product/product_details_page.dart';

class GamingLaptopsPage extends StatelessWidget {
  const GamingLaptopsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("posts")
          .where("category", isEqualTo: "gaming")
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: docs.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.7,
          ),
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final priceValue = (data['price'] ?? 0)
                .toDouble(); // Firestore → double safely

            return GamingLaptopCard(
              image: data['image'] ?? '',
              name: data['name'] ?? '',
              spec: data['specification'] ?? '',
              price: priceValue,
              rating: (data['rating'] ?? '0').toString(),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ProductDetailsPage(productName: data['name']),
                  ),
                );
              },
              onAddToCart: () {
                final post = Post(
                  name: data['name'] ?? '',
                  specification: data['specification'] ?? '',
                  price: priceValue,
                  rating: (data['rating'] ?? '0').toString(),
                  image: data['image'] ?? '',
                  configuration: data['configuration'] ?? '',
                  description: data['description'] ?? '',
                  category: data['category'] ?? 'gaming',
                  quantity: 1,
                );

                CartService.instance.addItem(post);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${data['name']} added to cart'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class GamingLaptopCard extends StatefulWidget {
  final String name;
  final String spec;
  final double price; // now double
  final String rating;
  final String image;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;

  const GamingLaptopCard({
    super.key,
    required this.name,
    required this.spec,
    required this.price,
    required this.rating,
    required this.image,
    this.onTap,
    this.onAddToCart,
  });

  @override
  State<GamingLaptopCard> createState() => _GamingLaptopCardState();
}

class _GamingLaptopCardState extends State<GamingLaptopCard> {
  bool _pressed = false;
  bool _isFavorite = false;

  void _setPressed(bool value) => setState(() => _pressed = value);
  void _toggleFavorite() => setState(() => _isFavorite = !_isFavorite);

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).cardColor;

    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFec4899), Color(0xFF6366f1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(1.5),
          child: Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Top row: chip + heart
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        'Gaming',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _toggleFavorite,
                      child: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        size: 18,
                        color: _isFavorite
                            ? Colors.redAccent
                            : Colors.grey[500],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                /// Image area
                Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.image,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.broken_image,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                /// Name
                Text(
                  widget.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 4),

                /// Specs
                Text(
                  widget.spec,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),

                const SizedBox(height: 8),

                /// Rating row
                Row(
                  children: [
                    Icon(Icons.star, size: 16, color: Colors.amber.shade700),
                    const SizedBox(width: 4),
                    Text(widget.rating, style: const TextStyle(fontSize: 12)),
                    const SizedBox(width: 8),
                    const Text('•', style: TextStyle(fontSize: 12)),
                    const SizedBox(width: 4),
                    const Text('Free shipping', style: TextStyle(fontSize: 11)),
                  ],
                ),

                const SizedBox(height: 6),

                /// Price + Add to cart button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${widget.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: widget.onAddToCart,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      icon: const Icon(
                        Icons.add_shopping_cart_outlined,
                        size: 16,
                      ),
                      label: const Text('Add', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
