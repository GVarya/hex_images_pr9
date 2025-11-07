import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import '../services/images_service.dart';
import '../model/hex_image.dart';

class ImageEditorScreen extends StatefulWidget {
  final String? imageId;

  const ImageEditorScreen({Key? key, this.imageId}) : super(key: key);

  @override
  State<ImageEditorScreen> createState() => _ImageEditorScreenState();
}

class _ImageEditorScreenState extends State<ImageEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _widthController;
  late TextEditingController _heightController;

  HexImage? _image;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _widthController = TextEditingController(text: '10');
    _heightController = TextEditingController(text: '10');

    if (widget.imageId != null) {
      _isEditing = true;
      _loadImageData();
    }
  }

  void _loadImageData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final service = GetIt.I<ImagesService>();
      final image = service.getImageById(widget.imageId!);

      if (image != null) {
        setState(() {
          _image = image;
          _titleController.text = image.title;
          _descriptionController.text = image.description ?? '';
          _widthController.text = image.width.toString();
          _heightController.text = image.height.toString();
        });
      } else {
        context.pop();
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final service = GetIt.I<ImagesService>();
      final width = int.tryParse(_widthController.text) ?? 10;
      final height = int.tryParse(_heightController.text) ?? 10;

      if (_isEditing && _image != null) {
        service.updateImage(
          _image!.copyWith(
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
            width: width,
            height: height,
          ),
        );
      } else {
        service.createImage(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          width: width,
          height: height,
        );
      }

      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Редактировать изображение' : 'Создать изображение'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
            tooltip: 'Сохранить',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Название изображения *',
                  hintText: 'Введите название',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Пожалуйста, введите название';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Описание',
                  hintText: 'Необязательное описание изображения',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _widthController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Ширина',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        final val = int.tryParse(value ?? '');
                        if (val == null || val <= 0) {
                          return 'Введите корректную ширину';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _heightController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Высота',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        final val = int.tryParse(value ?? '');
                        if (val == null || val <= 0) {
                          return 'Введите корректную высоту';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  _isEditing ? 'Сохранить изменения' : 'Создать изображение',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        'Тут будет картинка и рисовалка',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}