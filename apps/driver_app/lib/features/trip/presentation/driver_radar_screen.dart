import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../auth/application/driver_auth_notifier.dart';
import '../application/driver_trip_notifier.dart';
import '../data/driver_trip_model.dart';

class DriverRadarScreen extends ConsumerWidget {
  const DriverRadarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(driverAuthNotifierProvider);
    final tripState = ref.watch(driverTripNotifierProvider);
    final driver = authState.driver;
    final isOnline = authState.isOnline;

    return Scaffold(
      backgroundColor: DriverAppTheme.primaryDark,
      body: SafeArea(
        child: Stack(
          children: [
            // Main Content Area
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Column(
                children: [
                  // Top Status Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            driver?.fullName ?? 'Boda Operator',
                            style: const TextStyle(
                              color: DriverAppTheme.textLight,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  color: DriverAppTheme.primaryAmber, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                driver?.stageName ?? 'Arua Hill Stage',
                                style: const TextStyle(
                                  color: DriverAppTheme.textMuted,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // Profile Avatar
                      InkWell(
                        onTap: () => context.push('/profile'),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: DriverAppTheme.primaryAmber.withValues(alpha: 0.2),
                          child: const Icon(Icons.person,
                              color: DriverAppTheme.primaryAmber, size: 22),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Today's Stats Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    decoration: BoxDecoration(
                      color: DriverAppTheme.surfaceDark,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () => context.push('/earnings'),
                          child: Column(
                            children: [
                              const Text('Today Earnings',
                                  style: TextStyle(
                                      color: DriverAppTheme.textMuted, fontSize: 11)),
                              const SizedBox(height: 4),
                              Text(
                                CurrencyFormatter.formatUGX(tripState.todayEarningsUgx),
                                style: const TextStyle(
                                  color: DriverAppTheme.accentGreen,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(width: 1, height: 30, color: Colors.white12),
                        Column(
                          children: [
                            const Text('Completed Rides',
                                style: TextStyle(
                                    color: DriverAppTheme.textMuted, fontSize: 11)),
                            const SizedBox(height: 4),
                            Text(
                              '${tripState.completedTripsToday} Trips',
                              style: const TextStyle(
                                color: DriverAppTheme.textLight,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),

                  // Central Radar Visualizer
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isOnline
                                  ? DriverAppTheme.accentGreen.withValues(alpha: 0.5)
                                  : Colors.white12,
                              width: 3,
                            ),
                            color: isOnline
                                ? DriverAppTheme.accentGreen.withValues(alpha: 0.08)
                                : DriverAppTheme.surfaceDark,
                          ),
                          child: Icon(
                            isOnline ? Icons.radar : Icons.power_settings_new,
                            size: 68,
                            color: isOnline
                                ? DriverAppTheme.accentGreen
                                : DriverAppTheme.textMuted,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          isOnline ? 'Scanning for Arua Riders...' : 'You are currently OFFLINE',
                          style: TextStyle(
                            color: isOnline ? DriverAppTheme.textLight : DriverAppTheme.textMuted,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          isOnline
                              ? 'Stage Queue Position: #2 (Ready for dispatch)'
                              : 'Go online to receive nearby passenger requests',
                          style: const TextStyle(
                            color: DriverAppTheme.textMuted,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),

                  // Online / Offline Toggle Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ref.read(driverAuthNotifierProvider.notifier).toggleOnlineStatus();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isOnline
                            ? DriverAppTheme.accentRed
                            : DriverAppTheme.accentGreen,
                        foregroundColor: Colors.black,
                      ),
                      icon: Icon(
                        isOnline ? Icons.pause_circle_outline : Icons.play_circle_outline,
                        color: Colors.black,
                      ),
                      label: Text(
                        isOnline ? 'GO OFFLINE' : 'GO ONLINE & RECEIVE RIDES',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Simulate Incoming Ride for testing
                  if (isOnline && tripState.status == DriverTripStatus.idle) ...[
                    OutlinedButton.icon(
                      onPressed: () {
                        ref.read(driverTripNotifierProvider.notifier).simulateIncomingRide();
                      },
                      icon: const Icon(Icons.ring_volume, color: DriverAppTheme.primaryAmber),
                      label: const Text(
                        'Simulate Incoming Ride Request',
                        style: TextStyle(color: DriverAppTheme.primaryAmber),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: DriverAppTheme.primaryAmber),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Incoming Ride Request Modal Overlay
            if (tripState.status == DriverTripStatus.incoming &&
                tripState.incomingRequest != null) ...[
              _buildIncomingRideModal(context, ref, tripState.incomingRequest!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIncomingRideModal(
    BuildContext context,
    WidgetRef ref,
    IncomingTripRequest req,
  ) {
    return Container(
      color: Colors.black.withValues(alpha: 0.8),
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: DriverAppTheme.cardDark,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: DriverAppTheme.primaryAmber, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notification_important, color: DriverAppTheme.primaryAmber),
                  SizedBox(width: 8),
                  Text(
                    'INCOMING BODA REQUEST',
                    style: TextStyle(
                      color: DriverAppTheme.primaryAmber,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                CurrencyFormatter.formatUGX(req.fareUgx),
                style: const TextStyle(
                  color: DriverAppTheme.textLight,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                req.paymentMethod,
                style: const TextStyle(color: DriverAppTheme.textMuted, fontSize: 13),
              ),
              const Divider(color: Colors.white12, height: 32),

              // Route Info
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.radio_button_checked,
                      color: DriverAppTheme.accentGreen, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Pickup Stage',
                            style: TextStyle(
                                color: DriverAppTheme.textMuted, fontSize: 11)),
                        Text(
                          req.pickupStage,
                          style: const TextStyle(
                            color: DriverAppTheme.textLight,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on,
                      color: DriverAppTheme.primaryAmber, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Destination',
                            style: TextStyle(
                                color: DriverAppTheme.textMuted, fontSize: 11)),
                        Text(
                          req.dropoffAddress,
                          style: const TextStyle(
                            color: DriverAppTheme.textLight,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Accept / Reject Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        ref.read(driverTripNotifierProvider.notifier).rejectTrip();
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: DriverAppTheme.accentRed),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Decline',
                          style: TextStyle(color: DriverAppTheme.accentRed)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(driverTripNotifierProvider.notifier).acceptTrip();
                        context.push('/navigation');
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: DriverAppTheme.accentGreen,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text(
                        'ACCEPT RIDE',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
