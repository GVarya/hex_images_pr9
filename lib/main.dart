import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hex_images/providers/auth_operations.dart';
import 'package:hex_images/providers/providers.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    final currentUser = ref.watch(currentUserProvider);

    return MaterialApp(
      title: 'Hex Image Editor',
      theme: AppTheme.lightTheme,
      home: currentUser != null ? const HomeScreen() : const AuthScreen(),
    );
  }
}
