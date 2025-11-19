import 'package:flutter/material.dart';
import '../product/product_details_page.dart';

class GamingLaptopsPage extends StatelessWidget {
  const GamingLaptopsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> laptops = [
      {
        'name': 'Acer Nitro 5',
        'spec': 'i7 • 16GB • RTX 3060',
        'price': '\$1,299',
        'rating': 4.6,
      },
      {
        'name': 'Asus ROG Strix',
        'spec': 'Ryzen 7 • 16GB • RTX 4070',
        'price': '\$1,799',
        'rating': 4.8,
      },
      {
        'name': 'MSI Katana GF66',
        'spec': 'i7 • 16GB • RTX 3050Ti',
        'price': '\$1,499',
        'rating': 4.5,
      },
      {
        'name': 'Dell G15 Gaming',
        'spec': 'Ryzen 7 • 16GB • RTX 4060',
        'price': '\$1,699',
        'rating': 4.7,
      },
      {
        'name': 'Acer Nitro 5',
        'spec': 'i7 • 16GB • RTX 3060',
        'price': '\$1,299',
        'rating': 4.6,
      },
      {
        'name': 'Asus ROG Strix',
        'spec': 'Ryzen 7 • 16GB • RTX 4070',
        'price': '\$1,799',
        'rating': 4.8,
      },
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: laptops.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // two cards per row
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.7, // 👈 taller cards to avoid overflow
      ),
      itemBuilder: (context, index) {
        final l = laptops[index];

        return GamingLaptopCard(
          name: l['name'] as String,
          spec: l['spec'] as String,
          price: l['price'] as String,
          rating: (l['rating'] as num).toDouble(),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    ProductDetailsPage(productName: l['name'] as String),
              ),
            );
          },
          onAddToCart: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${l['name']} added to cart'),
                duration: const Duration(seconds: 1),
              ),
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
  final String price;
  final double rating;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;

  const GamingLaptopCard({
    super.key,
    required this.name,
    required this.spec,
    required this.price,
    required this.rating,
    this.onTap,
    this.onAddToCart,
  });

  @override
  State<GamingLaptopCard> createState() => _GamingLaptopCardState();
}

class _GamingLaptopCardState extends State<GamingLaptopCard> {
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
              colors: [Color(0xFFec4899), Color(0xFF6366f1)], // pink → indigo
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(1.5), // neon border thickness
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
                  child: const Icon(
                    Icons.computer,
                    color: Colors.redAccent,
                    size: 42,
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
                    Text(
                      widget.rating.toStringAsFixed(1),
                      style: const TextStyle(fontSize: 12),
                    ),
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
