import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class BiometricAuthWidget extends StatefulWidget {
  final VoidCallback onSuccess;
  final Function(String) onError;
  final bool isEnabled;

  const BiometricAuthWidget({
    super.key,
    required this.onSuccess,
    required this.onError,
    required this.isEnabled,
  });

  @override
  State<BiometricAuthWidget> createState() => _BiometricAuthWidgetState();
}

class _BiometricAuthWidgetState extends State<BiometricAuthWidget> {
  bool _isBiometricAvailable = true;
  bool _isAuthenticating = false;
  String _biometricType = 'Face ID'; // Mock: Face ID, Touch ID, Fingerprint

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
  }

  Future<void> _checkBiometricAvailability() async {
    // Mock biometric availability check
    setState(() {
      _isBiometricAvailable = true;
      // Simulate different biometric types based on platform
      _biometricType = Theme.of(context).platform == TargetPlatform.iOS
          ? 'Face ID'
          : 'Fingerprint';
    });
  }

  Future<void> _authenticateWithBiometric() async {
    if (!widget.isEnabled || !_isBiometricAvailable) return;

    setState(() {
      _isAuthenticating = true;
    });

    try {
      // Simulate biometric authentication
      await Future.delayed(const Duration(seconds: 2));

      // Mock success/failure
      final success = DateTime.now().millisecond % 3 != 0; // 66% success rate

      if (success) {
        widget.onSuccess();
      } else {
        widget.onError(
            'Biometric authentication failed. Please try again or use password.');
      }
    } catch (e) {
      widget.onError(
          'Biometric authentication is not available. Please use password.');
    } finally {
      setState(() {
        _isAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isBiometricAvailable) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withAlpha(51),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withAlpha(26),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getBiometricIcon(),
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Access',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'Use $_biometricType for secure login',
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Biometric button
          InkWell(
            onTap: widget.isEnabled ? _authenticateWithBiometric : null,
            borderRadius: BorderRadius.circular(50),
            child: Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
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
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: _isAuthenticating
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    )
                  : Icon(
                      _getBiometricIcon(),
                      color: Colors.white,
                      size: 8.w,
                    ),
            ),
          ),

          SizedBox(height: 2.h),

          // Instructions
          Text(
            _isAuthenticating
                ? 'Authenticating...'
                : 'Tap to authenticate with $_biometricType',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 1.h),

          // Fallback option
          TextButton(
            onPressed: widget.isEnabled
                ? () {
                    // Show password fallback
                    widget.onError('Please use your password to sign in.');
                  }
                : null,
            child: Text(
              'Use password instead',
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getBiometricIcon() {
    switch (_biometricType) {
      case 'Face ID':
        return Icons.face;
      case 'Touch ID':
        return Icons.fingerprint;
      case 'Fingerprint':
      default:
        return Icons.fingerprint;
    }
  }
}
