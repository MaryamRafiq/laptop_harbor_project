import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laptor_harbor/post/posts.dart';

class ProductDetailsPage extends StatefulWidget {
  final String productName;

  const ProductDetailsPage({super.key, required this.productName});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  Post? product;
  List<Post> recommendedProducts = [];
  String _selectedConfig = '';


  @override
  void initState() {
    super.initState();
    fetchProduct();
  }

  Future<void> fetchProduct() async {
    final query = await FirebaseFirestore.instance
        .collection('posts')
        .where('name', isEqualTo: widget.productName)
        .get();

    if (query.docs.isNotEmpty) {
      final data = query.docs.first.data();
      final fetchedProduct = Post.fromMap(data);

      // Split configurations if stored as comma-separated string
      final configs = fetchedProduct.configuration
          .split(',')
          .map((e) => e.trim())
          .toList();

      setState(() {
        product = fetchedProduct;
        if (configs.isNotEmpty) _selectedConfig = configs[0];
      });

      fetchRecommended(fetchedProduct.category, fetchedProduct.name);
    }
  }

  Future<void> fetchRecommended(String category, String excludeName) async {
    final query = await FirebaseFirestore.instance
        .collection('posts')
        .where('category', isEqualTo: category)
        .get();

    final products = query.docs
        .map((doc) => Post.fromMap(doc.data()))
        .where((p) => p.name != excludeName)
        .toList();

    setState(() {
      recommendedProducts = products;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;

    if (product == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final configs = product!.configuration
        .split(',')
        .map((e) => e.trim())
        .toList();
    final price = (product!.price);
    final rating = (product!.rating);

    return Scaffold(
      appBar: AppBar(title: Text(product!.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ---------- HERO IMAGE ----------
          Container(
            height: 220,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 173, 0, 35),
                  Color.fromARGB(255, 110, 2, 18),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.redAccent.withOpacity(0.35),
                  blurRadius: 22,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      product!.image,
                      height: 220,
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
                Positioned(
                  top: 14,
                  right: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.local_fire_department,
                          size: 14,
                          color: Colors.white,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Best Seller',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // ---------- TITLE + HEART ----------
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  product!.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.favorite_border,
                  color: isDark ? Colors.pink[200] : null,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // ---------- PRICE + STOCK ----------
          Row(
            children: [
              Text(
                '\$${product!.price.toStringAsFixed(0)}', // convert to string
                style: TextStyle(
                  color: primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(isDark ? 0.24 : 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 14,
                      color: isDark ? Colors.greenAccent : Colors.green,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'In stock',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? Colors.greenAccent : Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // ---------- CONFIGURATION ----------
          Text(
            'Configuration',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),

          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: configs.map((c) {
              final selected = _selectedConfig == c;
              return ChoiceChip(
                selected: selected,
                showCheckmark: true,
                checkmarkColor: Colors.black,
                selectedColor: primary,
                backgroundColor: isDark ? Colors.grey[850] : Colors.grey[200],
                side: BorderSide(color: selected ? primary : Colors.grey),
                label: Text(
                  c,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: selected
                        ? Colors.black
                        : (isDark ? Colors.grey[200] : Colors.grey[800]),
                  ),
                ),
                onSelected: (_) => setState(() => _selectedConfig = c),
              );
            }).toList(),
          ),

          const SizedBox(height: 22),

          // ---------- SPECS ----------
          _buildSpecs(theme, isDark, primary),

          const SizedBox(height: 22),

          // ---------- DESCRIPTION ----------
          _buildDescription(theme, product!.description),

          const SizedBox(height: 22),

          // ---------- ADD TO CART ----------
          _buildAddToCartButton(primary),

          const SizedBox(height: 10),

          // ---------- ADD TO WISHLIST ----------
          _buildWishlistButton(primary, isDark),

          const SizedBox(height: 24),

          // ---------- YOU MAY ALSO LIKE ----------
          if (recommendedProducts.isNotEmpty) ...[
            Text(
              'You may also like',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 140,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: recommendedProducts.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final item = recommendedProducts[index];
                  final recPrice = (item.price) ?? 0.0;
                  return _buildRecommendedCard(
                    context,
                    name: item.name,
                    price: item.price, // now it's double
                    imageUrl: item.image,
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSpecs(ThemeData theme, bool isDark, Color primary) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Key Specifications',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
          const SizedBox(height: 8),
          Text(
            product!.specification,
            style: const TextStyle(fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(ThemeData theme, String description) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Description',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
          const SizedBox(height: 8),
          Text(description, style: const TextStyle(fontSize: 13, height: 1.4)),
        ],
      ),
    );
  }

  Widget _buildAddToCartButton(Color primary) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 173, 0, 35),
              Color.fromARGB(255, 110, 2, 18),
            ],
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_shopping_cart_outlined,
              color: Colors.white,
              size: 18,
            ),
            SizedBox(width: 8),
            Text(
              'Add to Cart',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWishlistButton(Color primary, bool isDark) {
  if (product == null) return const SizedBox();

  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    return OutlinedButton.icon(
      icon: Icon(Icons.favorite_border, color: isDark ? Colors.pink[200] : primary),
      label: Text(
        'Add to Wishlist',
        style: TextStyle(color: isDark ? Colors.grey[100] : primary),
      ),
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login required')),
        );
      },
    );
  }

  final userId = user.uid;

  final wishlistRef = FirebaseFirestore.instance
      .collection('wishlist')
      .doc(userId)
      .collection('items')
      .doc(product!.name); // 🔥 use product name

  return StreamBuilder<DocumentSnapshot>(
    stream: wishlistRef.snapshots(),
    builder: (context, snapshot) {
      final isInWishlist = snapshot.hasData && snapshot.data!.exists;

      return OutlinedButton.icon(
        icon: Icon(
          isInWishlist ? Icons.favorite : Icons.favorite_border,
          color: isInWishlist ? Colors.redAccent : (isDark ? Colors.pink[200] : primary),
        ),
        label: Text(
          isInWishlist ? 'Remove from Wishlist' : 'Add to Wishlist',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isInWishlist ? Colors.redAccent : (isDark ? Colors.grey[100] : primary),
          ),
        ),
        onPressed: () async {
          if (isInWishlist) {
            await wishlistRef.delete();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Removed from Wishlist')),
            );
          } else {
            await wishlistRef.set({
              'name': product!.name,
              'image': product!.image,
              'specification': product!.specification,
              'price': product!.price,
              'rating': product!.rating,   // stored as string
              'configuration': product!.configuration,
              'description': product!.description,
              'category': product!.category,
              'quantity': product!.quantity,
              'timestamp': FieldValue.serverTimestamp(),
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Added to Wishlist')),
            );
          }
        },
      );
    },
  );
}


  Widget _buildRecommendedCard(
    BuildContext context, {
    required String name,
    required double price,
    required String imageUrl,
  }) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: 170,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
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
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: isDark
                  ? primary.withOpacity(0.24)
                  : primary.withOpacity(0.06),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
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
          Text(
            name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          const Spacer(),
          Text(
            '\$${price.toStringAsFixed(0)}', // convert double to string
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
