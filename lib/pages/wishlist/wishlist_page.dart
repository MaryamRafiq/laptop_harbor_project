import 'package:flutter/material.dart';
import '../product/product_details_page.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  // Dummy wishlist data – later you can connect to real backend
  final List<Map<String, dynamic>> _wishlistItems = [
    {
      'name': 'Dell Inspiron 15',
      'spec': 'i5 • 8GB • 512GB SSD',
      'price': 899.0,
      'rating': 4.5,
    },
    {
      'name': 'HP Pavilion Gaming',
      'spec': 'i7 • 16GB • RTX 3050',
      'price': 1199.0,
      'rating': 4.7,
    },
    {
      'name': 'MacBook Air M2',
      'spec': 'M2 • 8GB • 256GB SSD',
      'price': 1299.0,
      'rating': 4.8,
    },
    {
      'name': 'Lenovo ThinkPad X1',
      'spec': 'i7 • 16GB • 1TB SSD',
      'price': 1999.0,
      'rating': 4.9,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist')),
      body: _wishlistItems.isEmpty
          ? _buildEmptyState(theme, primary)
          : Padding(
              padding: const EdgeInsets.all(12),
              child: GridView.builder(
                itemCount: _wishlistItems.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.75, // a bit taller for safe space
                ),
                itemBuilder: (context, index) {
                  final item = _wishlistItems[index];
                  return _WishlistCard(
                    name: item['name'] as String,
                    spec: item['spec'] as String,
                    price: item['price'] as double,
                    rating: (item['rating'] as num).toDouble(),
                    onOpenDetails: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailsPage(
                            productName: item['name'] as String,
                          ),
                        ),
                      );
                    },
                    onMoveToCart: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${item['name']} moved to cart (demo)'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    onRemove: () {
                      setState(() {
                        _wishlistItems.removeAt(index);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${item['name']} removed from wishlist',
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, Color primary) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.favorite_border,
              size: 60,
              color: primary.withOpacity(0.7),
            ),
            const SizedBox(height: 12),
            const Text(
              'Your wishlist is empty',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              'Save your favourite laptops here and quickly access them later.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------- SINGLE WISHLIST CARD ----------
class _WishlistCard extends StatelessWidget {
  final String name;
  final String spec;
  final double price;
  final double rating;
  final VoidCallback? onOpenDetails;
  final VoidCallback? onMoveToCart;
  final VoidCallback? onRemove;

  const _WishlistCard({
    required this.name,
    required this.spec,
    required this.price,
    required this.rating,
    this.onOpenDetails,
    this.onMoveToCart,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.cardColor;

    return GestureDetector(
      onTap: onOpenDetails,
      child: Container(
        decoration: BoxDecoration(
          // outer gradient border
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 173, 0, 35),
              Color.fromARGB(255, 110, 2, 18),
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
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: chip + remove
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.favorite, size: 12, color: Colors.redAccent),
                        SizedBox(width: 4),
                        Text(
                          'Wishlist',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: onRemove,
                    child: Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // Image placeholder
              Container(
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.laptop_mac,
                  size: 34,
                  color: Color(0xFFb91c1c),
                ),
              ),

              const SizedBox(height: 5),

              // Name
              Text(
                name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 3),

              // Specs
              Text(
                spec,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),

              const SizedBox(height: 6),

              // Rating
              Row(
                children: [
                  Icon(Icons.star, size: 14, color: Colors.amber.shade700),
                  const SizedBox(width: 4),
                  Text(
                    rating.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 11.5),
                  ),
                ],
              ),

              const Spacer(),

              // ✅ Price + Move to cart in Column to avoid width overflow
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '\$${price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: onMoveToCart,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 4,
                        ),
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      icon: const Icon(Icons.shopping_bag_outlined, size: 16),
                      label: const Text(
                        'Move to cart',
                        style: TextStyle(fontSize: 11.5),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
