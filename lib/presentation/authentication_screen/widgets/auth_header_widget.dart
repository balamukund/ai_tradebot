import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthHeaderWidget extends StatelessWidget {
  const AuthHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // App Logo
        Container(
          width: 20.w,
          height: 20.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withAlpha(77),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            Icons.trending_up,
            color: Colors.white,
            size: 8.w,
          ),
        ),

        SizedBox(height: 3.h),

        // App Name
        Text(
          'AI TradeBot',
          style: GoogleFonts.inter(
            fontSize: 28.sp,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurface,
            letterSpacing: -0.5,
          ),
        ),

        SizedBox(height: 1.h),

        // Tagline
        Text(
          'AI-Powered Trading Made Simple',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            letterSpacing: 0.2,
          ),
        ),

        SizedBox(height: 2.h),

        // Trust indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTrustIndicator(
              context,
              icon: Icons.security,
              label: 'Bank-Grade Security',
            ),
            SizedBox(width: 6.w),
            _buildTrustIndicator(
              context,
              icon: Icons.verified_user,
              label: 'SEBI Registered',
            ),
            SizedBox(width: 6.w),
            _buildTrustIndicator(
              context,
              icon: Icons.stars,
              label: '4.8★ Rating',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTrustIndicator(
    BuildContext context, {
    required IconData icon,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withAlpha(26),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
