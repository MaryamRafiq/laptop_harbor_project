import 'package:flutter/material.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final TextEditingController messageController = TextEditingController();
  String _selectedType = 'Order issue';

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: const Text('Support & Feedback')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // -------- HEADER CARD ----------
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 173, 0, 35), // dark pink-red
                    Color.fromARGB(255, 110, 2, 18),
                  ], // deep red],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
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
              child: Row(
                children: [
                  const Icon(
                    Icons.support_agent_outlined,
                    color: Colors.white,
                    size: 40,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Tell us about your issue or share feedback.\nOur team will get back to you soon.',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.95),
                        fontSize: 13.5,
                        height: 1.3,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // -------- ISSUE TYPE CHIPS ----------
            Text(
              'What is this about?',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                _buildChip('Order issue'),
                _buildChip('Payment issue'),
                _buildChip('App feedback'),
                _buildChip('Other'),
              ],
            ),

            const SizedBox(height: 20),

            // -------- MESSAGE CARD ----------
            Text(
              'Message',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
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
              child: TextField(
                controller: messageController,
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: 'Describe your issue or feedback in detail...',
                  alignLabelWithHint: true,
                  prefixIcon: const Icon(Icons.chat_bubble_outline),
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

            // -------- CONTACT INFO ----------
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: primary.withOpacity(0.12), width: 1),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: primary, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'You can also reach us at support@laptopharbor.com',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Colors.grey[700],
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // -------- SUBMIT BUTTON ----------
            SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTap: () {
                  // TODO: send to backend later
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Support message sent (demo)'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                  messageController.clear();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 173, 0, 35), // dark pink-red
                        Color.fromARGB(255, 110, 2, 18),
                      ], // deep red],
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
                      Icon(Icons.send_rounded, color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.4,
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

  Widget _buildChip(String label) {
    final isSelected = _selectedType == label;
    final primary = Theme.of(context).colorScheme.primary;

    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isSelected ? Colors.white : Colors.grey[800],
        ),
      ),
      selected: isSelected,
      selectedColor: primary,
      backgroundColor: Colors.grey[200],
      onSelected: (_) {
        setState(() => _selectedType = label);
      },
    );
  }
}
