

import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hex_images/providers/providers.dart';
import '../model/hex_image.dart';

class ImageOperations {
  final Ref ref;

  ImageOperations(this.ref);

  List getUserImages() {
    final user = ref.read(currentUserProvider);
    final allImages = ref.read(imagesListProvider);

    if (user == null) return [];
    return allImages.where((img) => img.userId == user.id).toList();
  }

  HexImage? getImageById(String id) {
    final allImages = ref.read(imagesListProvider);
    try {
      return allImages.firstWhere((img) => img.id == id);
    } catch (e) {
      return null;
    }
  }

  String createImage({
    required String title,
    String? description,
    required int width,
    required int height,
    List<List<Color>>? data,
  }) {
    final user = ref.read(currentUserProvider);

    if (user == null) {
      return '';
    }

    final newImage = HexImage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      width: width,
      height: height,
      data: data ?? [[]],
      userId: user.id,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    ref.read(imagesListProvider.notifier).addImage(newImage);
    return newImage.id;
  }

  void updateImage(HexImage image) {
    ref.read(imagesListProvider.notifier).updateImage(image);
  }

  void deleteImage(String id) {
    ref.read(imagesListProvider.notifier).deleteImage(id);
  }
}
