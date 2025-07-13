import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationHeaderWidget extends StatelessWidget {
  final int unreadCount;
  final VoidCallback onSettingsTap;
  final VoidCallback onMarkAllRead;

  const NotificationHeaderWidget({
    super.key,
    required this.unreadCount,
    required this.onSettingsTap,
    required this.onMarkAllRead,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withAlpha(26),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Back button
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),

          SizedBox(width: 2.w),

          // Title and badge
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Notifications',
                      style: GoogleFonts.inter(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    if (unreadCount > 0) ...[
                      SizedBox(width: 2.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.w,
                          vertical: 0.5.h,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.error,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          unreadCount > 99 ? '99+' : unreadCount.toString(),
                          style: GoogleFonts.inter(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  unreadCount == 0
                      ? 'All caught up!'
                      : '$unreadCount new notification${unreadCount == 1 ? '' : 's'}',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // Action buttons
          if (unreadCount > 0)
            TextButton(
              onPressed: onMarkAllRead,
              child: Text(
                'Mark all read',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),

          // Settings button
          IconButton(
            onPressed: onSettingsTap,
            icon: Icon(
              Icons.settings_outlined,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
