import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  int _selectedFilterIndex = 0;

  final List<String> _filters = [
    'All',
    'Gaming',
    'Business',
    'Budget < \$1000',
    '16GB RAM',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: const Text('Search Laptops'), elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --------- SEARCH FIELD CARD ----------
            Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: TextField(
                controller: _controller,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: primary),
                  hintText: 'Search by brand, model, specs...',
                  hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                  suffixIcon: _controller.text.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _controller.clear();
                            });
                          },
                        ),
                ),
                onChanged: (_) {
                  // Just to rebuild and show/hide clear icon
                  setState(() {});
                },
              ),
            ),

            const SizedBox(height: 18),

            // --------- FILTER CHIPS ----------
            Text(
              'Quick filters',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_filters.length, (index) {
                  final isSelected = _selectedFilterIndex == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(
                        _filters[index],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: primary.withOpacity(0.15),
                      backgroundColor: theme.cardColor,
                      side: BorderSide(
                        color: isSelected
                            ? primary
                            : Colors.grey.withOpacity(0.3),
                      ),
                      onSelected: (_) {
                        setState(() {
                          _selectedFilterIndex = index;
                        });
                      },
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 20),

            // --------- RESULTS / EMPTY STATE ----------
            Expanded(child: _buildEmptyState(theme, primary)),
          ],
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
              Icons.search_rounded,
              size: 56,
              color: primary.withOpacity(0.8),
            ),
            const SizedBox(height: 12),
            const Text(
              'Start searching laptops',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              'Type a brand (Dell, HP, Apple), model, or specs to see matching laptops here.',
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
