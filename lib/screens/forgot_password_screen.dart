// lib/screens/forgot_password_screen.dart
import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../widgets/brand_header.dart';
import '../widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check screen width for web/desktop mockup responsive wrapping
    final double screenWidth = MediaQuery.of(context).size.width;
    Widget screenContent = _buildScreenContent(context);

    if (screenWidth > 500) {
      return Scaffold(
        backgroundColor: const Color(0xFF1E2022), // Sleek slate outer background
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
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // Back Button on top left
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12, top: 12),
                          child: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Color(0xFF0D0F0C),
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                      
                      // Main Content Container
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const BrandHeader(logoSize: 120),
                              const SizedBox(height: 16),
                              _buildTitleSection(),
                              const SizedBox(height: 28),
                              _buildCardContainer(),
                              const SizedBox(height: 24),
                              _buildBackToLoginLink(),
                              const SizedBox(height: 32),
                            ],
                          ),
                        ),
                      ),
                      
                      // Bottom Decorative 3-color Bar
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

  Widget _buildTitleSection() {
    return const Column(
      children: [
        Text(
          'Forgot Password',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0C1D05), // Dark green-black
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Enter your email to receive recovery link',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }

  Widget _buildCardContainer() {
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
          // Email field header label
          const Text(
            'EMAIL ADDRESS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4B5563),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          
          // Custom Text Field
          CustomTextField(
            controller: _emailController,
            hintText: 'Enter your email address',
            keyboardType: TextInputType.emailAddress,
            prefix: const Padding(
              padding: EdgeInsets.only(left: 16, right: 8),
              child: Icon(
                Icons.mail_outline,
                color: Color(0xFF4B5563),
                size: 20,
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Send Reset Link Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _handleSendResetLink,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Send Reset Link',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackToLoginLink() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Remember your password? ',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            'Sign In',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomDecorativeBar() {
    return SizedBox(
      height: 6,
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(color: const Color(0xFFC5E1A5)), // Light Green
          ),
          Expanded(
            flex: 1,
            child: Container(color: const Color(0xFF85B842)), // Medium Green
          ),
          Expanded(
            flex: 1,
            child: Container(color: AppColors.primaryGreen), // Forest Green
          ),
        ],
      ),
    );
  }

  void _handleSendResetLink() {
    final String email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email address'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Recovery link sent to $email'),
        backgroundColor: AppColors.primaryGreen,
      ),
    );

    // Simulate navigation back to login screen after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }
}
