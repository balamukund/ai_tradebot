import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordWidget extends StatefulWidget {
  final bool isEnabled;

  const ForgotPasswordWidget({
    super.key,
    required this.isEnabled,
  });

  @override
  State<ForgotPasswordWidget> createState() => _ForgotPasswordWidgetState();
}

class _ForgotPasswordWidgetState extends State<ForgotPasswordWidget> {
  bool _isResetRequested = false;
  bool _isLoading = false;

  Future<void> _showForgotPasswordDialog() async {
    final emailController = TextEditingController();
    String selectedMethod = 'email';

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(
                    Icons.lock_reset,
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Reset Password',
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choose how you\'d like to reset your password:',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 2.h),

                  // Recovery method selection
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setDialogState(() {
                              selectedMethod = 'email';
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(3.w),
                            decoration: BoxDecoration(
                              color: selectedMethod == 'email'
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withAlpha(26)
                                  : Colors.transparent,
                              border: Border.all(
                                color: selectedMethod == 'email'
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).dividerColor,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.email_outlined,
                                  color: selectedMethod == 'email'
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  'Email',
                                  style: GoogleFonts.inter(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w500,
                                    color: selectedMethod == 'email'
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setDialogState(() {
                              selectedMethod = 'sms';
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(3.w),
                            decoration: BoxDecoration(
                              color: selectedMethod == 'sms'
                                  ? Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withAlpha(26)
                                  : Colors.transparent,
                              border: Border.all(
                                color: selectedMethod == 'sms'
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).dividerColor,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.sms_outlined,
                                  color: selectedMethod == 'sms'
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  'SMS',
                                  style: GoogleFonts.inter(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w500,
                                    color: selectedMethod == 'sms'
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),

                  // Email/Phone input
                  TextFormField(
                    controller: emailController,
                    keyboardType: selectedMethod == 'email'
                        ? TextInputType.emailAddress
                        : TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: selectedMethod == 'email'
                          ? 'Email Address'
                          : 'Phone Number',
                      prefixIcon: Icon(
                        selectedMethod == 'email'
                            ? Icons.email_outlined
                            : Icons.phone_outlined,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Security notice
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).colorScheme.primary.withAlpha(26),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.security,
                          color: Theme.of(context).colorScheme.primary,
                          size: 16,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            'You\'ll receive a secure reset link that expires in 15 minutes.',
                            style: GoogleFonts.inter(
                              fontSize: 10.sp,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (emailController.text.trim().isEmpty) return;

                          setDialogState(() {
                            _isLoading = true;
                          });

                          // Simulate sending reset link
                          await Future.delayed(const Duration(seconds: 2));

                          Navigator.of(context).pop();
                          setState(() {
                            _isResetRequested = true;
                            _isLoading = false;
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Password reset link sent to ${emailController.text}',
                                style: GoogleFonts.inter(),
                              ),
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                            ),
                          );
                        },
                  child: _isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Send Reset Link',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: widget.isEnabled ? _showForgotPasswordDialog : null,
        child: Text(
          _isResetRequested ? 'Resend reset link' : 'Forgot Password?',
          style: GoogleFonts.inter(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.primary,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}
