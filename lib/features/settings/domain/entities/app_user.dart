enum UserRole { admin, cashier }

class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    required this.role,
    this.isActive = true,
  });

  final String id;
  final String name;
  final UserRole role;
  final bool isActive;

  bool get isAdmin => role == UserRole.admin;
}
