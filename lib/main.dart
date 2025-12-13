// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:hex_images/screens/account_screen.dart';
// import 'package:hex_images/screens/auth_screen.dart';
// import 'package:hex_images/screens/effects_screen.dart';
// import 'package:hex_images/screens/image_editor_screen.dart';
// import 'package:hex_images/screens/images_list_screen.dart' hide ImageEditorScreen;
// import 'theme.dart';
//
// void main() {
//   runApp(const ProviderScope(child: MyApp()));
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp.router(
//       title: 'Hex Pixel Art',
//       theme: AppTheme.lightTheme,
//       routerConfig: _router,
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
//
// final GoRouter _router = GoRouter(
//   routes: [
//     GoRoute(
//       path: '/',
//       name: 'auth',
//       builder: (context, state) => const AuthScreen(),
//     ),
//     GoRoute(
//       path: '/home',
//       name: 'home',
//       builder: (context, state) => const ImagesListScreen(),
//       routes: [
//         GoRoute(
//           path: 'editor/:id',
//           name: 'edit_image',
//           builder: (context, state) {
//             final imageId = state.pathParameters['id']!;
//             return ImageEditorScreen(imageId: imageId);
//           },
//         ),
//         GoRoute(
//           path: 'editor',
//           name: 'create_image',
//           builder: (context, state) => const ImageEditorScreen(),
//         ),
//       ],
//     ),
//     GoRoute(
//       path: '/effects',
//       name: 'effects',
//       builder: (context, state) => const EffectsScreen(),
//     ),
//     GoRoute(
//       path: '/account',
//       name: 'account',
//       builder: (context, state) => const AccountScreen(),
//     ),
//   ],
// );

// lib/main.dart

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
