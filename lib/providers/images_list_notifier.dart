import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/hex_image.dart';

class ImagesNotifier extends StateNotifier<List<HexImage>> {
  ImagesNotifier() : super([]);

  void addImage(HexImage image) {
    state = [...state, image];
  }

  void updateImage(HexImage image) {
    state = [
      for (final img in state)
        if (img.id == image.id) image.copyWith(updatedAt: DateTime.now()) else img,
    ];
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

  void clearAll() {
    state = [];
  }
}