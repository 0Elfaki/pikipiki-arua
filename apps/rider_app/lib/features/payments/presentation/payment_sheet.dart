import 'package:flutter/material.dart';
import '../../../app/theme.dart';
import '../data/payment_model.dart';

class PaymentMethodSheet extends StatelessWidget {
  final PaymentType selectedType;
  final ValueChanged<PaymentType> onSelected;

  const PaymentMethodSheet({
    super.key,
    required this.selectedType,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Payment Method',
                style: TextStyle(
                  color: AppTheme.textLight,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: AppTheme.textMuted),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildOption(
            context,
            type: PaymentType.cash,
            title: 'Cash Payment',
            subtitle: 'Pay directly to your Boda driver upon arrival',
            icon: Icons.payments_outlined,
            color: AppTheme.accentGreen,
          ),
          const SizedBox(height: 12),
          _buildOption(
            context,
            type: PaymentType.mtnMoMo,
            title: 'MTN Mobile Money',
            subtitle: 'Instant prompt to your MTN phone (+256)',
            icon: Icons.phone_android,
            color: const Color(0xFFFFCC00),
          ),
          const SizedBox(height: 12),
          _buildOption(
            context,
            type: PaymentType.airtelMoney,
            title: 'Airtel Money Uganda',
            subtitle: 'Instant prompt to your Airtel phone (+256)',
            icon: Icons.account_balance_wallet,
            color: const Color(0xFFFF1744),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required PaymentType type,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    final isSelected = selectedType == type;

    return InkWell(
      onTap: () {
        onSelected(type);
        Navigator.pop(context);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.surfaceDark : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.primaryAmber : Colors.white12,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppTheme.textLight,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppTheme.primaryAmber),
          ],
        ),
      ),
    );
  }
}
