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

  static String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? error;

  const AuthState._({
    required this.status,
    this.user,
    this.error,
  });

  factory AuthState.initial() => const AuthState._(status: AuthStatus.initial);
  factory AuthState.loading() => const AuthState._(status: AuthStatus.loading);
  factory AuthState.authenticated(User user) =>
      AuthState._(status: AuthStatus.authenticated, user: user);
  factory AuthState.unauthenticated() =>
      const AuthState._(status: AuthStatus.unauthenticated);
  factory AuthState.error(String error) =>
      AuthState._(status: AuthStatus.error, error: error);

  bool get isInitial => status == AuthStatus.initial;
  bool get isLoading => status == AuthStatus.loading;
  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isUnauthenticated => status == AuthStatus.unauthenticated;
  bool get isError => status == AuthStatus.error;
}

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthStateNotifier extends StateNotifier<AuthState> {
  final AuthOperations _authOps = AuthOperations();

  AuthStateNotifier() : super(AuthState.initial());

  Future<bool> loginWithState(String username, String password) async {
    state = AuthState.loading();

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final success = _authOps.login(username, password);
      if (success && _authOps.currentUser != null) {
        state = AuthState.authenticated(_authOps.currentUser!);
        return true;
      } else {
        state = AuthState.unauthenticated();
        return false;
      }
    } catch (e) {
      state = AuthState.error('Ошибка входа: $e');
      print('Ошибка входа: $e');
      return false;
    }
  }

  Future<bool> registerWithState(String username, String password) async {
    state = AuthState.loading();

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final success = _authOps.register(username, password);
      if (success && _authOps.currentUser != null) {
        state = AuthState.authenticated(_authOps.currentUser!);
        return true;
      } else {
        state = AuthState.unauthenticated();
        return false;
      }
    } catch (e) {
      state = AuthState.error('Ошибка регистрации: $e');
      print('Ошибка регистрации: $e');
      return false;
    }
  }

  void logout() {
    _authOps.logout();
    state = AuthState.unauthenticated();
  }

  User? getCurrentUser() {
    return _authOps.currentUser;
  }

  bool isAuthenticated() {
    return _authOps.isAuthenticated;
  }
}