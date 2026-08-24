// lib/screens/signup_screen.dart
import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/text_styles.dart';
import '../utils/localizations.dart';
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
              OrDivider(text: context.tr('OR REGISTER WITH')),
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
    return Column(
      children: [
        Text(context.tr('Create Account'), style: AppTextStyles.headingLarge),
        const SizedBox(height: 4),
        Text(
          context.tr('Join Estate Flow to manage your properties with ease'),
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
      labelText: context.tr('FULL NAME'),
    );
  }

  Widget _buildEmailField() {
    return CustomTextField(
      controller: _emailController,
      hintText: 'john@example.com',
      prefixIcon: Icons.mail_outline,
      labelText: context.tr('EMAIL ADDRESS'),
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildPhoneField() {
    return CustomTextField(
      controller: _phoneController,
      hintText: '+1 (555) 000-0000',
      prefixIcon: Icons.call_outlined,
      labelText: context.tr('PHONE NUMBER'),
      keyboardType: TextInputType.phone,
    );
  }

  Widget _buildPasswordField() {
    return CustomTextField(
      controller: _passwordController,
      hintText: '••••••••',
      prefixIcon: Icons.lock_outline,
      labelText: context.tr('PASSWORD'),
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
              children: [
                TextSpan(text: context.tr('I agree to the ')),
                TextSpan(
                  text: context.tr('Terms & Conditions'),
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(text: context.tr(' and ')),
                TextSpan(
                  text: context.tr('Privacy Policy'),
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const TextSpan(text: '.'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCreateAccountButton() {
    return CustomButton(
      text: context.tr('Create Account'),
      onPressed: () {
        // TODO: Implement signup logic
      },
    );
  }

  Widget _buildSignInLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.tr("Already have an account?"),
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/login');
          },
          child: Text(
            context.tr('Sign In'),
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      children: [
        SocialButton(label: context.tr('GOOGLE'), icon: Icons.g_mobiledata),
        const SizedBox(width: 12),
        SocialButton(label: context.tr('APPLE'), icon: Icons.apple),
      ],
    );
  }

  Widget _buildHelpText() {
    return RichText(
      text: TextSpan(
        style: AppTextStyles.helpText,
        children: [
          TextSpan(text: context.tr('Need help? Contact support ')),
          const TextSpan(text: '@estatesflow.com', style: AppTextStyles.helpEmail),
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
