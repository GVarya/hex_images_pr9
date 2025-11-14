import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/hex_image.dart';

class ImagesListNotifier extends StateNotifier<List<HexImage>> {
  ImagesListNotifier() : super([]);

  void createImage({
    required String title,
    String? description,
    required int width,
    required int height,
    required String userId,
  }) {
    final image = HexImage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      description: description,
      width: width,
      height: height,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      userId: userId,
    );

    state = [...state, image];
  }

  void updateImage(HexImage updatedImage) {
    final index = state.indexWhere((img) => img.id == updatedImage.id);
    if (index != -1) {
      final newImage = updatedImage.copyWith(updatedAt: DateTime.now());
      final newList = [...state];
      newList[index] = newImage;
      state = newList;
    }
  }

  void deleteImage(String id) {
    state = state.where((img) => img.id != id).toList();
  }

  HexImage? getImageById(String id) {
    try {
      return state.firstWhere((img) => img.id == id);
    } catch (e) {
      return null;
    }
  }

  List<HexImage> getImagesByUser(String userId) {
    return state.where((img) => img.userId == userId).toList();
  }

  void clearImages() {
    state = [];
  }
}