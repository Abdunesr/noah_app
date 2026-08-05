// lib/providers/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import '../models/login_response.dart';

// Create a state class representing authentication status
class AuthState {
  final bool isLoading;
  final String? errorMessage;
  final String? token;
  final UserModel? user;

  AuthState({
    this.isLoading = false,
    this.errorMessage,
    this.token,
    this.user,
  });

  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? token,
    UserModel? user,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage, // resets error on update if not passed
      token: token ?? this.token,
      user: user ?? this.user,
    );
  }
}

// Global Providers
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences has not been initialized');
});

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

// Notifier to manage auth operations (Riverpod 2.x/3.x compliant)
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    Future.microtask(() => tryAutoLogin());
    return AuthState(isLoading: true);
  }

  Future<void> tryAutoLogin() async {
    final prefs = ref.read(sharedPreferencesProvider);
    final savedToken = prefs.getString('auth_token');

    if (savedToken == null || savedToken.isEmpty) {
      state = AuthState(); // Not logged in
      return;
    }

    try {
      final user = await ref.read(authServiceProvider).getMe(savedToken);
      state = AuthState(token: savedToken, user: user);
    } catch (e) {
      // Token is invalid/expired, clear it
      await prefs.remove('auth_token');
      state = AuthState();
    }
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true);
    try {
      final LoginResponse response = await ref.read(authServiceProvider).login(email, password);
      
      // Save token locally
      final prefs = ref.read(sharedPreferencesProvider);
      await prefs.setString('auth_token', response.accessToken);

      state = AuthState(
        token: response.accessToken,
        user: response.userData,
      );
      return true;
    } catch (e) {
      state = AuthState(errorMessage: e.toString().replaceAll('Exception: ', ''));
      return false;
    }
  }

  Future<void> logout() async {
    final token = state.token;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.remove('auth_token');
    state = AuthState();
    if (token != null && token.isNotEmpty) {
      try {
        await ref.read(authServiceProvider).logout(token);
      } catch (_) {
        // Silent catch to ensure local logout completes regardless of network status
      }
    }
  }

  Future<bool> changePassword(String currentPassword, String newPassword) async {
    final token = state.token;
    if (token == null || token.isEmpty) {
      state = state.copyWith(errorMessage: 'Please login to continue');
      return false;
    }

    state = state.copyWith(isLoading: true);
    try {
      await ref.read(authServiceProvider).changePassword(token, currentPassword, newPassword);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }
}

// Global Provider definition
final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
