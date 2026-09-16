import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../core/utils/currency_formatter.dart';
import '../application/driver_trip_notifier.dart';
import '../data/driver_trip_model.dart';

class ActiveNavigationScreen extends ConsumerWidget {
  const ActiveNavigationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripState = ref.watch(driverTripNotifierProvider);
    final req = tripState.incomingRequest;
    final status = tripState.status;

    return Scaffold(
      backgroundColor: DriverAppTheme.primaryDark,
      appBar: AppBar(
        title: const Text('Active Boda Ride'),
        backgroundColor: DriverAppTheme.surfaceDark,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Simulated Navigation Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: DriverAppTheme.surfaceDark,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: DriverAppTheme.primaryAmber),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.navigation,
                      color: DriverAppTheme.primaryAmber,
                      size: 32,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            status == DriverTripStatus.accepted
                                ? 'Head to Pickup Stage (400m)'
                                : 'Ride in Progress to Destination',
                            style: const TextStyle(
                              color: DriverAppTheme.textLight,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            status == DriverTripStatus.accepted
                                ? (req?.pickupStage ?? 'Arua Main Market')
                                : (req?.dropoffAddress ?? 'Muni University'),
                            style: const TextStyle(
                              color: DriverAppTheme.textMuted,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Passenger Details
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: DriverAppTheme.cardDark,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: DriverAppTheme.primaryAmber.withValues(alpha: 0.2),
                      child: const Icon(Icons.person, color: DriverAppTheme.primaryAmber),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            req?.riderName ?? 'Amina Candiru',
                            style: const TextStyle(
                              color: DriverAppTheme.textLight,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            req?.riderPhone ?? '+256 701 889 900',
                            style: const TextStyle(
                              color: DriverAppTheme.textMuted,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.phone, color: DriverAppTheme.accentGreen),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Fare Summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: DriverAppTheme.surfaceDark,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Collect Fare (UGX)',
                        style: TextStyle(color: DriverAppTheme.textMuted)),
                    Text(
                      CurrencyFormatter.formatUGX(req?.fareUgx ?? 3500),
                      style: const TextStyle(
                        color: DriverAppTheme.accentGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),

              // Trip Lifecycle Step Buttons
              if (status == DriverTripStatus.accepted) ...[
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(driverTripNotifierProvider.notifier).arrivedAtPickup();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: DriverAppTheme.primaryAmber,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('ARRIVED AT PICKUP STAGE'),
                  ),
                ),
              ] else if (status == DriverTripStatus.arrivedAtPickup) ...[
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(driverTripNotifierProvider.notifier).startTrip();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: DriverAppTheme.accentGreen,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('START TRIP (PASSENGER ONBOARD)'),
                  ),
                ),
              ] else if (status == DriverTripStatus.tripInProgress) ...[
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(driverTripNotifierProvider.notifier).completeTrip();
                      _showPaymentCollectionDialog(context, ref, req?.fareUgx ?? 3500);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: DriverAppTheme.accentGreen,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('COMPLETE TRIP & COLLECT FARE'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showPaymentCollectionDialog(
    BuildContext context,
    WidgetRef ref,
    double fare,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: DriverAppTheme.cardDark,
        title: const Text(
          'Trip Completed! 🎉',
          style: TextStyle(color: DriverAppTheme.textLight),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Collect fare from passenger:',
              style: TextStyle(color: DriverAppTheme.textMuted),
            ),
            const SizedBox(height: 12),
            Text(
              CurrencyFormatter.formatUGX(fare),
              style: const TextStyle(
                color: DriverAppTheme.accentGreen,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Settlement: Cash collected or MTN MoMo confirmed',
              style: TextStyle(color: DriverAppTheme.textMuted, fontSize: 12),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              ref.read(driverTripNotifierProvider.notifier).resetToIdle();
              Navigator.pop(context); // Dialog
              context.go('/radar');
            },
            child: const Text('Back to Stage Radar'),
          ),
        ],
      ),
    );
  }
}
