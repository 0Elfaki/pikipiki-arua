import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../auth/application/driver_auth_notifier.dart';
import '../../trip/application/driver_trip_notifier.dart';

class EarningsScreen extends ConsumerWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripState = ref.watch(driverTripNotifierProvider);
    final authState = ref.watch(driverAuthNotifierProvider);
    final driver = authState.driver;

    return Scaffold(
      backgroundColor: DriverAppTheme.primaryDark,
      appBar: AppBar(
        title: const Text('Earnings & Wallet'),
        backgroundColor: DriverAppTheme.surfaceDark,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total Wallet Balance Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Available Wallet Balance',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    CurrencyFormatter.formatUGX(driver?.walletBalanceUgx ?? 42500),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Withdrawal of wallet balance to MTN/Airtel MoMo initiated!'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: DriverAppTheme.primaryAmber,
                        foregroundColor: Colors.black,
                      ),
                      child: const Text('Withdraw to Mobile Money'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Today's Breakdown
            const Text(
              'Shift Summary',
              style: TextStyle(
                color: DriverAppTheme.textLight,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: DriverAppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildSummaryRow(
                    'Gross Fares',
                    CurrencyFormatter.formatUGX(tripState.todayEarningsUgx),
                  ),
                  const Divider(color: Colors.white12, height: 24),
                  _buildSummaryRow(
                    'Completed Trips',
                    '${tripState.completedTripsToday} rides',
                  ),
                  const Divider(color: Colors.white12, height: 24),
                  _buildSummaryRow(
                    'Platform Fee (0% Arua Launch Special)',
                    'UGX 0',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: DriverAppTheme.textMuted)),
        Text(
          value,
          style: const TextStyle(
            color: DriverAppTheme.textLight,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
