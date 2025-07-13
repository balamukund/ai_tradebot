import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../onboarding_flow.dart';

class OnboardingPageWidget extends StatefulWidget {
  final OnboardingPageData data;
  final VoidCallback onInteraction;

  const OnboardingPageWidget({
    super.key,
    required this.data,
    required this.onInteraction,
  });

  @override
  State<OnboardingPageWidget> createState() => _OnboardingPageWidgetState();
}

class _OnboardingPageWidgetState extends State<OnboardingPageWidget>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late List<AnimationController> _featureControllers;

  late Animation<Offset> _titleSlide;
  late Animation<Offset> _subtitleSlide;
  late Animation<Offset> _imageSlide;
  late Animation<double> _imageFade;
  late List<Animation<Offset>> _featureSlides;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _featureControllers = List.generate(
      widget.data.features.length,
      (index) => AnimationController(
        duration: Duration(milliseconds: 400 + (index * 100)),
        vsync: this,
      ),
    );

    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
    ));

    _subtitleSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.2, 0.6, curve: Curves.easeOut),
    ));

    _imageSlide = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.1, 0.5, curve: Curves.easeOut),
    ));

    _imageFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _featureSlides = widget.data.features.asMap().entries.map((entry) {
      return Tween<Offset>(
        begin: const Offset(-0.5, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _featureControllers[entry.key],
        curve: Curves.easeOut,
      ));
    }).toList();
  }

  void _startAnimations() {
    _slideController.forward();
    _fadeController.forward();

    for (int i = 0; i < _featureControllers.length; i++) {
      Future.delayed(Duration(milliseconds: 600 + (i * 150)), () {
        if (mounted) {
          _featureControllers[i].forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    for (final controller in _featureControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            widget.data.backgroundColor,
            widget.data.backgroundColor.withAlpha(230),
            widget.data.backgroundColor.withAlpha(204),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 80),

              // Image section
              Expanded(
                flex: 2,
                child: SlideTransition(
                  position: _imageSlide,
                  child: FadeTransition(
                    opacity: _imageFade,
                    child: GestureDetector(
                      onTap: widget.onInteraction,
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(77),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Stack(
                            children: [
                              CachedNetworkImage(
                                imageUrl: widget.data.imagePath,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: Colors.white.withAlpha(51),
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: Colors.white.withAlpha(51),
                                  child: const Icon(
                                    Icons.image_not_supported,
                                    color: Colors.white,
                                    size: 48,
                                  ),
                                ),
                              ),

                              // Overlay for better text readability
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withAlpha(26),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Content section
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    SlideTransition(
                      position: _titleSlide,
                      child: Text(
                        widget.data.title,
                        style: GoogleFonts.inter(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Subtitle
                    SlideTransition(
                      position: _subtitleSlide,
                      child: Text(
                        widget.data.subtitle,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withAlpha(217),
                          height: 1.5,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Features list
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.data.features.length,
                        itemBuilder: (context, index) {
                          return SlideTransition(
                            position: _featureSlides[index],
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    margin: const EdgeInsets.only(right: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withAlpha(51),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.white.withAlpha(102),
                                        width: 1,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      widget.data.features[index],
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white.withAlpha(230),
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 100), // Space for bottom navigation
            ],
          ),
        ),
      ),
    );
  }
}
