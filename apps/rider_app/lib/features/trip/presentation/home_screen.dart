import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../auth/application/auth_notifier.dart';
import '../application/trip_notifier.dart';
import 'widgets/stage_selector_card.dart';
import '../../payments/data/payment_model.dart';
import '../../payments/presentation/payment_sheet.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  PaymentType _selectedPaymentType = PaymentType.cash;

  @override
  Widget build(BuildContext context) {
    final tripState = ref.watch(tripNotifierProvider);
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      body: Stack(
        children: [
          // Simulated Interactive Map Canvas (Arua City Center)
          Positioned.fill(
            child: Container(
              color: const Color(0xFF191F26),
              child: Stack(
                children: [
                  // Map Grid Lines & Roads Representation
                  CustomPaint(
                    size: Size.infinite,
                    painter: _AruaMapPainter(),
                  ),
                  // Boda Stage Markers
                  ...tripState.stages.map((stage) {
                    final isPickup = stage.id == tripState.selectedPickupStage?.id;
                    final isDropoff = stage.id == tripState.selectedDropoffStage?.id;
                    return Positioned(
                      left: 60 + ((stage.longitude - 30.89) * 1200) % 280,
                      top: 120 + ((stage.latitude - 3.01) * 2000) % 320,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: isPickup
                                  ? AppTheme.accentGreen
                                  : (isDropoff ? AppTheme.primaryAmber : Colors.white24),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: (isPickup
                                          ? AppTheme.accentGreen
                                          : AppTheme.primaryAmber)
                                      .withOpacity(0.4),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Icon(
                              isPickup
                                  ? Icons.my_location
                                  : (isDropoff ? Icons.location_on : Icons.two_wheeler),
                              color: Colors.black,
                              size: 16,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              stage.name.replaceAll(' Stage', ''),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          // Top Header Bar
          Positioned(
            top: 48,
            left: 16,
            right: 16,
            child: Row(
              children: [
                // Profile Avatar Button
                InkWell(
                  onTap: () => context.push('/profile'),
                  borderRadius: BorderRadius.circular(25),
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.primaryAmber, width: 2),
                    ),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: AppTheme.surfaceDark,
                      child: const Icon(Icons.person, color: AppTheme.primaryAmber),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Location Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceDark.withOpacity(0.92),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.location_city, color: AppTheme.primaryAmber, size: 16),
                      SizedBox(width: 6),
                      Text(
                        'Arua City, Uganda',
                        style: TextStyle(
                          color: AppTheme.textLight,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Emergency SOS Button
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.accentRed.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.shield_outlined, color: AppTheme.accentRed),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Pikipiki Safety: Direct line to Arua Police & Stage Chairman ready.'),
                          backgroundColor: AppTheme.surfaceDark,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Bottom Ride Booking Sheet
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.cardDark,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stage Selectors
                  StageSelectorCard(
                    label: 'PICKUP STAGE',
                    icon: Icons.radio_button_checked,
                    iconColor: AppTheme.accentGreen,
                    selectedStage: tripState.selectedPickupStage,
                    availableStages: tripState.stages,
                    onStageChanged: (stage) =>
                        ref.read(tripNotifierProvider.notifier).selectPickup(stage),
                  ),
                  const SizedBox(height: 10),
                  StageSelectorCard(
                    label: 'DROPOFF DESTINATION',
                    icon: Icons.location_on,
                    iconColor: AppTheme.primaryAmber,
                    selectedStage: tripState.selectedDropoffStage,
                    availableStages: tripState.stages,
                    onStageChanged: (stage) =>
                        ref.read(tripNotifierProvider.notifier).selectDropoff(stage),
                  ),
                  const SizedBox(height: 16),

                  // Fare & Payment Selector Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Estimated Boda Fare',
                            style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
                          ),
                          Text(
                            CurrencyFormatter.formatUGX(tripState.estimatedFareUgx),
                            style: const TextStyle(
                              color: AppTheme.textLight,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (_) => PaymentMethodSheet(
                              selectedType: _selectedPaymentType,
                              onSelected: (type) {
                                setState(() => _selectedPaymentType = type);
                              },
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceDark,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _selectedPaymentType == PaymentType.cash
                                    ? Icons.payments_outlined
                                    : Icons.phone_android,
                                color: AppTheme.primaryAmber,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _selectedPaymentType == PaymentType.cash
                                    ? 'Cash'
                                    : (_selectedPaymentType == PaymentType.mtnMoMo
                                        ? 'MTN MoMo'
                                        : 'Airtel Money'),
                                style: const TextStyle(
                                  color: AppTheme.textLight,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              const Icon(Icons.arrow_drop_down, color: AppTheme.textMuted),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Request Boda Button
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: tripState.isLoading
                          ? null
                          : () async {
                              final riderId = authState.user?.id ?? 'guest-rider-01';
                              final trip = await ref
                                  .read(tripNotifierProvider.notifier)
                                  .requestBodaRide(
                                    riderId: riderId,
                                    paymentMethod: _selectedPaymentType.name,
                                  );
                              if (trip != null && context.mounted) {
                                context.push('/trip-active');
                              }
                            },
                      icon: tripState.isLoading
                          ? const SizedBox.shrink()
                          : const Icon(Icons.two_wheeler, color: Colors.black),
                      label: tripState.isLoading
                          ? const CircularProgressIndicator(color: Colors.black)
                          : const Text(
                              'Request Pikipiki Boda',
                              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AruaMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = const Color(0xFF2C353F)
      ..strokeWidth = 6.0
      ..style = PaintingStyle.stroke;

    final secondaryRoadPaint = Paint()
      ..color = const Color(0xFF222B34)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    // Rhino Camp Road & Arua Main Arteries
    canvas.drawLine(
      Offset(0, size.height * 0.4),
      Offset(size.width, size.height * 0.45),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.5, 0),
      Offset(size.width * 0.45, size.height),
      roadPaint,
    );

    // Diagonal Avenues to Muni & Onduparaka
    canvas.drawLine(
      Offset(0, 0),
      Offset(size.width, size.height * 0.7),
      secondaryRoadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.2, size.height),
      Offset(size.width * 0.8, 0),
      secondaryRoadPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
