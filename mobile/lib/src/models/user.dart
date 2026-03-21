class User {
  final int id;
  final String name;
  final String email;
  final List<String> roles;
  final List<String> permissions;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.roles,
    required this.permissions,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      roles: (json['roles'] as List? ?? []).map((e) => '$e').toList(),
      permissions: (json['permissions'] as List? ?? []).map((e) => '$e').toList(),
    );
  }
}
