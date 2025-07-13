import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginFormWidget extends StatefulWidget {
  final bool isRegister;
  final bool isLoading;
  final bool rememberMe;
  final VoidCallback onLogin;
  final Function(String) onError;
  final Function(bool) onLoadingChanged;
  final Function(bool) onRememberMeChanged;

  const LoginFormWidget({
    super.key,
    this.isRegister = false,
    required this.isLoading,
    required this.rememberMe,
    required this.onLogin,
    required this.onError,
    required this.onLoadingChanged,
    required this.onRememberMeChanged,
  });

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _enableTwoFactor = false;
  int _passwordStrength = 0;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _calculatePasswordStrength(String password) {
    int strength = 0;
    if (password.length >= 8) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[a-z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;

    setState(() {
      _passwordStrength = strength;
    });
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    widget.onLoadingChanged(true);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock validation
      if (_emailController.text.trim().isEmpty) {
        throw 'Please enter a valid email address';
      }

      if (_passwordController.text.length < 6) {
        throw 'Password must be at least 6 characters';
      }

      if (widget.isRegister &&
          _passwordController.text != _confirmPasswordController.text) {
        throw 'Passwords do not match';
      }

      widget.onLogin();
    } catch (e) {
      widget.onError(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            if (widget.isRegister) ...[
              // Name field for registration
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value?.trim().isEmpty ?? true) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 3.h),
            ],

            // Email/Phone field
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email or Phone',
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value?.trim().isEmpty ?? true) {
                  return 'Please enter email or phone number';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value!) &&
                    !RegExp(r'^\+?[\d\s\-\(\)]+$').hasMatch(value)) {
                  return 'Please enter a valid email or phone number';
                }
                return null;
              },
            ),

            SizedBox(height: 3.h),

            // Password field
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              onChanged: widget.isRegister ? _calculatePasswordStrength : null,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter your password';
                }
                if (value!.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),

            // Password strength indicator for registration
            if (widget.isRegister && _passwordController.text.isNotEmpty) ...[
              SizedBox(height: 1.h),
              _buildPasswordStrengthIndicator(),
            ],

            if (widget.isRegister) ...[
              SizedBox(height: 3.h),
              // Confirm password field
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
            ],

            SizedBox(height: 2.h),

            // Remember me / Two factor authentication
            Row(
              children: [
                Checkbox(
                  value:
                      widget.isRegister ? _enableTwoFactor : widget.rememberMe,
                  onChanged: (value) {
                    if (widget.isRegister) {
                      setState(() {
                        _enableTwoFactor = value ?? false;
                      });
                    } else {
                      widget.onRememberMeChanged(value ?? false);
                    }
                  },
                ),
                Expanded(
                  child: Text(
                    widget.isRegister
                        ? 'Enable Two-Factor Authentication'
                        : 'Remember me',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),

            if (!widget.isRegister) ...[
              SizedBox(height: 1.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Session: 7 days',
                    style: GoogleFonts.inter(
                      fontSize: 10.sp,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ],

            SizedBox(height: 3.h),

            // Submit button
            SizedBox(
              width: double.infinity,
              height: 6.h,
              child: ElevatedButton(
                onPressed: widget.isLoading ? null : _handleSubmit,
                child: widget.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        widget.isRegister ? 'Create Account' : 'Sign In',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordStrengthIndicator() {
    List<String> strengthLabels = [
      'Very Weak',
      'Weak',
      'Fair',
      'Good',
      'Strong'
    ];

    List<Color> strengthColors = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.lightGreen,
      Colors.green,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(5, (index) {
            return Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(right: index < 4 ? 1.w : 0),
                decoration: BoxDecoration(
                  color: index < _passwordStrength
                      ? strengthColors[_passwordStrength - 1]
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        SizedBox(height: 0.5.h),
        Text(
          _passwordStrength > 0
              ? strengthLabels[_passwordStrength - 1]
              : 'Enter password',
          style: GoogleFonts.inter(
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
            color: _passwordStrength > 0
                ? strengthColors[_passwordStrength - 1]
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
