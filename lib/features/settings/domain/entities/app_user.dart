enum UserRole { admin, cashier }

class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    required this.role,
    this.isActive = true,
    this.mustChangePin = false,
    this.failedAttempts = 0,
    this.lockedUntil,
  });

  final String id;
  final String name;
  final UserRole role;
  final bool isActive;

  /// true untuk admin seed pertama kali (wajib ganti PIN saat login awal).
  final bool mustChangePin;

  /// Lockout: 5x salah → kunci 5 menit (dikelola repository/Fase 1).
  final int failedAttempts;
  final DateTime? lockedUntil;

  bool get isAdmin => role == UserRole.admin;

  bool get isLocked =>
      lockedUntil != null && lockedUntil!.isAfter(DateTime.now());

  AppUser copyWith({
    String? name,
    UserRole? role,
    bool? isActive,
    bool? mustChangePin,
    int? failedAttempts,
    DateTime? lockedUntil,
  }) =>
      AppUser(
        id: id,
        name: name ?? this.name,
        role: role ?? this.role,
        isActive: isActive ?? this.isActive,
        mustChangePin: mustChangePin ?? this.mustChangePin,
        failedAttempts: failedAttempts ?? this.failedAttempts,
        lockedUntil: lockedUntil ?? this.lockedUntil,
      );
}
