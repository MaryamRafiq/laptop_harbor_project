import 'dart:async';
import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _glowController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _glowScale;
  late Animation<double> _glowOpacity;

  final List<String> _phrases = const [
    'Gaming • Business • Creator',
    'Performance That Dominates',
    'Curated Premium Laptops',
  ];
  int _phraseIndex = 0;
  Timer? _phraseTimer;

  @override
  void initState() {
    super.initState();

    // Logo animation
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeIn));

    _logoController.forward();

    // Glow animation
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _glowScale = Tween<double>(
      begin: 1.0,
      end: 1.23,
    ).animate(CurvedAnimation(parent: _glowController, curve: Curves.easeOut));

    _glowOpacity = Tween<double>(
      begin: 0.0,
      end: 0.32,
    ).animate(CurvedAnimation(parent: _glowController, curve: Curves.easeOut));

    // Rotating tagline
    _phraseTimer = Timer.periodic(const Duration(milliseconds: 700), (_) {
      if (!mounted) return;
      setState(() => _phraseIndex = (_phraseIndex + 1) % _phrases.length);
    });

    // Navigation
    Timer(const Duration(seconds: 10), () {
      if (!mounted) return;
      _phraseTimer?.cancel();
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _glowController.dispose();
    _phraseTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // ❤️🔥 RED Gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? const [Color(0xFF1A0000), Color(0xFF200000)]
                    : const [
                        Color.fromARGB(255, 173, 0, 35),
                        Color(0xFFE60026),
                        Color.fromARGB(255, 110, 2, 18),
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Glow circles
          Positioned(
            top: -60,
            right: -40,
            child: _blurCircle(150, Colors.white.withOpacity(0.10)),
          ),
          Positioned(
            bottom: -80,
            left: -20,
            child: _blurCircle(170, Colors.black.withOpacity(0.15)),
          ),

          // Main animated content
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: _buildContent(theme),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Glass card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.25)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🔥 Image + Red Glow
              SizedBox(
                width: 130,
                height: 130,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _glowController,
                      builder: (_, __) {
                        return Transform.scale(
                          scale: _glowScale.value,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  Colors.red.withOpacity(_glowOpacity.value),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    // Main image
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.5),
                            blurRadius: 25,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/splash_logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Title
              Text(
                'LaptopHarbor',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 26,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 6),

              // Subtitle
              Text(
                'Find your perfect laptop',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),

              const SizedBox(height: 12),

              // Rotating phrases
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Text(
                  _phrases[_phraseIndex],
                  key: ValueKey(_phrases[_phraseIndex]),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Loader
              const SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        Text(
          'Loading experience...',
          style: theme.textTheme.bodySmall?.copyWith(
            color: Colors.white.withOpacity(0.75),
          ),
        ),
      ],
    );
  }

  Widget _blurCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
