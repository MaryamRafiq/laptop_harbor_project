import 'package:flutter/material.dart';

import 'edit_profile_page.dart';
import 'change_password_page.dart';
import '../wishlist/wishlist_page.dart';
import '../support/support_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ---------- HEADER CARD ----------
        const SizedBox(height: 20),

        // ---------- SMALL STATS ROW ----------
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _ProfileStat(
              icon: Icons.receipt_long_outlined,
              label: 'Orders',
              value: '0',
              color: primary,
            ),
            _ProfileStat(
              icon: Icons.favorite_border,
              label: 'Wishlist',
              value: '2',
              color: Colors.pinkAccent,
            ),
            _ProfileStat(
              icon: Icons.support_agent_outlined,
              label: 'Support',
              value: '24/7',
              color: Colors.teal,
            ),
          ],
        ),

        const SizedBox(height: 24),

        // ---------- SETTINGS CARD ----------
        Container(
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
            children: [
              _ProfileTile(
                icon: Icons.edit_outlined,
                iconColor: primary,
                title: 'Edit Profile',
                subtitle: 'Update your personal information',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EditProfilePage()),
                  );
                },
              ),
              const Divider(height: 1),
              _ProfileTile(
                icon: Icons.lock_outline,
                iconColor: Colors.orangeAccent,
                title: 'Change Password',
                subtitle: 'Secure your account',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ChangePasswordPage(),
                    ),
                  );
                },
              ),
              const Divider(height: 1),
              _ProfileTile(
                icon: Icons.favorite_border,
                iconColor: Colors.pinkAccent,
                title: 'Wishlist',
                subtitle: 'View your saved laptops',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const WishlistPage()),
                  );
                },
              ),
              const Divider(height: 1),
              _ProfileTile(
                icon: Icons.support_agent_outlined,
                iconColor: Colors.teal,
                title: 'Support & Feedback',
                subtitle: 'Need help? Contact us',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SupportPage()),
                  );
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),
      ],
    );
  }
}

// ---------- SMALL STAT WIDGET ----------
class _ProfileStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _ProfileStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final card = Theme.of(context).cardColor;

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- CUSTOM LIST TILE ----------
class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProfileTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        highlightColor: theme.colorScheme.primary.withOpacity(0.04),
        splashColor: theme.colorScheme.primary.withOpacity(0.08),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[500], size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
