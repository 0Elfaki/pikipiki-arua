import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';

class DriverLoginScreen extends ConsumerWidget {
  const DriverLoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: DriverAppTheme.primaryDark,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 1),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: DriverAppTheme.primaryAmber.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.two_wheeler,
                  size: 48,
                  color: DriverAppTheme.primaryAmber,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Pikipiki Driver',
                style: TextStyle(
                  color: DriverAppTheme.textLight,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Arua City Boda Boda Operator Portal & Radar Dispatch.',
                style: TextStyle(
                  color: DriverAppTheme.textMuted,
                  fontSize: 16,
                ),
              ),
              const Spacer(flex: 1),
              TextField(
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.white, fontSize: 18),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: DriverAppTheme.surfaceDark,
                  hintText: '+256 772 000 000',
                  hintStyle: const TextStyle(color: DriverAppTheme.textMuted),
                  prefixIcon: const Icon(Icons.phone, color: DriverAppTheme.primaryAmber),
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
                  onPressed: () {
                    context.go('/radar');
                  },
                  child: const Text('Login / Enter Shift'),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: () => context.go('/radar'),
                  child: const Text(
                    'Demo Boda Operator Mode',
                    style: TextStyle(color: DriverAppTheme.primaryAmber),
                  ),
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
