import 'package:flutter/material.dart';
import 'order_tracking_page.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Map<String, dynamic>> orders = [
      {
        'id': '12345',
        'items': 2,
        'total': 2098.0,
        'status': 'Shipped',
        'color': Colors.green,
        'icon': Icons.local_shipping_outlined,
      },
      {
        'id': '12346',
        'items': 1,
        'total': 1299.0,
        'status': 'Delivered',
        'color': Colors.blue,
        'icon': Icons.check_circle_outline,
      },
      {
        'id': '12347',
        'items': 3,
        'total': 4099.0,
        'status': 'Processing',
        'color': Colors.orange,
        'icon': Icons.access_time,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final o = orders[index];

        return _OrderCard(
          orderId: o['id'],
          items: o['items'],
          total: o['total'],
          status: o['status'],
          statusColor: o['color'],
          icon: o['icon'],
        );
      },
    );
  }
}

class _OrderCard extends StatefulWidget {
  final String orderId;
  final int items;
  final double total;
  final String status;
  final Color statusColor;
  final IconData icon;

  const _OrderCard({
    required this.orderId,
    required this.items,
    required this.total,
    required this.status,
    required this.statusColor,
    required this.icon,
  });

  @override
  State<_OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<_OrderCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const OrderTrackingPage()),
        );
      },
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 140),
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color.fromARGB(255, 173, 0, 35), // red theme gradient border
                Color.fromARGB(255, 110, 2, 18),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          padding: const EdgeInsets.all(1.6),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon Area
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(widget.icon, color: primary, size: 28),
                ),

                const SizedBox(width: 16),

                // Middle Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Order #${widget.orderId}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${widget.items} items • Total: \$${widget.total.toStringAsFixed(0)}",
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ],
                  ),
                ),

                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: widget.statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    widget.status,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: widget.statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
