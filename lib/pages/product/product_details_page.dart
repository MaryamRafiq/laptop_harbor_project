import 'package:flutter/material.dart';

class ProductDetailsPage extends StatefulWidget {
  final String productName;

  const ProductDetailsPage({super.key, required this.productName});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  String _selectedConfig = '16GB / 512GB SSD';
  String _selectedColor = 'Space Grey';

  final List<String> _configs = [
    '8GB / 256GB SSD',
    '16GB / 512GB SSD',
    '16GB / 1TB SSD',
  ];

  final List<String> _colors = ['Silver', 'Space Grey', 'Black'];

  final List<Map<String, dynamic>> _recommended = [
    {'name': 'Acer Swift 5', 'price': 1099.0},
    {'name': 'HP Pavilion Gaming', 'price': 1199.0},
    {'name': 'Lenovo ThinkPad X1', 'price': 1999.0},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;

    const price = 1299.0;
    const rating = 4.7;

    return Scaffold(
      appBar: AppBar(title: Text(widget.productName)),
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
                  child: Icon(
                    Icons.laptop_mac,
                    size: 80,
                    color: Colors.white.withOpacity(0.95),
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
                  widget.productName,
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
                '\$${price.toStringAsFixed(0)}',
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

          // ==============================================================
          // 🔥 CONFIGURATION (UPDATED CHIP)
          // ==============================================================
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
            children: _configs.map((c) {
              final selected = _selectedConfig == c;
              return ChoiceChip(
                selected: selected,
                showCheckmark: true,
                checkmarkColor: Colors.black, // ALWAYS BLACK
                selectedColor: primary, // ALWAYS RED CHIP
                backgroundColor: isDark ? Colors.grey[850] : Colors.grey[200],
                side: BorderSide(color: selected ? primary : Colors.grey),
                label: Text(
                  c,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: selected
                        ? Colors
                              .black // ALWAYS BLACK SELECTED TEXT
                        : (isDark ? Colors.grey[200] : Colors.grey[800]),
                  ),
                ),
                onSelected: (_) => setState(() => _selectedConfig = c),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // ==============================================================
          // 🔥 COLOR (UPDATED CHIP)
          // ==============================================================
          Text(
            'Color',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),

          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: _colors.map((c) {
              final selected = _selectedColor == c;
              return ChoiceChip(
                selected: selected,
                showCheckmark: true,
                checkmarkColor: Colors.black, // ALWAYS BLACK
                selectedColor: primary, // ALWAYS RED CHIP
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
                onSelected: (_) => setState(() => _selectedColor = c),
              );
            }).toList(),
          ),

          const SizedBox(height: 22),

          // ---------- SPECS ----------
          _buildSpecs(theme, isDark, primary),

          const SizedBox(height: 22),

          // ---------- DESCRIPTION ----------
          _buildDescription(theme),

          const SizedBox(height: 22),

          // ---------- ADD TO CART ----------
          _buildAddToCartButton(primary),

          const SizedBox(height: 10),

          // ---------- ADD TO WISHLIST ----------
          _buildWishlistButton(primary, isDark),

          const SizedBox(height: 24),

          // ---------- YOU MAY ALSO LIKE ----------
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
              itemCount: _recommended.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final item = _recommended[index];
                return _buildRecommendedCard(
                  context,
                  name: item['name'],
                  price: item['price'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------------

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
        children: const [
          Text(
            'Key Specifications',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(ThemeData theme) {
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
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
          SizedBox(height: 8),
          Text(
            'Experience powerful performance...',
            style: TextStyle(fontSize: 13, height: 1.4),
          ),
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
    return OutlinedButton.icon(
      icon: Icon(
        Icons.favorite_border,
        color: isDark ? Colors.pink[200] : primary,
      ),
      label: Text(
        'Add to Wishlist',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.grey[100] : primary,
        ),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        side: BorderSide(color: primary.withOpacity(0.7), width: 1.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      onPressed: () {},
    );
  }

  Widget _buildRecommendedCard(
    BuildContext context, {
    required String name,
    required double price,
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
            child: Icon(
              Icons.laptop_chromebook,
              size: 32,
              color: isDark ? primary : const Color(0xFFb91c1c),
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
            '\$${price.toStringAsFixed(0)}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
