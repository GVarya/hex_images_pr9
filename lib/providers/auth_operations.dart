import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/user.dart';
import 'providers.dart';

class AuthOperations {
  final Ref ref;

  AuthOperations(this.ref);

  void login(String username, String password) {
    final user = User(
      id: '1',
      username: username,
      createdAt: DateTime.now(),
    );
    ref.read(currentUserProvider.notifier).state = user;
  }

  void register(String username, String password) {
    final user = User(
      id: '1',
      username: username,
      createdAt: DateTime.now(),
    );
    ref.read(currentUserProvider.notifier).state = user;
  }

  void logout() {
    ref.read(currentUserProvider.notifier).state = null;
    ref.read(imagesListProvider.notifier).clearImages();
  }
}
