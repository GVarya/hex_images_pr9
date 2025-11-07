import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';

import '../container/images_container.dart';
import '../model/hex_image.dart';
import '../services/images_service.dart';
import '../widgets/app_bottom_navigation.dart';
import '../widgets/image_item.dart';

class ImagesListScreen extends StatefulWidget {
  const ImagesListScreen({Key? key}) : super(key: key);

  @override
  State<ImagesListScreen> createState() => _ImagesListScreenState();
}

class _ImagesListScreenState extends State<ImagesListScreen> {
  @override
  Widget build(BuildContext context) {

    final container = ImagesContainer.of(context);
    final images = container.imagesService.images;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои изображения'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: images.isEmpty
          ? _buildEmptyState(context)
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: images.length,
        itemBuilder: (context, index) {
          final image = images[index];
          return ImageItem(
            image: image,
            onTap: () {
              context.push('/home/editor/${image.id}');
            },
            onDelete: () {
              _showDeleteDialog(context, image);
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

  void _showDeleteDialog(BuildContext context, HexImage image) {
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
              // Способ 2: через GetIt
              final service = GetIt.I<ImagesService>();
              service.deleteImage(image.id);
              setState(() {}); // Принудительное обновление состояния
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