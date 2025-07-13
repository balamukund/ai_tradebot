import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class GuestModeWidget extends StatelessWidget {
  final VoidCallback onGuestMode;
  final bool isEnabled;

  const GuestModeWidget({
    super.key,
    required this.onGuestMode,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary.withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.visibility_outlined,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Explore as Guest',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'Limited access to demo features',
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

          SizedBox(height: 2.h),

          // Feature list
          Column(
            children: [
              _buildFeatureItem(
                context,
                icon: Icons.trending_up,
                text: 'View live market data',
                isAvailable: true,
              ),
              _buildFeatureItem(
                context,
                icon: Icons.auto_graph,
                text: 'AI trading signals preview',
                isAvailable: true,
              ),
              _buildFeatureItem(
                context,
                icon: Icons.account_balance_wallet,
                text: 'Paper trading simulation',
                isAvailable: true,
              ),
              _buildFeatureItem(
                context,
                icon: Icons.lock_outline,
                text: 'Real trading (requires account)',
                isAvailable: false,
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Guest mode button
          SizedBox(
            width: double.infinity,
            height: 5.h,
            child: OutlinedButton(
              onPressed: isEnabled ? onGuestMode : null,
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: Theme.of(context).colorScheme.secondary,
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.explore_outlined,
                    size: 18,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Continue as Guest',
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 1.h),

          // Upgrade notice
          Text(
            'You can create an account anytime to unlock full features',
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(
    BuildContext context, {
    required IconData icon,
    required String text,
    required bool isAvailable,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        children: [
          Icon(
            isAvailable ? Icons.check_circle : Icons.lock,
            color: isAvailable
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
            size: 16,
          ),
          SizedBox(width: 2.w),
          Icon(
            icon,
            color: isAvailable
                ? Theme.of(context).colorScheme.onSurface
                : Theme.of(context).colorScheme.onSurfaceVariant,
            size: 16,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
                color: isAvailable
                    ? Theme.of(context).colorScheme.onSurface
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
