// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../model/user.dart';
// import '../model/hex_image.dart';
// import 'auth_operations.dart';
// import 'image_operations.dart';
// import 'images_list_notifier.dart';
//
// final currentUserProvider = StateProvider<User?>((ref) => null);
//
// final imagesListProvider = StateNotifierProvider<ImagesListNotifier, List<HexImage>>((ref) {
//   return ImagesListNotifier();
// });
//
// final authProvider = Provider<AuthOperations>((ref) {
//   return AuthOperations(ref);
// });
//
// // final imageOperationsProvider = Provider<ImageOperations>((ref) {
// //   return ImageOperations(ref);
// // });
//
//
// /// Provider для операций с изображениями
// /// ✅ Сохраняет вашу логику работы с imageId и данными
//
// final imageOperationsProvider = Provider((ref) {
//   return ImageOperations();
// });
//
// class ImageOperations {
//   static final Map<String, HexImage> _images = {};
//   String createImage({
//     required String title,
//     String? description,
//     required int width,
//     required int height,
//     required dynamic data,
//   }) {
//     final id = DateTime.now().millisecondsSinceEpoch.toString();
//     final now = DateTime.now();
//
//     _images[id] = HexImage(
//       id: id,
//       title: title,
//       description: description,
//       width: width,
//       height: height,
//       // data: data,
//       createdAt: now,
//       updatedAt: now,
//       userId: '',
//     );
//
//     print('✅ Создано новое изображение: $id - $title');
//     return id;
//   }
//
//   /// Получить изображение по ID
//   /// Используется в ImageEditorScreen._loadImageData()
//   HexImage? getImageById(String id) {
//     final image = _images[id];
//     if (image != null) {
//       print('✅ Загружено изображение: $id - ${image.title}');
//     } else {
//       print('❌ Изображение не найдено: $id');
//     }
//     return image;
//   }
//
//   /// Обновить существующее изображение
//   /// Используется когда imageId != null
//   void updateImage(HexImage image) {
//     if (_images.containsKey(image.id)) {
//       _images[image.id] = image;
//       print('✅ Обновлено изображение: ${image.id} - ${image.title}');
//     } else {
//       print('❌ Изображение для обновления не найдено: ${image.id}');
//     }
//   }
//
//   /// Удалить изображение
//   void deleteImage(String id) {
//     _images.remove(id);
//     print('✅ Удалено изображение: $id');
//   }
//
//   /// Получить все изображения
//   List<HexImage> getAllImages() {
//     return _images.values.toList();
//   }
//
//   /// Поиск по названию
//   List<HexImage> searchImages(String query) {
//     return _images.values
//         .where(
//           (img) => img.title.toLowerCase().contains(query.toLowerCase()),
//     )
//         .toList();
//   }
//
//   /// Очистить все (для тестирования)
//   void clearAll() {
//     _images.clear();
//     print('✅ Все изображения очищены');
//   }
// }


import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/hex_image.dart';
import '../model/user.dart';
import 'auth_operations.dart';
import 'image_operations.dart';
import 'images_list_notifier.dart';


final authProvider = Provider((ref) => AuthOperations());

final isAuthenticatedProvider = StateProvider<bool>((ref) => false);

final currentUserProvider = StateProvider<User?>((ref) => null);

final imagesListProvider = StateNotifierProvider<ImagesNotifier, List<HexImage>>((ref) {
  return ImagesNotifier();

});

final imageOperationsProvider = Provider((ref) {
  return ImageOperations(ref);
});




