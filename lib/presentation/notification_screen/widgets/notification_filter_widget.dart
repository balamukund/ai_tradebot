import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationFilterWidget extends StatelessWidget {
  final String selectedCategory;
  final bool showOnlyUnread;
  final Function(String) onCategoryChanged;
  final Function(bool) onUnreadToggle;

  const NotificationFilterWidget({
    super.key,
    required this.selectedCategory,
    required this.showOnlyUnread,
    required this.onCategoryChanged,
    required this.onUnreadToggle,
  });

  @override
  Widget build(BuildContext context) {
    final categories = [
      'All',
      'Trade Alert',
      'Market Update',
      'AI Signal',
      'System Message',
    ];

    return Column(
      children: [
        // Category filters
        SizedBox(
          height: 5.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = selectedCategory == category;

              return Padding(
                padding: EdgeInsets.only(right: 2.w),
                child: FilterChip(
                  label: Text(
                    category,
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (selected) {
                    onCategoryChanged(category);
                  },
                  backgroundColor: Theme.of(context).cardColor,
                  selectedColor: Theme.of(context).colorScheme.primary,
                  checkmarkColor: Colors.white,
                  side: BorderSide(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).dividerColor,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            },
          ),
        ),

        SizedBox(height: 1.h),

        // Additional filters
        Row(
          children: [
            // Unread toggle
            InkWell(
              onTap: () => onUnreadToggle(!showOnlyUnread),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: showOnlyUnread
                      ? Theme.of(context).colorScheme.primary.withAlpha(26)
                      : Colors.transparent,
                  border: Border.all(
                    color: showOnlyUnread
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).dividerColor,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      showOnlyUnread ? Icons.circle : Icons.circle_outlined,
                      size: 16,
                      color: showOnlyUnread
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      'Unread only',
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: showOnlyUnread
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Spacer(),

            // Date range selector (placeholder)
            InkWell(
              onTap: () {
                // TODO: Implement date range picker
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Date range filter coming soon!',
                      style: GoogleFonts.inter(),
                    ),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).dividerColor,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.date_range_outlined,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      'All time',
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(width: 1.w),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
