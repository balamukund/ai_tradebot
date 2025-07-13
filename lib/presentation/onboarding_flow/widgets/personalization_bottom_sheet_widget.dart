import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PersonalizationBottomSheetWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onComplete;

  const PersonalizationBottomSheetWidget({
    super.key,
    required this.onComplete,
  });

  @override
  State<PersonalizationBottomSheetWidget> createState() =>
      _PersonalizationBottomSheetWidgetState();
}

class _PersonalizationBottomSheetWidgetState
    extends State<PersonalizationBottomSheetWidget>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  String _riskTolerance = 'moderate';
  String _experience = 'intermediate';
  String _investmentGoal = 'growth';
  List<String> _interestedMarkets = [];
  bool _enableNotifications = true;

  final List<String> _availableMarkets = [
    'Stocks',
    'Options',
    'Futures',
    'Forex',
    'Crypto',
    'Commodities',
  ];

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  void _handleComplete() {
    final preferences = {
      'riskTolerance': _riskTolerance,
      'experience': _experience,
      'investmentGoal': _investmentGoal,
      'interestedMarkets': _interestedMarkets,
      'enableNotifications': _enableNotifications,
      'completedAt': DateTime.now().toIso8601String(),
    };
    widget.onComplete(preferences);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        height: size.height * 0.8,
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                children: [
                  Text(
                    'Personalize Your Experience',
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Help us customize AI TradeBot to match your trading style and preferences.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Form content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    // Risk Tolerance
                    _buildSectionTitle('Risk Tolerance'),
                    const SizedBox(height: 12),
                    _buildRadioGroup(
                      value: _riskTolerance,
                      options: [
                        (
                          'conservative',
                          'Conservative',
                          'Lower risk, stable returns'
                        ),
                        ('moderate', 'Moderate', 'Balanced risk and reward'),
                        (
                          'aggressive',
                          'Aggressive',
                          'Higher risk, higher potential'
                        ),
                      ],
                      onChanged: (value) =>
                          setState(() => _riskTolerance = value!),
                    ),

                    const SizedBox(height: 24),

                    // Trading Experience
                    _buildSectionTitle('Trading Experience'),
                    const SizedBox(height: 12),
                    _buildRadioGroup(
                      value: _experience,
                      options: [
                        ('beginner', 'Beginner', 'New to trading'),
                        (
                          'intermediate',
                          'Intermediate',
                          '1-3 years experience'
                        ),
                        ('advanced', 'Advanced', '3+ years experience'),
                      ],
                      onChanged: (value) =>
                          setState(() => _experience = value!),
                    ),

                    const SizedBox(height: 24),

                    // Investment Goal
                    _buildSectionTitle('Primary Investment Goal'),
                    const SizedBox(height: 12),
                    _buildRadioGroup(
                      value: _investmentGoal,
                      options: [
                        (
                          'income',
                          'Income Generation',
                          'Regular dividends and returns'
                        ),
                        (
                          'growth',
                          'Capital Growth',
                          'Long-term value appreciation'
                        ),
                        (
                          'speculation',
                          'Active Trading',
                          'Short-term opportunities'
                        ),
                      ],
                      onChanged: (value) =>
                          setState(() => _investmentGoal = value!),
                    ),

                    const SizedBox(height: 24),

                    // Market Interests
                    _buildSectionTitle('Interested Markets'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _availableMarkets.map((market) {
                        final isSelected = _interestedMarkets.contains(market);
                        return FilterChip(
                          label: Text(market),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _interestedMarkets.add(market);
                              } else {
                                _interestedMarkets.remove(market);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 24),

                    // Notifications
                    _buildSectionTitle('Notifications'),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      title: Text(
                        'Enable Push Notifications',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        'Receive alerts for trading signals and market updates',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      value: _enableNotifications,
                      onChanged: (value) =>
                          setState(() => _enableNotifications = value),
                      contentPadding: EdgeInsets.zero,
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // Bottom actions
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                border: Border(
                  top: BorderSide(
                    color: theme.dividerColor,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        widget.onComplete({});
                      },
                      child: Text('Skip for Now'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _handleComplete,
                      child: Text('Complete Setup'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  Widget _buildRadioGroup({
    required String value,
    required List<(String, String, String)> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      children: options.map((option) {
        return RadioListTile<String>(
          title: Text(
            option.$2,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            option.$3,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          value: option.$1,
          groupValue: value,
          onChanged: onChanged,
          contentPadding: EdgeInsets.zero,
        );
      }).toList(),
    );
  }
}
