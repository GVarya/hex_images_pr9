import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/hex_image.dart';
import 'providers.dart';

class ImageOperations {
  final Ref ref;

  ImageOperations(this.ref);

  void createImage({
    required String title,
    String? description,
    required int width,
    required int height,
  }) {
    final user = ref.read(currentUserProvider);
    if (user == null) throw Exception('User not logged in');

    ref.read(imagesListProvider.notifier).createImage(
      title: title,
      description: description,
      width: width,
      height: height,
      userId: user.id,
    );
  }

  void updateImage(HexImage updatedImage) {
    ref.read(imagesListProvider.notifier).updateImage(updatedImage);
  }

  void deleteImage(String id) {
    ref.read(imagesListProvider.notifier).deleteImage(id);
  }

  HexImage? getImageById(String id) {
    return ref.read(imagesListProvider.notifier).getImageById(id);
  }

  List<HexImage> getUserImages() {
    final user = ref.read(currentUserProvider);
    if (user == null) return [];
    return ref.read(imagesListProvider.notifier).getImagesByUser(user.id);
  }
}