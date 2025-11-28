import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:laptor_harbor/post/posts.dart';
import 'package:laptor_harbor/services/cart_service.dart';
import '../product/product_details_page.dart';

class AllLaptopsPage extends StatelessWidget {
  const AllLaptopsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),

        // 🔥 SLIDER WITH SIDE SPACING
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SizedBox(height: 160, child: _AutoImageSlider()),
        ),

        const SizedBox(height: 10),

        Expanded(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("posts").snapshots(),
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
                      .toDouble(); // convert Firestore double safely

                  return AllLaptopCard(
                    image: data['image'] ?? '',
                    name: data['name'] ?? '',
                    specification: data['specification'] ?? '',
                    price: priceValue, // pass as double
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
                        category: data['category'] ?? 'laptop',
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
          ),
        ),
      ],
    );
  }
}

/// ---------------------------------------------------------------------------
/// 🔁 AUTO IMAGE SLIDER
/// ---------------------------------------------------------------------------
class _AutoImageSlider extends StatefulWidget {
  const _AutoImageSlider();

  @override
  State<_AutoImageSlider> createState() => _AutoImageSliderState();
}

class _AutoImageSliderState extends State<_AutoImageSlider> {
  final PageController _controller = PageController();
  Timer? _timer;
  int _index = 0;

  final List<Map<String, dynamic>> _slides = [
    {
      'title': 'Best Deals on Laptops',
      'subtitle': 'Gaming • Work • Student',
      'colors': [Color(0xFF0ea5e9), Color(0xFF6366f1)],
      'image': 'assets/images/gaminglaptop.jfif',
    },
    {
      'title': 'Powerful Gaming Rigs',
      'subtitle': 'RTX • High Refresh Rate',
      'colors': [Color(0xFF22c55e), Color(0xFF16a34a)],
      'image': 'assets/images/slide2.jfif',
    },
    {
      'title': 'Ultrabooks & Productivity',
      'subtitle': 'Lightweight • Long Battery',
      'colors': [Color(0xFFf97316), Color(0xFFdb2777)],
      'image': 'assets/images/slide3.jfif',
    },
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_controller.hasClients) return;
      _index = (_index + 1) % _slides.length;
      _controller.animateToPage(
        _index,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: _slides.length,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (_, i) {
              final slide = _slides[i];
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: slide['colors'],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    // Text
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            slide['title'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            slide['subtitle'],
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.16),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.local_offer_rounded,
                                  size: 14,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Up to 20% OFF',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Image placeholder (replace with real image later)
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(isDark ? 0.18 : 0.24),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(slide['image'], fit: BoxFit.cover),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Indicators
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_slides.length, (i) {
                final active = _index == i;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  height: 6,
                  width: active ? 18 : 6,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(active ? 0.95 : 0.5),
                    borderRadius: BorderRadius.circular(999),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
class AllLaptopCard extends StatefulWidget {
  final String name;
  final String specification;
  final double price; // <- now a double
  final String rating;
  final String image;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;

  const AllLaptopCard({
    super.key,
    required this.name,
    required this.specification,
    required this.price, // double
    required this.rating,
    required this.image,
    this.onTap,
    this.onAddToCart,
  });

  @override
  State<AllLaptopCard> createState() => _AllLaptopCardState();
}

class _AllLaptopCardState extends State<AllLaptopCard> {
  bool _pressed = false;
  bool _isFavorite = false;

  void _setPressed(bool v) => setState(() => _pressed = v);
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
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF38bdf8), Color(0xFF6366f1)],
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
                // chip + fav
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        'All Laptops',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueAccent,
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

                // image
                Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.06),
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

                // name
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

                // specs
                Text(
                  widget.specification,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),

                const SizedBox(height: 8),

                // rating
                Row(
                  children: [
                    Icon(Icons.star, size: 16, color: Colors.amber.shade700),
                    const SizedBox(width: 4),
                    Text(widget.rating, style: const TextStyle(fontSize: 12)),
                    const SizedBox(width: 8),
                    const Text('•', style: TextStyle(fontSize: 12)),
                    const SizedBox(width: 4),
                    const Text('Fast delivery', style: TextStyle(fontSize: 11)),
                  ],
                ),

                const SizedBox(height: 6),

                // price + add button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${widget.price.toStringAsFixed(0)}', // display price
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: widget.onAddToCart,
                      icon: const Icon(
                        Icons.add_shopping_cart_outlined,
                        size: 16,
                      ),
                      label: const Text('Add', style: TextStyle(fontSize: 12)),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        minimumSize: const Size(0, 0),
                      ),
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
