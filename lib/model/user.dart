class User {
  final String id;
  final String username;
  final DateTime createdAt;
  final DateTime lastLogin;


  User({
    required this.id,
    required this.username,
    required this.createdAt,
    required this.lastLogin,
  });

  User copyWith({
    String? id,
    String? username,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }
}