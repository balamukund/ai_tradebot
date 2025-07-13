import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class SocialAuthWidget extends StatelessWidget {
  final VoidCallback onSuccess;
  final Function(String) onError;
  final bool isEnabled;

  const SocialAuthWidget({
    super.key,
    required this.onSuccess,
    required this.onError,
    required this.isEnabled,
  });

  Future<void> _handleSocialAuth(String provider) async {
    try {
      // Simulate social authentication
      await Future.delayed(const Duration(seconds: 1));
      onSuccess();
    } catch (e) {
      onError('$provider authentication failed. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Divider with "OR"
        Row(
          children: [
            Expanded(
              child: Divider(
                color: Theme.of(context).dividerColor,
                thickness: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'OR',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: Theme.of(context).dividerColor,
                thickness: 1,
              ),
            ),
          ],
        ),

        SizedBox(height: 3.h),

        // Social authentication buttons
        Row(
          children: [
            Expanded(
              child: _buildSocialButton(
                context,
                icon: Icons.g_mobiledata,
                label: 'Google',
                backgroundColor: Colors.white,
                textColor: Colors.black87,
                borderColor: Colors.grey[300]!,
                onTap: () => _handleSocialAuth('Google'),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: _buildSocialButton(
                context,
                icon: Icons.apple,
                label: 'Apple',
                backgroundColor: Colors.black,
                textColor: Colors.white,
                borderColor: Colors.black,
                onTap: () => _handleSocialAuth('Apple'),
              ),
            ),
          ],
        ),

        SizedBox(height: 2.h),

        // Privacy statement
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Theme.of(context).dividerColor,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.privacy_tip_outlined,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  'Your data is protected with end-to-end encryption and is never shared with third parties.',
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color backgroundColor,
    required Color textColor,
    required Color borderColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: isEnabled ? onTap : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 6.h,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(13),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: textColor,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
