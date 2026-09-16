import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../application/auth_notifier.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController(text: '+256 7');
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 1),
              // Brand Icon & Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryAmber.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.two_wheeler,
                  size: 48,
                  color: AppTheme.primaryAmber,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Pikipiki Arua',
                style: TextStyle(
                  color: AppTheme.textLight,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Safe, reliable Boda Boda rides across Arua City & West Nile.',
                style: TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 16,
                ),
              ),
              const Spacer(flex: 1),

              // Phone / OTP Input
              if (!authState.otpSent) ...[
                const Text(
                  'Phone Number',
                  style: TextStyle(
                    color: AppTheme.textLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppTheme.surfaceDark,
                    hintText: '+256 700 000 000',
                    hintStyle: const TextStyle(color: AppTheme.textMuted),
                    prefixIcon: const Icon(Icons.phone, color: AppTheme.primaryAmber),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: authState.isLoading
                        ? null
                        : () {
                            ref
                                .read(authNotifierProvider.notifier)
                                .sendOtp(_phoneController.text.trim());
                          },
                    child: authState.isLoading
                        ? const CircularProgressIndicator(color: Colors.black)
                        : const Text('Send Verification Code'),
                  ),
                ),
              ] else ...[
                const Text(
                  'Enter 6-Digit SMS Code',
                  style: TextStyle(
                    color: AppTheme.textLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    letterSpacing: 8,
                  ),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    counterText: '',
                    filled: true,
                    fillColor: AppTheme.surfaceDark,
                    hintText: '000000',
                    hintStyle: const TextStyle(color: AppTheme.textMuted),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: authState.isLoading
                        ? null
                        : () async {
                            final success = await ref
                                .read(authNotifierProvider.notifier)
                                .verifyOtp(
                                  _phoneController.text.trim(),
                                  _otpController.text.trim(),
                                );
                            if (success && context.mounted) {
                              context.go('/home');
                            }
                          },
                    child: authState.isLoading
                        ? const CircularProgressIndicator(color: Colors.black)
                        : const Text('Confirm & Continue'),
                  ),
                ),
              ],

              const SizedBox(height: 12),
              // Bypass / Demo Login button for local development
              Center(
                child: TextButton(
                  onPressed: () {
                    context.go('/home');
                  },
                  child: const Text(
                    'Explore as Guest (Arua Demo Mode)',
                    style: TextStyle(color: AppTheme.primaryAmber),
                  ),
                ),
              ),

              if (authState.errorMessage != null) ...[
                const SizedBox(height: 12),
                Text(
                  authState.errorMessage!,
                  style: const TextStyle(color: AppTheme.accentRed, fontSize: 13),
                ),
              ],
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
