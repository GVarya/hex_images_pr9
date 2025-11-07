class HexImage {
  final String id;
  final String title;
  final String? description;
  final int width;
  final int height;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userId;

  HexImage({
    required this.id,
    required this.title,
    this.description,
    required this.width,
    required this.height,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });

  HexImage copyWith({
    String? id,
    String? title,
    String? description,
    int? width,
    int? height,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
  }) {
    return HexImage(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      width: width ?? this.width,
      height: height ?? this.height,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
    );
  }
}