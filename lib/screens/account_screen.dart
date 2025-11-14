// import 'package:flutter/material.dart';
// import 'package:get_it/get_it.dart';
// import 'package:go_router/go_router.dart';
// import '../services/images_service.dart';
// import '../widgets/app_bottom_navigation.dart';
//
// class AccountScreen extends StatelessWidget {
//   const AccountScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final service = GetIt.I<ImagesService>();
//     final user = service.currentUser;
//
//     if (user == null) {
//       return Scaffold(
//         appBar: AppBar(
//           title: const Text('Аккаунт'),
//           backgroundColor: Colors.blue.shade700,
//           foregroundColor: Colors.white,
//         ),
//         body: const Center(
//           child: Text('Пользователь не авторизован'),
//         ),
//         bottomNavigationBar: const AppBottomNavigation(currentIndex: 2),
//       );
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Аккаунт'),
//         backgroundColor: Colors.blue.shade700,
//         foregroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Card(
//               elevation: 3,
//               child: Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Column(
//                   children: [
//                     CircleAvatar(
//                       backgroundColor: Colors.blue.shade100,
//                       radius: 40,
//                       child: Text(
//                         user.username[0].toUpperCase(),
//                         style: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.blue.shade700,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     Text(
//                       user.username,
//                       style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Card(
//               elevation: 3,
//               child: Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Информация об аккаунте',
//                       style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     _buildInfoRow(
//                       icon: Icons.person,
//                       title: 'ID пользователя:',
//                       value: user.id,
//                     ),
//                     const SizedBox(height: 12),
//                     _buildInfoRow(
//                       icon: Icons.calendar_today,
//                       title: 'Дата регистрации:',
//                       value: _formatDate(user.createdAt),
//                     ),
//                     const SizedBox(height: 12),
//                     _buildInfoRow(
//                       icon: Icons.image,
//                       title: 'Количество изображений:',
//                       value: service.images.length.toString(),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 service.logout();
//                 context.go('/');
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red.shade700,
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//               ),
//               child: const Text('Выйти из аккаунта'),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: const AppBottomNavigation(currentIndex: 2),
//     );
//   }
//
//   Widget _buildInfoRow({
//     required IconData icon,
//     required String title,
//     required String value,
//   }) {
//     return Row(
//       children: [
//         Icon(icon, color: Colors.blue.shade700, size: 20),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.grey.shade600,
//                 ),
//               ),
//               Text(
//                 value,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   String _formatDate(DateTime date) {
//     return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/providers.dart';
import '../widgets/app_bottom_navigation.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final images = ref.watch(imagesListProvider);
    final auth = ref.read(authProvider);

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Аккаунт'),
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Text('Пользователь не авторизован'),
        ),
        bottomNavigationBar: const AppBottomNavigation(currentIndex: 2),
      );
    }

    final userImages = images.where((img) => img.userId == user.id).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Аккаунт'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blue.shade100,
                      radius: 40,
                      child: Text(
                        user.username[0].toUpperCase(),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user.username,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Информация об аккаунте',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      icon: Icons.person,
                      title: 'ID пользователя:',
                      value: user.id,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      icon: Icons.calendar_today,
                      title: 'Дата регистрации:',
                      value: _formatDate(user.createdAt),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      icon: Icons.image,
                      title: 'Количество изображений:',
                      value: userImages.length.toString(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                auth.logout();
                context.go('/');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Выйти из аккаунта'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 2),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue.shade700, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}