class User {
  final String id;
  final String username;
  final DateTime createdAt;

  User({
    required this.id,
    required this.username,
    required this.createdAt,
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
    );
  }
}