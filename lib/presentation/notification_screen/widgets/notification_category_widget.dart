import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationCategoryWidget extends StatelessWidget {
  final String category;
  final int count;
  final bool isExpanded;
  final VoidCallback onToggle;

  const NotificationCategoryWidget({
    super.key,
    required this.category,
    required this.count,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onToggle,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(3.w),
        margin: EdgeInsets.symmetric(vertical: 0.5.h),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isExpanded
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Category icon
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: _getCategoryColor(context).withAlpha(26),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getCategoryIcon(),
                color: _getCategoryColor(context),
                size: 20,
              ),
            ),

            SizedBox(width: 3.w),

            // Category info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    '$count notification${count == 1 ? '' : 's'}',
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            // Count badge
            if (count > 0)
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 2.w,
                  vertical: 0.5.h,
                ),
                decoration: BoxDecoration(
                  color: _getCategoryColor(context),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  count.toString(),
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),

            SizedBox(width: 2.w),

            // Expand/collapse icon
            Icon(
              isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon() {
    switch (category) {
      case 'Trade Alert':
        return Icons.trending_up;
      case 'Market Update':
        return Icons.show_chart;
      case 'AI Signal':
        return Icons.psychology;
      case 'System Message':
        return Icons.info_outline;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _getCategoryColor(BuildContext context) {
    switch (category) {
      case 'Trade Alert':
        return Theme.of(context).colorScheme.primary;
      case 'Market Update':
        return Theme.of(context).colorScheme.secondary;
      case 'AI Signal':
        return Theme.of(context).colorScheme.tertiary;
      case 'System Message':
        return Theme.of(context).colorScheme.outline;
      default:
        return Theme.of(context).colorScheme.onSurfaceVariant;
    }
  }
}
