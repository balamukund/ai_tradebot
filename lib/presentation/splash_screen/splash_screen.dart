import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _progressController;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _glowAnimation;
  late Animation<double> _progressAnimation;

  double _loadingProgress = 0.0;
  String _statusMessage = 'Initializing AI TradeBot...';
  bool _hasError = false;
  bool _isOffline = false;

  final List<String> _loadingSteps = [
    'Connecting to markets...',
    'Loading AI models...',
    'Syncing portfolio data...',
    'Preparing trading interface...',
    'Almost ready...'
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startLoadingSequence();
    _checkConnectivity();
  }

  void _initializeAnimations() {
    _logoController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    _progressController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
        CurvedAnimation(parent: _logoController, curve: Curves.elasticOut));

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _logoController, curve: Curves.easeIn));

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _logoController, curve: Curves.easeInOut));

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _progressController, curve: Curves.easeInOut));

    _logoController.forward();
  }

  Future<void> _checkConnectivity() async {
    try {
      final connectivity = await Connectivity().checkConnectivity();
      if (connectivity == ConnectivityResult.none) {
        setState(() {
          _isOffline = true;
          _statusMessage = 'No internet connection';
        });
      }
    } catch (e) {
      setState(() {
        _isOffline = true;
        _statusMessage = 'Connection error';
      });
    }
  }

  Future<void> _startLoadingSequence() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    for (int i = 0; i < _loadingSteps.length; i++) {
      if (mounted) {
        setState(() {
          _statusMessage = _loadingSteps[i];
          _loadingProgress = (i + 1) / _loadingSteps.length;
        });
        _progressController.forward();
        await Future.delayed(const Duration(milliseconds: 800));
        _progressController.reset();
      }
    }

    if (mounted && !_hasError && !_isOffline) {
      await Future.delayed(const Duration(milliseconds: 500));
      _navigateToNext();
    }
  }

  void _navigateToNext() {
    Navigator.pushReplacementNamed(context, AppRoutes.onboardingFlow);
  }

  void _retry() {
    setState(() {
      _hasError = false;
      _isOffline = false;
      _loadingProgress = 0.0;
      _statusMessage = 'Retrying...';
    });
    _logoController.reset();
    _progressController.reset();
    _logoController.forward();
    _startLoadingSequence();
    _checkConnectivity();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
        body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primaryContainer,
                  theme.colorScheme.secondary,
                ])),
            child: Stack(children: [
              // Background geometric patterns
              Positioned.fill(
                  child: CustomPaint(
                      painter: GeometricPatternPainter(
                          color: Colors.white.withAlpha(26)))),

              // Main content
              SafeArea(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(flex: 2),

                            // Logo section
                            AnimatedBuilder(
                                animation: _logoController,
                                builder: (context, child) {
                                  return Transform.scale(
                                      scale: _logoScale.value,
                                      child: Opacity(
                                          opacity: _logoOpacity.value,
                                          child: Container(
                                              width: 120,
                                              height: 120,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.white
                                                            .withAlpha(51 *
                                                                _glowAnimation
                                                                    .value ~/
                                                                1),
                                                        blurRadius: 20 *
                                                            _glowAnimation
                                                                .value,
                                                        spreadRadius: 5 *
                                                            _glowAnimation
                                                                .value),
                                                  ]),
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: Container(
                                                      color: Colors.white,
                                                      child:
                                                          const CustomImageWidget(
                                                              imageUrl: '',
                                                              width: 120,
                                                              height: 120,
                                                              fit: BoxFit
                                                                  .contain))))));
                                }),

                            const SizedBox(height: 24),

                            // App title
                            Text('AI TradeBot',
                                style: GoogleFonts.inter(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1.2)),

                            const SizedBox(height: 8),

                            // Tagline
                            Text('Intelligent Trading Made Simple',
                                style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white.withAlpha(217),
                                    letterSpacing: 0.5),
                                textAlign: TextAlign.center),

                            const Spacer(flex: 2),

                            // Loading section
                            if (!_isOffline && !_hasError) ...[
                              // Progress bar
                              Container(
                                  width: double.infinity,
                                  height: 6,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      color: Colors.white.withAlpha(51)),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(3),
                                      child: LinearProgressIndicator(
                                          value: _loadingProgress,
                                          backgroundColor: Colors.transparent,
                                          valueColor:
                                              const AlwaysStoppedAnimation<
                                                  Color>(Colors.white)))),

                              const SizedBox(height: 16),

                              // Progress percentage
                              Text('${(_loadingProgress * 100).toInt()}%',
                                  style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white)),

                              const SizedBox(height: 8),

                              // Status message
                              Text(_statusMessage,
                                  style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white.withAlpha(204)),
                                  textAlign: TextAlign.center),
                            ],

                            // Error/Offline state
                            if (_isOffline || _hasError) ...[
                              Icon(
                                  _isOffline
                                      ? Icons.wifi_off
                                      : Icons.error_outline,
                                  size: 48,
                                  color: Colors.white.withAlpha(204)),
                              const SizedBox(height: 16),
                              Text(_statusMessage,
                                  style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                  textAlign: TextAlign.center),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                  onPressed: _retry,
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor:
                                          theme.colorScheme.primary,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 32, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25))),
                                  child: Text('Retry',
                                      style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600))),
                              const SizedBox(height: 16),
                              if (_isOffline)
                                TextButton(
                                    onPressed: () {
                                      Navigator.pushReplacementNamed(
                                          context, AppRoutes.onboardingFlow);
                                    },
                                    child: Text('Continue Offline',
                                        style: GoogleFonts.inter(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white.withAlpha(204),
                                            decoration:
                                                TextDecoration.underline))),
                            ],

                            const Spacer(),
                          ]))),
            ])));
  }
}

class GeometricPatternPainter extends CustomPainter {
  final Color color;

  GeometricPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    const spacing = 60.0;

    // Draw diagonal lines
    for (double i = -size.height; i < size.width + size.height; i += spacing) {
      canvas.drawLine(
          Offset(i, 0), Offset(i + size.height, size.height), paint);
    }

    // Draw circles
    for (double x = 0; x < size.width; x += spacing * 2) {
      for (double y = 0; y < size.height; y += spacing * 2) {
        canvas.drawCircle(Offset(x, y), 20, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}