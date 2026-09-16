class AppUser {
  final String id;
  final String phoneNumber;
  final String fullName;
  final String? avatarUrl;
  final String role;
  final double rating;

  const AppUser({
    required this.id,
    required this.phoneNumber,
    required this.fullName,
    this.avatarUrl,
    this.role = 'rider',
    this.rating = 5.0,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      phoneNumber: json['phone_number'] as String? ?? '',
      fullName: json['full_name'] as String? ?? 'Rider',
      avatarUrl: json['avatar_url'] as String?,
      role: json['role'] as String? ?? 'rider',
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'phone_number': phoneNumber,
        'full_name': fullName,
        'avatar_url': avatarUrl,
        'role': role,
        'rating': rating,
      };
}
