import 'package:flutter/material.dart';
import 'package:laptor_harbor/post/orders.dart';

class OrderTrackingPage extends StatefulWidget {
  final OrderModel order;

  const OrderTrackingPage({super.key, required this.order});

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    final orderId = widget.order.orderId;
    final total = widget.order.total;
    final status = widget.order.status;

    // ✅ FIX: define eta
    final eta = status == 'Delivered'
        ? 'Order delivered'
        : status == 'Shipped'
            ? 'Arriving in 2–3 days'
            : 'Processing order';

    return Scaffold(
      appBar: AppBar(title: const Text('Order Tracking')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // ---------- ORDER SUMMARY CARD ----------
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 173, 0, 35),
                    Color.fromARGB(255, 110, 2, 18),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.redAccent.withOpacity(0.3),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Order Summary',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order #$orderId',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Total: \$${total.toStringAsFixed(0)}',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              eta,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.local_shipping_outlined,
                              size: 16,
                              color: Color(0xFFb91c1c),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              status,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFb91c1c),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ---------- TIMELINE TITLE ----------
            Text(
              'Tracking Status',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),

            // ---------- TIMELINE ----------
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: const [
                  _TrackingStep(
                    title: 'Order Placed',
                    subtitle: 'We\'ve received your order',
                    isCompleted: true,
                    isCurrent: false,
                    time: 'Placed',
                  ),
                  _TrackingDivider(),
                  _TrackingStep(
                    title: 'Packed',
                    subtitle: 'Your items are packed and ready',
                    isCompleted: true,
                    isCurrent: false,
                    time: 'Packed',
                  ),
                  _TrackingDivider(),
                  _TrackingStep(
                    title: 'Shipped',
                    subtitle: 'On the way to your city',
                    isCompleted: true,
                    isCurrent: true,
                    time: 'Shipped',
                  ),
                  _TrackingDivider(),
                  _TrackingStep(
                    title: 'Delivered',
                    subtitle: 'Order will be delivered to you',
                    isCompleted: false,
                    isCurrent: false,
                    time: '',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ---------- HELP / SUPPORT ----------
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: primary.withOpacity(0.15), width: 1),
              ),
              child: Row(
                children: [
                  Icon(Icons.help_outline, color: primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Need help with this order? Contact support and we\'ll assist you.',
                      style: TextStyle(fontSize: 12.5, color: Colors.grey[700]),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Support clicked (demo)'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    child: const Text('Support'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============== TIMELINE WIDGETS ===============

class _TrackingStep extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  final bool isCompleted;
  final bool isCurrent;

  const _TrackingStep({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.isCompleted,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    Color dotColor;
    IconData icon;

    if (isCompleted) {
      dotColor = Colors.green;
      icon = Icons.check;
    } else if (isCurrent) {
      dotColor = primary;
      icon = Icons.radio_button_checked;
    } else {
      dotColor = Colors.grey;
      icon = Icons.radio_button_unchecked;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dot / Icon
        Column(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: dotColor.withOpacity(isCompleted ? 0.15 : 0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: isCompleted ? 14 : 16, color: dotColor),
            ),
          ],
        ),
        const SizedBox(width: 12),

        // Texts
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w600,
                  fontSize: 14.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12.5, color: Colors.grey[700]),
              ),
              if (time.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                ),
              ],
              const SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }
}

class _TrackingDivider extends StatelessWidget {
  const _TrackingDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 11),
      child: SizedBox(
        height: 22,
        child: VerticalDivider(
          thickness: 1.4,
          width: 1,
          color: Colors.grey[300],
        ),
      ),
    );
  }
}
