import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/app_export.dart';
import '../../routes/app_routes.dart';
import './widgets/onboarding_page_widget.dart';
import './widgets/page_indicator_widget.dart';
import './widgets/personalization_bottom_sheet_widget.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  int _currentPage = 0;
  bool _isLastPage = false;

  final List<OnboardingPageData> _pages = [
    OnboardingPageData(
      title: 'AI-Powered Trading Intelligence',
      subtitle:
          'Advanced machine learning algorithms analyze market patterns and generate intelligent trading signals in real-time.',
      features: [
        'Lorentzian Distance Classifier',
        'Real-time market analysis',
        'Predictive signal generation',
        'Risk-adjusted recommendations'
      ],
      imagePath:
          'https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?w=500&h=400&fit=crop',
      backgroundColor: const Color(0xFF1B263B),
    ),
    OnboardingPageData(
      title: 'Smart Portfolio Tracking',
      subtitle:
          'Monitor your investments with comprehensive analytics, performance metrics, and personalized insights.',
      features: [
        'Real-time portfolio value',
        'Performance analytics',
        'Profit/Loss tracking',
        'Diversification insights'
      ],
      imagePath:
          'https://images.pexels.com/photos/730547/pexels-photo-730547.jpeg?w=500&h=400&fit=crop',
      backgroundColor: const Color(0xFF415A77),
    ),
    OnboardingPageData(
      title: 'Confident Signal Generation',
      subtitle:
          'Every trading signal comes with AI confidence scoring and detailed analysis to support your decisions.',
      features: [
        'Confidence scoring (0-100%)',
        'Signal strength analysis',
        'Market condition assessment',
        'Entry/exit recommendations'
      ],
      imagePath:
          'https://images.pixabay.com/photo/2016/11/27/21/42/stock-1863880_960_720.jpg?w=500&h=400&fit=crop',
      backgroundColor: const Color(0xFF0D7377),
    ),
    OnboardingPageData(
      title: 'Secure Broker Integration',
      subtitle:
          'Seamlessly connect with leading brokers like Zerodha Kite and Angel One with bank-grade security.',
      features: [
        'Multiple broker support',
        'Encrypted API connections',
        'Secure authentication',
        'Real-time synchronization'
      ],
      imagePath:
          'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=500&h=400&fit=crop',
      backgroundColor: const Color(0xFF2D5016),
      isLastPage: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
      _isLastPage = page == _pages.length - 1;
    });
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _showPersonalizationSheet();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipToEnd() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Skip Onboarding?',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'You can always review these features later in the app settings.',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _completeOnboarding();
            },
            child: Text('Skip'),
          ),
        ],
      ),
    );
  }

  void _showPersonalizationSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PersonalizationBottomSheetWidget(
        onComplete: (preferences) {
          _completeOnboarding(preferences: preferences);
        },
      ),
    );
  }

  Future<void> _completeOnboarding({Map<String, dynamic>? preferences}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_completed', true);

      if (preferences != null) {
        await prefs.setString('user_preferences', preferences.toString());
      }

      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.tradingDashboard);
      }
    } catch (e) {
      // Fallback navigation if SharedPreferences fails
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.tradingDashboard);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Stack(
          children: [
            // Page view
            PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                return OnboardingPageWidget(
                  data: _pages[index],
                  onInteraction: () {
                    // Add haptic feedback or animations for interactions
                  },
                );
              },
            ),

            // Top navigation bar
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back button
                    if (_currentPage > 0)
                      IconButton(
                        onPressed: _previousPage,
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 24,
                        ),
                      )
                    else
                      const SizedBox(width: 48),

                    // Page indicator
                    PageIndicatorWidget(
                      currentPage: _currentPage,
                      totalPages: _pages.length,
                      activeColor: Colors.white,
                      inactiveColor: Colors.white.withAlpha(102),
                    ),

                    // Skip button
                    if (!_isLastPage)
                      TextButton(
                        onPressed: _skipToEnd,
                        child: Text(
                          'Skip',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      )
                    else
                      const SizedBox(width: 48),
                  ],
                ),
              ),
            ),

            // Bottom navigation
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Container(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: [
                      // Progress indicator
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${_currentPage + 1} of ${_pages.length}',
                              style: GoogleFonts.inter(
                                color: Colors.white.withAlpha(204),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: (_currentPage + 1) / _pages.length,
                              backgroundColor: Colors.white.withAlpha(51),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.white),
                              minHeight: 3,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 24),

                      // Next/Get Started button
                      ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: _pages[_currentPage].backgroundColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 4,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _isLastPage ? 'Get Started' : 'Next',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              _isLastPage
                                  ? Icons.rocket_launch
                                  : Icons.arrow_forward,
                              size: 20,
                            ),
                          ],
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

class OnboardingPageData {
  final String title;
  final String subtitle;
  final List<String> features;
  final String imagePath;
  final Color backgroundColor;
  final bool isLastPage;

  OnboardingPageData({
    required this.title,
    required this.subtitle,
    required this.features,
    required this.imagePath,
    required this.backgroundColor,
    this.isLastPage = false,
  });
}
