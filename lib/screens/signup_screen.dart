// lib/screens/signup_screen.dart
import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/text_styles.dart';
import '../widgets/brand_header.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/social_button.dart';
import '../widgets/or_divider.dart';
import '../widgets/divider_line.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _agreedToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const BrandHeader(),
              const DividerLine(),
              const SizedBox(height: 32),
              _buildCreateAccountSection(),
              const SizedBox(height: 32),
              _buildFullNameField(),
              const SizedBox(height: 14),
              _buildEmailField(),
              const SizedBox(height: 14),
              _buildPhoneField(),
              const SizedBox(height: 14),
              _buildPasswordField(),
              const SizedBox(height: 20),
              _buildTermsCheckbox(),
              const SizedBox(height: 16),
              _buildCreateAccountButton(),
              const SizedBox(height: 16),
              _buildSignInLink(),
              const SizedBox(height: 16),
              const OrDivider(text: 'OR REGISTER WITH'),
              const SizedBox(height: 16),
              _buildSocialButtons(),
              const SizedBox(height: 30),
              _buildHelpText(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreateAccountSection() {
    return const Column(
      children: [
        Text('Create Account', style: AppTextStyles.headingLarge),
        SizedBox(height: 4),
        Text(
          'Join Estate Flow to manage your properties with ease',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyRegular,
        ),
      ],
    );
  }

  Widget _buildFullNameField() {
    return CustomTextField(
      controller: _fullNameController,
      hintText: 'John Doe',
      prefixIcon: Icons.person_outline,
      labelText: 'FULL NAME',
    );
  }

  Widget _buildEmailField() {
    return CustomTextField(
      controller: _emailController,
      hintText: 'john@example.com',
      prefixIcon: Icons.mail_outline,
      labelText: 'EMAIL ADDRESS',
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildPhoneField() {
    return CustomTextField(
      controller: _phoneController,
      hintText: '+1 (555) 000-0000',
      prefixIcon: Icons.call_outlined,
      labelText: 'PHONE NUMBER',
      keyboardType: TextInputType.phone,
    );
  }

  Widget _buildPasswordField() {
    return CustomTextField(
      controller: _passwordController,
      hintText: '••••••••',
      prefixIcon: Icons.lock_outline,
      labelText: 'PASSWORD',
      obscureText: _obscurePassword,
      suffixIcon: IconButton(
        icon: Icon(
          _obscurePassword ? Icons.visibility_off : Icons.visibility,
          color: AppColors.textHint,
          size: 20,
        ),
        onPressed: () {
          setState(() {
            _obscurePassword = !_obscurePassword;
          });
        },
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: _agreedToTerms,
            onChanged: (value) {
              setState(() {
                _agreedToTerms = value ?? false;
              });
            },
            activeColor: AppColors.primaryGreen,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            side: const BorderSide(color: AppColors.borderDefault),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
              children: const [
                TextSpan(text: 'I agree to the '),
                TextSpan(
                  text: 'Terms & Conditions',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(text: '.'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCreateAccountButton() {
    return CustomButton(
      text: 'Create Account',
      onPressed: () {
        // TODO: Implement signup logic
      },
    );
  }

  Widget _buildSignInLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Already have an account?",
          style: TextStyle(color: AppColors.textSecondary),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/login');
          },
          child: const Text(
            'Sign In',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return const Row(
      children: [
        SocialButton(label: 'GOOGLE', icon: Icons.g_mobiledata),
        SizedBox(width: 12),
        SocialButton(label: 'APPLE', icon: Icons.apple),
      ],
    );
  }

  Widget _buildHelpText() {
    return RichText(
      text: const TextSpan(
        style: AppTextStyles.helpText,
        children: [
          TextSpan(text: 'Need help? Contact support '),
          TextSpan(text: '@estatesflow.com', style: AppTextStyles.helpEmail),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
