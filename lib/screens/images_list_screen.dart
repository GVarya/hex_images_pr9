import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/image_operations.dart';
import '../providers/providers.dart';
import '../model/hex_image.dart';
import '../widgets/image_item.dart';
import 'image_editor_screen.dart';
import 'image_preview_screen.dart';

class ImagesListScreen extends ConsumerWidget {
  const ImagesListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final allImages = ref.watch(imagesListProvider);
    final userImages = allImages;
    final imageOps = ref.read(imageOperationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои проекты'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageEditorScreen(
                    imageId: image.id,
                    projectName: image.title,
                    gridWidth: image.width,
                    gridHeight: image.height,
                  ),
                ),
              );
            },
            onPreview: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImagePreviewScreen(
                    projectName: image.title,
                    gridWidth: image.width,
                    gridHeight: image.height,
                  ),
                ),
              );
            },
            onDelete: () {
              _showDeleteDialog(context, image, imageOps);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ImageEditorScreen(
                imageId: null,
                projectName: 'Новый проект',
                gridWidth: 16,
                gridHeight: 16,
              ),
            ),
          );
        },
        tooltip: 'Создать изображение',
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteDialog(
      BuildContext context,
      HexImage image,
      ImageOperations imageOps,
      ) {
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${image.title} удалено')),
              );
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
      child: SingleChildScrollView(  // Добавили SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,  // Изменили на min
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
                'Создайте первое изображение или импортируйте из файла',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ImageEditorScreen(
                        imageId: null,
                        projectName: 'Новый проект',
                        gridWidth: 16,
                        gridHeight: 16,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Создать изображение'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}