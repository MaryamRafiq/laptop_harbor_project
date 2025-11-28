import 'package:flutter/material.dart';
import 'package:laptor_harbor/post/orders.dart';
import 'package:laptor_harbor/services/cart_service.dart';
import 'package:laptor_harbor/services/order_service.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final TextEditingController shippingController = TextEditingController();
  final TextEditingController billingController = TextEditingController();

  @override
  void dispose() {
    shippingController.dispose();
    billingController.dispose();
    super.dispose();
  }

  double get itemsTotal {
    return CartService.instance.getCartItems().fold(
        0, (sum, item) => sum + (item.price * item.quantity));
  }

  double get tax => itemsTotal * 0.03; // e.g., 3% tax
  double get grandTotal => itemsTotal + tax;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // ---------- Shipping Address ----------
            Text(
              'Shipping Address',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
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
              child: TextFormField(
                controller: shippingController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'House, Street, City, Country',
                  prefixIcon: const Icon(Icons.local_shipping_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: primary, width: 1.6),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ---------- Billing Address ----------
            Text(
              'Billing Address',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
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
              child: TextFormField(
                controller: billingController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Same as shipping or add another address',
                  prefixIcon: const Icon(Icons.receipt_long_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: primary, width: 1.6),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ---------- Order Summary ----------
            Text(
              'Order Summary',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
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
                children: [
                  ...CartService.instance.getCartItems().map(
                    (item) => Column(
                      children: [
                        _SummaryRow(
                          label:
                              '${item.name} x${item.quantity}',
                          value: '\$${(item.price * item.quantity).toStringAsFixed(0)}',
                        ),
                        const SizedBox(height: 6),
                      ],
                    ),
                  ),
                  _SummaryRow(label: 'Items total', value: '\$${itemsTotal.toStringAsFixed(0)}'),
                  const SizedBox(height: 6),
                  _SummaryRow(label: 'Shipping', value: 'Free'),
                  const SizedBox(height: 6),
                  _SummaryRow(label: 'Tax', value: '\$${tax.toStringAsFixed(0)}'),
                  const Divider(height: 20),
                  _SummaryRow(
                    label: 'Grand Total',
                    value: '\$${grandTotal.toStringAsFixed(0)}',
                    isBold: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ---------- Place Order Button ----------
            SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTap: () {
                  final newOrder = OrderModel(
                    orderId: DateTime.now().millisecondsSinceEpoch.toString(),
                    items: CartService.instance.getCartItems(),
                    total: CartService.instance.getCartItems().fold(
                      0,
                      (sum, p) => sum + (p.price * p.quantity),
                    ),
                    status: 'Processing',
                    createdAt: DateTime.now(),
                  );

                  OrderService.instance.addOrder(newOrder);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Order placed successfully')),
                  );

                  // Optionally clear cart after placing order
                  // CartService.instance.clear();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 173, 0, 35),
                        Color.fromARGB(255, 110, 2, 18),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.redAccent.withOpacity(0.28),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Place Order',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- Small summary row widget ----------
class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = isBold
        ? const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)
        : const TextStyle(fontSize: 14, fontWeight: FontWeight.w500);

    return Row(
      children: [
        Text(label, style: style),
        const Spacer(),
        Text(value, style: style),
      ],
    );
  }
}
