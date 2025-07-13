import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class EmptyNotificationsWidget extends StatelessWidget {
  final String searchQuery;
  final String selectedCategory;
  final bool showOnlyUnread;

  const EmptyNotificationsWidget({
    super.key,
    required this.searchQuery,
    required this.selectedCategory,
    required this.showOnlyUnread,
  });

  @override
  Widget build(BuildContext context) {
    String title;
    String subtitle;
    IconData icon;

    if (searchQuery.isNotEmpty) {
      title = 'No results found';
      subtitle = 'Try adjusting your search or filters';
      icon = Icons.search_off;
    } else if (showOnlyUnread) {
      title = 'No unread notifications';
      subtitle = 'You\'re all caught up! Check back later for new updates.';
      icon = Icons.notifications_none;
    } else if (selectedCategory != 'All') {
      title = 'No $selectedCategory notifications';
      subtitle = 'No notifications in this category yet.';
      icon = Icons.category_outlined;
    } else {
      title = 'No notifications yet';
      subtitle =
          'We\'ll notify you about important trading updates and AI signals.';
      icon = Icons.notifications_none;
    }

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withAlpha(26),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 15.w,
                color: Theme.of(context).colorScheme.primary.withAlpha(128),
              ),
            ),

            SizedBox(height: 4.h),

            // Title
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 1.h),

            // Subtitle
            Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 4.h),

            // Tips for new users
            if (selectedCategory == 'All' &&
                searchQuery.isEmpty &&
                !showOnlyUnread)
              _buildTipsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTipsSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'What notifications will you receive?',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildTipItem(
            context,
            icon: Icons.trending_up,
            title: 'Trade Alerts',
            description: 'Buy/sell signals from AI analysis',
          ),
          _buildTipItem(
            context,
            icon: Icons.psychology,
            title: 'AI Signals',
            description: 'Lorentzian strategy insights and confidence scores',
          ),
          _buildTipItem(
            context,
            icon: Icons.show_chart,
            title: 'Market Updates',
            description: 'Opening bell, closing, and major market events',
          ),
          _buildTipItem(
            context,
            icon: Icons.info_outline,
            title: 'Portfolio Updates',
            description: 'Daily P&L summaries and position changes',
          ),
          SizedBox(height: 2.h),
          Center(
            child: TextButton(
              onPressed: () {
                // Navigate to notification settings
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Notification settings opened',
                      style: GoogleFonts.inter(),
                    ),
                  ),
                );
              },
              child: Text(
                'Customize notification settings',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(1.5.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withAlpha(26),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 16,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
