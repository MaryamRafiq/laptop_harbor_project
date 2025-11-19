import 'package:flutter/material.dart';
import '../product/product_details_page.dart';

class AccessoriesPage extends StatelessWidget {
  const AccessoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> accessories = [
      {
        'name': 'Logitech Wireless Mouse',
        'spec': '2.4 GHz • Silent clicks',
        'price': '\$39',
        'rating': 4.6,
      },
      {
        'name': 'Mechanical Keyboard RGB',
        'spec': 'Blue Switches • RGB',
        'price': '\$89',
        'rating': 4.7,
      },
      {
        'name': 'Gaming Headset Pro',
        'spec': '7.1 Surround • Mic',
        'price': '\$79',
        'rating': 4.5,
      },
      {
        'name': 'Laptop Cooling Pad',
        'spec': '5 Fans • Adjustable',
        'price': '\$49',
        'rating': 4.3,
      },
      {
        'name': 'Gaming Headset Pro',
        'spec': '7.1 Surround • Mic',
        'price': '\$79',
        'rating': 4.5,
      },
      {
        'name': 'Laptop Cooling Pad',
        'spec': '5 Fans • Adjustable',
        'price': '\$49',
        'rating': 4.3,
      },
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: accessories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        // 🔧 more vertical space to avoid overflow
        childAspectRatio: 0.65,
      ),
      itemBuilder: (context, index) {
        final a = accessories[index];

        return AccessoriesCard(
          name: a['name'] as String,
          spec: a['spec'] as String,
          price: a['price'] as String,
          rating: (a['rating'] as num).toDouble(),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    ProductDetailsPage(productName: a['name'] as String),
              ),
            );
          },
          onAddToCart: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${a['name']} added to cart'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
        );
      },
    );
  }
}

class AccessoriesCard extends StatefulWidget {
  final String name;
  final String spec;
  final String price;
  final double rating;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;

  const AccessoriesCard({
    super.key,
    required this.name,
    required this.spec,
    required this.price,
    required this.rating,
    this.onTap,
    this.onAddToCart,
  });

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
              colors: [
                Color(0xFFfb7185), // soft red
                Color(0xFFf97316), // orange
              ],
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
                /// Top row: chip + heart
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3, // 🔧 slightly smaller
                      ),
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
                  height: 76, // 🔧 slightly reduced
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.headphones,
                    color: Colors.redAccent,
                    size: 40, // 🔧 slightly reduced
                  ),
                ),

                const SizedBox(height: 6),

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

                const SizedBox(height: 6),

                /// Rating row
                Row(
                  children: [
                    Icon(Icons.star, size: 16, color: Colors.amber.shade700),
                    const SizedBox(width: 4),
                    Text(
                      widget.rating.toStringAsFixed(1),
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(width: 8),
                    const Text('•', style: TextStyle(fontSize: 12)),
                    const SizedBox(width: 4),
                    const Text('In stock', style: TextStyle(fontSize: 11)),
                  ],
                ),

                const SizedBox(height: 6),

                /// Price + Add to cart button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.price,
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
