import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/user.dart';
import '../model/hex_image.dart';
import 'auth_operations.dart';
import 'image_operations.dart';
import 'images_list_notifier.dart';

final currentUserProvider = StateProvider<User?>((ref) => null);

final imagesListProvider = StateNotifierProvider<ImagesListNotifier, List<HexImage>>((ref) {
  return ImagesListNotifier();
});

final authProvider = Provider<AuthOperations>((ref) {
  return AuthOperations(ref);
});

final imageOperationsProvider = Provider<ImageOperations>((ref) {
  return ImageOperations(ref);
});

