import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/hex_image.dart';
import '../model/user.dart';
import 'auth_operations.dart';
import 'image_operations.dart';
import 'images_list_notifier.dart';

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  return AuthStateNotifier();
});

final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);

  if (authState.isAuthenticated) {
    return authState.user;
  }
  return null;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.isAuthenticated;
});

final imagesListProvider = StateNotifierProvider<ImagesNotifier, List<HexImage>>((ref) {
  return ImagesNotifier();
});

final imageOperationsProvider = Provider((ref) {
  return ImageOperations(ref);
});