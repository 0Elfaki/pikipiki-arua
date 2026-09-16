enum PaymentType {
  cash,
  mtnMoMo,
  airtelMoney,
}

class PaymentOption {
  final PaymentType type;
  final String title;
  final String subtitle;
  final String iconAsset;

  const PaymentOption({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.iconAsset,
  });
}
