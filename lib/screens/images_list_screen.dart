import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/image_operations.dart';
import '../providers/providers.dart';
import '../model/hex_image.dart';
import '../widgets/app_bottom_navigation.dart';
import '../widgets/image_item.dart';

class ImagesListScreen extends ConsumerWidget {
  const ImagesListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final allImages = ref.watch(imagesListProvider);
    final imageOps = ref.read(imageOperationsProvider);

    final userImages = user != null
        ? allImages.where((img) => img.userId == user.id).toList()
        : [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои изображения'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: userImages.isEmpty
          ? _buildEmptyState(context)
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: userImages.length,
        itemBuilder: (context, index) {
          final image = userImages[index];
          return ImageItem(
            image: image,
            onTap: () {
              context.push('/home/editor/${image.id}');
            },
            onDelete: () {
              _showDeleteDialog(context, image, imageOps);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/home/editor');
        },
        tooltip: 'Создать изображение',
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 0),
    );
  }

  void _showDeleteDialog(BuildContext context, HexImage image, ImageOperations imageOps) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить изображение?'),
        content: Text(
          'Вы уверены, что хотите удалить изображение "${image.title}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              imageOps.deleteImage(image.id);
              Navigator.pop(context);
            },
            child: const Text(
              'Удалить',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.hexagon_outlined,
              size: 80,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 20),
            Text(
              'У вас пока нет изображений',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Создайте первое изображение, нажав на кнопку ниже',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                context.push('/home/editor');
              },
              icon: const Icon(Icons.add),
              label: const Text('Создать изображение'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}