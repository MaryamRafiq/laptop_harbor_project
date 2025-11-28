import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:laptor_harbor/post/posts.dart';
import 'package:laptor_harbor/services/cart_service.dart';
import '../product/product_details_page.dart';

class AccessoriesPage extends StatelessWidget {
  const AccessoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("posts")
          .where("category", isEqualTo: "accessories")
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;

        // Convert each document into a Post object
        final posts = docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;

           final rawPrice = (data['price'] ?? '0').toString();
          final numericPrice = double.tryParse(rawPrice.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0.0;
          return Post(
            image: data['image'] ?? '',
            name: data['name'] ?? '',
            specification: data['specification'] ?? '',
            price: numericPrice,
            rating: (data['rating'] ?? '0').toString(),
            configuration: data['configuration'] ?? '',
            description: data['description'] ?? '',
            category: data['category'] ?? 'accessories',
            quantity: 1, // start with 1
          );
        }).toList();

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: posts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.65,
          ),
          itemBuilder: (context, index) {
            final post = posts[index];

            return AccessoriesCard(
              post: post,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ProductDetailsPage(productName: post.name),
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

class AccessoriesCard extends StatefulWidget {
  final Post post;
  final VoidCallback? onTap;

  const AccessoriesCard({super.key, required this.post, this.onTap});

  @override
  State<AccessoriesCard> createState() => _AccessoriesCardState();
}

class _AccessoriesCardState extends State<AccessoriesCard> {
  bool _pressed = false;
  bool _isFavorite = false;

  void _setPressed(bool value) {
    setState(() {
      _pressed = value;
    });
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

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
              colors: [Color(0xFFfb7185), Color(0xFFf97316)],
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
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: chip + favorite
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        'Accessory',
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
                        color: _isFavorite ? Colors.redAccent : Colors.grey[500],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Image
                Container(
                  height: 76,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.post.image,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 6),

                // Name
                Text(
                  widget.post.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const SizedBox(height: 4),

                // Specs
                Text(
                  widget.post.specification,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                const SizedBox(height: 6),

                // Rating row
                Row(
                  children: [
                    Icon(Icons.star, size: 16, color: Colors.amber.shade700),
                    const SizedBox(width: 4),
                    Text(widget.post.rating, style: const TextStyle(fontSize: 12)),
                    const SizedBox(width: 8),
                    const Text('•', style: TextStyle(fontSize: 12)),
                    const SizedBox(width: 4),
                    const Text('In stock', style: TextStyle(fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 6),

                // Price + Add to cart
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${widget.post.price}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    TextButton.icon(
                      onPressed: () {
                        // ✅ Use singleton instance
                        CartService.instance.addItem(widget.post);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${widget.post.name} added to cart'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      icon: const Icon(Icons.add_shopping_cart_outlined, size: 16),
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
