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




