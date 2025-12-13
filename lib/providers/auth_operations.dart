// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import '../model/user.dart';
// import 'providers.dart';
//
// class AuthOperations {
//   final Ref ref;
//
//   AuthOperations(this.ref);
//
//   void login(String username, String password) {
//     final user = User(
//       id: '1',
//       username: username,
//       createdAt: DateTime.now(),
//     );
//     ref.read(currentUserProvider.notifier).state = user;
//   }
//
//   void register(String username, String password) {
//     final user = User(
//       id: '1',
//       username: username,
//       createdAt: DateTime.now(),
//     );
//     ref.read(currentUserProvider.notifier).state = user;
//   }
//
//   void logout() {
//     ref.read(currentUserProvider.notifier).state = null;
//     ref.read(imagesListProvider.notifier).clearImages();
//   }
// }


import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/user.dart';


class AuthOperations {
  static final Map<String, String> _users = {
    'demo': 'password123',
    'test': 'test123',
    'v': 'v'
  };
  User? _currentUser;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  bool login(String username, String password) {
    if (_users.containsKey(username) && _users[username] == password) {
      _currentUser = User(
        id: _generateId(),
        username: username,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        lastLogin: DateTime.now(),
      );
      print('Вход успешен: $username');
      return true;
    }

    print('Неверные учётные данные');
    return false;
  }

  bool register(String username, String password) {
    if (_users.containsKey(username)) {
      print('Пользователь уже существует: $username');
      return false;
    }

    if (username.isEmpty || password.isEmpty) {
      print('Имя пользователя и пароль не могут быть пустыми');
      return false;
    }

    if (password.length < 6) {
      print('Пароль должен быть не менее 6 символов');
      return false;
    }

    _users[username] = password;
    _currentUser = User(
      id: _generateId(),
      username: username,
      createdAt: DateTime.now(),
      lastLogin: DateTime.now(),
    );

    print('Регистрация успешна: $username');
    return true;
  }

  void logout() {
    print('Выход пользователя: ${_currentUser?.username}');
    _currentUser = null;
  }

  bool changePassword(String oldPassword, String newPassword) {
    if (_currentUser == null) {
      print('Пользователь не авторизован');
      return false;
    }

    if (_users[_currentUser!.username] != oldPassword) {
      print('Неверный текущий пароль');
      return false;
    }

    if (newPassword.length < 6) {
      print('Новый пароль должен быть не менее 6 символов');
      return false;
    }

    _users[_currentUser!.username] = newPassword;
    print('Пароль изменён для: ${_currentUser!.username}');
    return true;
  }

  User? getProfile() {
    if (_currentUser == null) {
      print('Пользователь не авторизован');
      return null;
    }
    return _currentUser;
  }

  bool updateProfile({
    required String username,
    String? email,
  }) {
    if (_currentUser == null) {
      print('Пользователь не авторизован');
      return false;
    }

    _currentUser = User(
      id: _currentUser!.id,
      username: username,
      createdAt: _currentUser!.createdAt,
      lastLogin: DateTime.now(),
    );

    print('Профиль обновлен: $username');
    return true;
  }

  bool isSessionValid() {
    return _currentUser != null;
  }

  List<String> getAllUsers() {
    return _users.keys.toList();
  }

  bool deleteAccount(String password) {
    if (_currentUser == null) {
      print('Пользователь не авторизован');
      return false;
    }

    if (_users[_currentUser!.username] != password) {
      print('Неверный пароль');
      return false;
    }

    final username = _currentUser!.username;
    _users.remove(username);
    _currentUser = null;

    print('Аккаунт удален: $username');
    return true;
  }

  static String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  return AuthStateNotifier();
});


enum AuthState {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}


class AuthStateNotifier extends StateNotifier<AuthState> {
  AuthStateNotifier() : super(AuthState.initial);

  final _authOps = AuthOperations();

  Future<bool> loginWithState(String username, String password) async {
    state = AuthState.loading;

    try {
      await Future.delayed(const Duration(seconds: 1));

      final success = _authOps.login(username, password);
      if (success) {
        state = AuthState.authenticated;
      } else {
        state = AuthState.unauthenticated;
      }
      return success;
    } catch (e) {
      state = AuthState.error;
      print('Ошибка входа: $e');
      return false;
    }
  }

  Future<bool> registerWithState(String username, String password) async {
    state = AuthState.loading;

    try {
      await Future.delayed(const Duration(seconds: 1));

      final success = _authOps.register(username, password);
      if (success) {
        state = AuthState.authenticated;
      } else {
        state = AuthState.unauthenticated;
      }
      return success;
    } catch (e) {
      state = AuthState.error;
      print('Ошибка регистрации: $e');
      return false;
    }
  }

  void logout() {
    _authOps.logout();
    state = AuthState.unauthenticated;
  }

  User? getCurrentUser() {
    return _authOps.currentUser;
  }

  bool isAuthenticated() {
    return _authOps.isAuthenticated;
  }
}

