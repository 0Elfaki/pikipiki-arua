import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../core/utils/currency_formatter.dart';
import '../application/trip_notifier.dart';

class ActiveTripScreen extends ConsumerWidget {
  const ActiveTripScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripState = ref.watch(tripNotifierProvider);
    final trip = tripState.currentTrip;

    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(
        title: const Text('Boda En Route'),
        backgroundColor: AppTheme.surfaceDark,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Driver Radar Status Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceDark,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.primaryAmber.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.radar,
                      size: 48,
                      color: AppTheme.primaryAmber,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Matching Nearest Stage Driver...',
                      style: TextStyle(
                        color: AppTheme.textLight,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Stage: ${trip?.pickupAddress ?? 'Arua Hill Stage'}',
                      style: const TextStyle(color: AppTheme.textMuted, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Mock Assigned Boda Driver Details
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppTheme.cardDark,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      backgroundColor: AppTheme.primaryAmber,
                      child: Icon(Icons.person, color: Colors.black, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Juma Bosco',
                            style: TextStyle(
                              color: AppTheme.textLight,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Bajaj Boxer • UFL 492X',
                            style: TextStyle(
                              color: AppTheme.primaryAmber,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: const [
                              Icon(Icons.star, color: Colors.amber, size: 14),
                              SizedBox(width: 4),
                              Text('4.9 (320 trips)',
                                  style: TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.call, color: AppTheme.accentGreen),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Trip Route Details
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceDark,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.radio_button_checked,
                            color: AppTheme.accentGreen, size: 18),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            trip?.pickupAddress ?? 'Pickup Stage',
                            style: const TextStyle(color: AppTheme.textLight),
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          height: 20,
                          child: VerticalDivider(color: Colors.white24, width: 2),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            color: AppTheme.primaryAmber, size: 18),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            trip?.dropoffAddress ?? 'Destination',
                            style: const TextStyle(color: AppTheme.textLight),
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Colors.white12, height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Fare (UGX)',
                          style: TextStyle(color: AppTheme.textMuted, fontSize: 13),
                        ),
                        Text(
                          CurrencyFormatter.formatUGX(trip?.fareUgx ?? 2500),
                          style: const TextStyle(
                            color: AppTheme.textLight,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),

              // Cancel Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () {
                    ref.read(tripNotifierProvider.notifier).cancelTrip();
                    context.pop();
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppTheme.accentRed),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text(
                    'Cancel Trip Request',
                    style: TextStyle(color: AppTheme.accentRed, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
