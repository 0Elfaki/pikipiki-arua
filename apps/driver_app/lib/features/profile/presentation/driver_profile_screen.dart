import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../auth/application/driver_auth_notifier.dart';

class DriverProfileScreen extends ConsumerWidget {
  const DriverProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(driverAuthNotifierProvider);
    final driver = authState.driver;

    return Scaffold(
      backgroundColor: DriverAppTheme.primaryDark,
      appBar: AppBar(
        title: const Text('Driver Profile & Stage'),
        backgroundColor: DriverAppTheme.surfaceDark,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 46,
                    backgroundColor: DriverAppTheme.primaryAmber.withValues(alpha: 0.2),
                    child: const Icon(
                      Icons.two_wheeler,
                      size: 52,
                      color: DriverAppTheme.primaryAmber,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    driver?.fullName ?? 'Juma Bosco Ondoma',
                    style: const TextStyle(
                      color: DriverAppTheme.textLight,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: DriverAppTheme.accentGreen.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.verified, color: DriverAppTheme.accentGreen, size: 14),
                        SizedBox(width: 4),
                        Text(
                          'STAGE CHAIRMAN VERIFIED',
                          style: TextStyle(
                            color: DriverAppTheme.accentGreen,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Details Cards
            _buildDetailTile('Primary Stage', driver?.stageName ?? 'Arua Hill Stage', Icons.storefront),
            _buildDetailTile('Number Plate', driver?.numberPlate ?? 'UFL 492X', Icons.badge),
            _buildDetailTile('Motorcycle', driver?.motorcycleModel ?? 'Bajaj Boxer 100', Icons.motorcycle),
            _buildDetailTile('Total Rides', '${driver?.totalTrips ?? 184} trips', Icons.history),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: () {
                  ref.read(driverAuthNotifierProvider.notifier).signOut();
                  context.go('/login');
                },
                icon: const Icon(Icons.logout, color: DriverAppTheme.accentRed),
                label: const Text(
                  'End Shift / Sign Out',
                  style: TextStyle(color: DriverAppTheme.accentRed, fontWeight: FontWeight.bold),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: DriverAppTheme.accentRed),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailTile(String title, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: DriverAppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: DriverAppTheme.primaryAmber, size: 22),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(color: DriverAppTheme.textMuted, fontSize: 11)),
              Text(value,
                  style: const TextStyle(
                      color: DriverAppTheme.textLight,
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }
}
