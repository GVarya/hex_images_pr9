import 'dart:ui';

class HexImage {
  final String id;
  final String title;
  final String? description;
  final int width;
  final int height;
  final List<List<Color>> data;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userId;

  HexImage({
    required this.id,
    required this.title,
    this.description,
    required this.width,
    required this.height,
    required this.data,
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
    List<List<Color>>? data,
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
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
    );
  }
}

// class HexImage {
//   final String id;
//   final String title;
//   final String? description;
//   final int width;
//   final int height;
//   // final dynamic data;  // List<List<Color>> или сериализованный JSON
//   final DateTime createdAt;
//   final DateTime updatedAt;
//
//   HexImage({
//     required this.id,
//     required this.title,
//     this.description,
//     required this.width,
//     required this.height,
//     // required this.data,
//     required this.createdAt,
//     required this.updatedAt,
//   });
//
//   /// Копирование с изменениями
//   HexImage copyWith({
//     String? id,
//     String? title,
//     String? description,
//     int? width,
//     int? height,
//     dynamic data,
//     DateTime? createdAt,
//     DateTime? updatedAt,
//   }) {
//     return HexImage(
//       id: id ?? this.id,
//       title: title ?? this.title,
//       description: description ?? this.description,
//       width: width ?? this.width,
//       height: height ?? this.height,
//       // data: data ?? this.data,
//       createdAt: createdAt ?? this.createdAt,
//       updatedAt: updatedAt ?? this.updatedAt,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'title': title,
//       'description': description,
//       'width': width,
//       'height': height,
//       // 'data': data,
//       'createdAt': createdAt.toIso8601String(),
//       'updatedAt': updatedAt.toIso8601String(),
//     };
//   }
//   /// Создание из JSON (для загрузки)
//   factory HexImage.fromJson(Map<String, dynamic> json) {
//     return HexImage(
//       id: json['id'] as String,
//       title: json['title'] as String,
//       description: json['description'] as String?,
//       width: json['width'] as int,
//       height: json['height'] as int,
//       // data: json['data'],  // TODO: Десериализовать в List<List<Color>>
//       createdAt: DateTime.parse(json['createdAt'] as String),
//       updatedAt: DateTime.parse(json['updatedAt'] as String),
//     );
//   }
//
//   @override
//   String toString() {
//     return 'HexImage(id: $id, title: $title, size: ${width}x${height})';
//   }
// }