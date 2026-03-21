class User {
  final int id;
  final String name;
  final String email;
  final List<String> roles;
  final List<String> permissions;
  final DateTime? createdAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.roles,
    required this.permissions,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      roles: (json['roles'] as Iterable?)?.map((e) => e.toString()).toList() ?? [],
      permissions: (json['permissions'] as Iterable?)?.map((e) => e.toString()).toList() ?? [],
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, roles: $roles)';
  }
}
