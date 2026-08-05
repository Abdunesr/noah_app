import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/colors.dart';
import '../widgets/brand_header.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  // Custom easter egg toggle: Double tap the logo to switch between
  // the professional intended design and the glitch mockup design from the image!
  bool _useGlitchLigatures = false;

  @override
  Widget build(BuildContext context) {
    // Check screen width for web/desktop mockup responsive wrapping
    final double screenWidth = MediaQuery.of(context).size.width;

    Widget screenContent = _buildScreenContent(context);

    if (screenWidth > 500) {
      return Scaffold(
        backgroundColor: const Color(
          0xFF1E2022,
        ), // Sleek slate outer background
        body: Center(
          child: Container(
            width: 390,
            height: 844,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: const Color(0xFF8E9196), // Outer phone bezel
                width: 10,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: screenContent,
            ),
          ),
        ),
      );
    }

    return screenContent;
  }

  Widget _buildScreenContent(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 28),

                              // Brand logo wrap with double tap detector
                              GestureDetector(
                                onDoubleTap: () {
                                  setState(() {
                                    _useGlitchLigatures = !_useGlitchLigatures;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        _useGlitchLigatures
                                            ? 'Switched to Glitch Mockup Design (broken ligatures as text)'
                                            : 'Switched to Clean Intended Design (with icons)',
                                        textAlign: TextAlign.center,
                                      ),
                                      duration: const Duration(seconds: 2),
                                      backgroundColor: AppColors.primaryGreen,
                                    ),
                                  );
                                },
                                child: const BrandHeader(logoSize: 130),
                              ),

                              const SizedBox(height: 16),
                              _buildWelcomeSection(),
                              const SizedBox(height: 28),
                              _buildLoginCard(),
                              const SizedBox(height: 28),
                            ],
                          ),
                        ),
                      ),
                      _buildBottomDecorativeBar(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return const Column(
      children: [
        Text(
          'Welcome back',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0C1D05), // Dark green-black
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Manage your assets with confidence',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEmailField(),
          const SizedBox(height: 18),
          _buildPasswordFieldHeader(),
          const SizedBox(height: 8),
          _buildPasswordField(),
          const SizedBox(height: 24),
          _buildSignInButton(),
          const SizedBox(height: 24),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    Widget? prefixWidget;
    if (_useGlitchLigatures) {
      prefixWidget = const Padding(
        padding: EdgeInsets.only(left: 16, right: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'mail',
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 17,
                color: Color(0xFF4B5563),
              ),
            ),
          ],
        ),
      );
    }

    return CustomTextField(
      controller: _emailController,
      hintText: 'me@company.com',
      prefixIcon: _useGlitchLigatures ? null : Icons.email_outlined,
      prefix: prefixWidget,
      labelText: 'Email Address',
      labelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Color(0xFF4B5563),
        letterSpacing: 0.2,
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildPasswordFieldHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Password',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF4B5563),
            letterSpacing: 0.2,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/forgot_password');
          },
          child: const Text(
            'Forgot Password?',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryGreen,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    Widget? prefixWidget;
    if (_useGlitchLigatures) {
      prefixWidget = const Padding(
        padding: EdgeInsets.only(left: 16, right: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'lock',
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 17,
                color: Color(0xFF4B5563),
              ),
            ),
          ],
        ),
      );
    }

    Widget suffixWidget;
    if (_useGlitchLigatures) {
      suffixWidget = InkWell(
        onTap: () {
          setState(() {
            _obscurePassword = !_obscurePassword;
          });
        },
        child: const Padding(
          padding: EdgeInsets.only(right: 16, left: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'visibility',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: 17,
                  color: Color(0xFF4B5563),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      suffixWidget = IconButton(
        icon: Icon(
          _obscurePassword
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: AppColors.textHint,
          size: 20,
        ),
        onPressed: () {
          setState(() {
            _obscurePassword = !_obscurePassword;
          });
        },
      );
    }

    return CustomTextField(
      controller: _passwordController,
      hintText: _useGlitchLigatures ? '••••••' : '••••••••',
      prefixIcon: _useGlitchLigatures ? null : Icons.lock_outline,
      prefix: prefixWidget,
      suffixIcon: suffixWidget,
      obscureText: _obscurePassword,
    );
  }

  Widget _buildSignInButton() {
    final authState = ref.watch(authProvider);

    return authState.isLoading
        ? const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
            ),
          )
        : CustomButton(
            text: 'Sign In',
            onPressed: () async {
              final email = _emailController.text.trim();
              final password = _passwordController.text.trim();

              if (email.isEmpty || password.isEmpty) {
                _showCustomSnackBar(context, 'Please fill out all fields');
                return;
              }

              final success = await ref
                  .read(authProvider.notifier)
                  .login(email, password);

              if (success && mounted) {
                final user = ref.read(authProvider).user;
                if (user != null) {
                  if (user.isAdmin) {
                    Navigator.pushReplacementNamed(context, '/admin_blocked');
                  } else if (user.isWaterReader) {
                    Navigator.pushReplacementNamed(
                      context,
                      '/water_reader_home',
                    );
                  } else {
                    Navigator.pushReplacementNamed(context, '/home');
                  }
                } else {
                  Navigator.pushReplacementNamed(context, '/home');
                }
              } else if (mounted) {
                final errorMessage =
                    ref.read(authProvider).errorMessage ??
                    'Incorrect credential';
                _showCustomSnackBar(context, errorMessage);
              }
            },
          );
  }

  void _showCustomSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Color(0xFFFEE2E2), // Soft red background for icon
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: Color(0xFFDC2626), // Deep red error icon
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Color(0xFFF9FAFB), // Off-white text color
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(
          0xFF1F2937,
        ), // Elegant dark gray/charcoal background
        behavior: SnackBarBehavior.floating,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  Widget _buildBottomDecorativeBar() {
    return Row(
      children: [
        Expanded(child: Container(height: 6, color: AppColors.bottomBarLight)),
        Expanded(child: Container(height: 6, color: AppColors.bottomBarMedium)),
        Expanded(child: Container(height: 6, color: AppColors.bottomBarDark)),
      ],
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
