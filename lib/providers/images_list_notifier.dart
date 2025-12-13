
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/hex_image.dart';

class ImagesNotifier extends StateNotifier<List<HexImage>> {
  ImagesNotifier() : super([]) {
    _initializeSampleData();
  }

  void _initializeSampleData() {
    final now = DateTime.now();
    state = [
      HexImage(
        id: '1',
        title: 'Из 1',
        description: 'Тестовый проект',
        width: 16,
        height: 16,
        data: [[]],
        userId: 'user123',
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
      HexImage(
        id: '1',
        title: 'Новый первый проект',
        description: 'Тестовый проект',
        width: 16,
        height: 16,
        data: [[]],
        userId: 'user123',
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(days: 2)),
      ),
      HexImage(
        id: '2',
        title: 'Летний закат',
        description: 'Пейзаж',
        width: 20,
        height: 20,
        data: [[]],
        userId: 'user123',
        createdAt: now.subtract(const Duration(days: 10)),
        updatedAt: now.subtract(const Duration(days: 1)),
      ),
    ];
  }

  void addImage(HexImage image) {
    state = [...state, image];
  }

  void updateImage(HexImage image) {
    state = [
    for (final img in state)
      if (img.id == image.id) image else img,
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

  List getImagesByUser(String userId) {
  return state.where((img) => img.userId == userId).toList();
  }

  void clearAll() {
   state = [];
  }
}
