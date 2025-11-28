import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laptor_harbor/firebase_options.dart';
import 'package:laptor_harbor/pages/home/accesories_laptop.dart';

import 'routes/app_routes.dart';

import 'pages/home/all_laptops_page.dart';
import 'pages/home/gaming_laptops_page.dart';
import 'pages/home/business_laptops_page.dart';
import 'pages/cart/cart_page.dart';
import 'pages/profile/profile_page.dart';
import 'pages/orders/orders_page.dart';
import 'pages/wishlist/wishlist_page.dart';
import 'pages/support/support_page.dart';
import 'pages/settings/settings_page.dart';
import 'pages/auth/login_page.dart';
import 'pages/auth/register_page.dart';
import 'pages/search/search_page.dart';
import 'pages/splash/splash_page.dart';

Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const LaptopHarborApp());
}

class LaptopHarborApp extends StatefulWidget {
  const LaptopHarborApp({super.key});

  @override
  State<LaptopHarborApp> createState() => _LaptopHarborAppState();
}

class _LaptopHarborAppState extends State<LaptopHarborApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _updateThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  ThemeData get _lightTheme {
    const primaryRed = Color.fromARGB(255, 173, 0, 35);
    final base = ThemeData.light();

    return base.copyWith(
      brightness: Brightness.light,
      primaryColor: primaryRed,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryRed,
        brightness: Brightness.light,
      ),

      scaffoldBackgroundColor: Colors.grey[100],

      // Google Fonts (Correct)
      textTheme: GoogleFonts.aBeeZeeTextTheme(base.textTheme),
      primaryTextTheme: GoogleFonts.aBeeZeeTextTheme(base.primaryTextTheme),

      appBarTheme: AppBarTheme(
        backgroundColor: primaryRed,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: GoogleFonts.aBeeZee(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),

      iconTheme: const IconThemeData(color: primaryRed, size: 24),
    );
  }

  //
  // ------------------ DARK THEME ------------------
  //
  ThemeData get _darkTheme {
    const primaryRed = Color.fromARGB(255, 173, 0, 35);
    final base = ThemeData.dark();

    return base.copyWith(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryRed,
        brightness: Brightness.dark,
      ),

      scaffoldBackgroundColor: const Color.fromARGB(255, 17, 20, 29),

      // Google Fonts (Correct)
      textTheme: GoogleFonts.aBeeZeeTextTheme(base.textTheme),
      primaryTextTheme: GoogleFonts.aBeeZeeTextTheme(base.primaryTextTheme),

      appBarTheme: AppBarTheme(
        backgroundColor: const Color.fromARGB(255, 10, 7, 8),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: GoogleFonts.aBeeZee(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),

      iconTheme: const IconThemeData(color: Colors.white, size: 24),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LaptopHarbor',
      debugShowCheckedModeBanner: false,
      theme: _lightTheme,
      darkTheme: _darkTheme,
      themeMode: _themeMode,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case AppRoutes.splash:
            return MaterialPageRoute(builder: (_) => const SplashPage());
          case AppRoutes.home:
            return MaterialPageRoute(
              builder: (_) => MainShell(
                themeMode: _themeMode,
                onThemeChanged: _updateThemeMode,
              ),
            );
          case AppRoutes.login:
            return MaterialPageRoute(builder: (_) => const LoginPage());
          case AppRoutes.register:
            return MaterialPageRoute(builder: (_) => const RegisterPage());
          case AppRoutes.settings:
            return MaterialPageRoute(
              builder: (_) => SettingsPage(
                themeMode: _themeMode,
                onThemeChanged: _updateThemeMode,
              ),
            );
          default:
            return MaterialPageRoute(
              builder: (_) => MainShell(
                themeMode: _themeMode,
                onThemeChanged: _updateThemeMode,
              ),
            );
        }
      },
    );
  }
}

class MainShell extends StatefulWidget {
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;

  const MainShell({
    super.key,
    required this.themeMode,
    required this.onThemeChanged,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('LaptopHarbor'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchPage()),
                );
              },
            ),
          ],
          bottom: _selectedIndex == 0
              ? TabBar(
                  isScrollable: true,
                  labelColor: Colors.white, // SELECTED TAB COLOR
                  unselectedLabelColor: Colors.white70, // UNSELECTED TAB COLOR
                  indicatorColor: Colors.white, // UNDERLINE COLOR
                  tabs: const [
                    Tab(text: 'All'),
                    Tab(text: 'Gaming'),
                    Tab(text: 'Business'),
                    Tab(text: 'Accessories'),
                  ],
                )
              : null,
        ),
        drawer: _buildDrawer(context),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            final offsetAnimation = Tween<Offset>(
              begin: const Offset(0.05, 0),
              end: Offset.zero,
            ).animate(animation);
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(position: offsetAnimation, child: child),
            );
          },
          child: _buildBody(),
        ),
        bottomNavigationBar: _buildAnimatedBottomNav(context),
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const KeyedSubtree(
          key: ValueKey('home'),
          child: TabBarView(
            children: [
              AllLaptopsPage(),
              GamingLaptopsPage(),
              BusinessLaptopsPage(),
              AccessoriesPage(),
            ],
          ),
        );
      case 1:
        return KeyedSubtree(key: ValueKey('cart'), child: CartPage());
      case 2:
        return const KeyedSubtree(
          key: ValueKey('profile'),
          child: ProfilePage(),
        );
      case 3:
        return const KeyedSubtree(key: ValueKey('orders'), child: OrdersPage());
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildAnimatedBottomNav(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    BottomNavigationBarItem buildItem({
      required IconData icon,
      required String label,
      required int index,
    }) {
      final isSelected = _selectedIndex == index;
      return BottomNavigationBarItem(
        label: label,
        icon: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? primary.withOpacity(0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, size: isSelected ? 26 : 22),
        ),
      );
    }

    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onBottomNavTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: primary,
      unselectedItemColor: theme.brightness == Brightness.dark
          ? Colors.grey[400]
          : const Color.fromARGB(255, 104, 104, 104),
      showUnselectedLabels: true,
      items: [
        buildItem(icon: Icons.home_outlined, label: 'Home', index: 0),
        buildItem(icon: Icons.shopping_cart_outlined, label: 'Cart', index: 1),
        buildItem(icon: Icons.person_outline, label: 'Profile', index: 2),
        buildItem(icon: Icons.receipt_long_outlined, label: 'Orders', index: 3),
      ],
    );
  }

  Drawer _buildDrawer(BuildContext context) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;
  const primaryRed = Color.fromARGB(255, 173, 0, 35);

  final currentUser = FirebaseAuth.instance.currentUser;

  return Drawer(
    elevation: 0,
    child: TweenAnimationBuilder<double>(
      tween: Tween(begin: -40, end: 0),
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        final opacity = 1 - (value.abs() / 40);
        return Transform.translate(
          offset: Offset(value, 0),
         child: Opacity(
  opacity: opacity.clamp(0.0, 1.0),
  child: child ?? const SizedBox.shrink(), // fallback if child is null
),
        );
      },
      child: Stack(
        children: [
          // Background panel
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
            child: Container(color: isDark ? Colors.black : Colors.white),
          ),

          // Drawer content
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Drawer Header with FutureBuilder
                currentUser == null
                    ? _guestHeader()
                    : FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        future: FirebaseFirestore.instance
                            .collection('Users')
                            .doc(currentUser.uid)
                            .get(),
                        builder: (context, snapshot) {
                          String displayName = "Guest User";
                          String displayEmail = "guest@laptopharbor.com";

                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData &&
                              snapshot.data != null &&
                              snapshot.data!.exists) {
                            final data = snapshot.data!.data();
                            if (data != null) {
                              displayName = data['fullname'] ?? displayName;
                              displayEmail = data['email'] ?? displayEmail;
                            }
                          }

                          return _userHeader(displayName, displayEmail);
                        },
                      ),

                const SizedBox(height: 20),

                // Drawer Tiles
                _drawerTile(icon: Icons.home_outlined, title: "Home", onTap: () {
                  Navigator.pop(context);
                  setState(() => _selectedIndex = 0);
                }),
                _drawerTile(icon: Icons.favorite_border, title: "Wishlist", onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const WishlistPage()));
                }),
                _drawerTile(icon: Icons.shopping_cart_outlined, title: "Cart", onTap: () {
                  Navigator.pop(context);
                  setState(() => _selectedIndex = 1);
                }),
                _drawerTile(icon: Icons.receipt_long_outlined, title: "My Orders", onTap: () {
                  Navigator.pop(context);
                  setState(() => _selectedIndex = 3);
                }),
                _drawerTile(icon: Icons.support_agent_outlined, title: "Support", onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const SupportPage()));
                }),

                const Divider(height: 30),

                _drawerTile(icon: Icons.settings_outlined, title: "Settings", onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AppRoutes.settings);
                }),

                _drawerTile(
                  icon: Icons.logout,
                  title: "Logout",
                  iconColor: Colors.redAccent,
                  textColor: Colors.redAccent,
                  onTap: () {
                    Navigator.pop(context);
                    FirebaseAuth.instance.signOut();
                    Navigator.pushReplacementNamed(context, AppRoutes.login);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

// Header for logged-in users
Widget _userHeader(String name, String email) {
  const primaryRed = Color.fromARGB(255, 173, 0, 35);
  return Container(
    padding: const EdgeInsets.fromLTRB(16, 40, 16, 20),
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.only(topRight: Radius.circular(24)),
      gradient: LinearGradient(
        colors: [
          Color.fromARGB(255, 173, 0, 35),
          Color.fromARGB(255, 120, 0, 25),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: Row(
      children: [
        const CircleAvatar(
          radius: 32,
          backgroundColor: Colors.white,
          child: Icon(Icons.person, size: 36, color: primaryRed),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              email,
              style: const TextStyle(fontSize: 13, color: Colors.white70),
            ),
          ],
        ),
      ],
    ),
  );
}

// Header for guests
Widget _guestHeader() {
  return _userHeader("Guest User", "guest@laptopharbor.com");
}

  // 🔧 Helper function for Drawer Tiles
  Widget _drawerTile({
    required IconData icon,
    required String title,
    Color iconColor = const Color.fromARGB(255, 173, 0, 35),
    Color textColor = const Color.fromARGB(255, 104, 104, 104),
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: iconColor.withOpacity(0.1),
        highlightColor: iconColor.withOpacity(0.05),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(icon, color: iconColor, size: 22),
              const SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
