import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'theme.dart';
import 'providers/providers.dart';

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

    return MaterialApp(
      title: 'Hex Image Editor',
      theme: AppTheme.lightTheme,
      home: authState.isLoading
          ? const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      )
          : authState.isAuthenticated
          ? const HomeScreen()
          : const AuthScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}