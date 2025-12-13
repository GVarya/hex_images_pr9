// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import '../providers/providers.dart';
// import '../model/hex_image.dart';
//
// class ImageEditorScreen extends ConsumerStatefulWidget {
//   final String? imageId;
//
//   const ImageEditorScreen({Key? key, this.imageId}) : super(key: key);
//
//   @override
//   ConsumerState<ImageEditorScreen> createState() => _ImageEditorScreenState();
// }
//
// class _ImageEditorScreenState extends ConsumerState<ImageEditorScreen> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _titleController;
//   late TextEditingController _descriptionController;
//   late TextEditingController _widthController;
//   late TextEditingController _heightController;
//
//   HexImage? _image;
//   bool _isEditing = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _titleController = TextEditingController();
//     _descriptionController = TextEditingController();
//     _widthController = TextEditingController(text: '10');
//     _heightController = TextEditingController(text: '10');
//
//     if (widget.imageId != null) {
//       _isEditing = true;
//       _loadImageData();
//     }
//   }
//
//   void _loadImageData() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final imageOps = ref.read(imageOperationsProvider);
//       final image = imageOps.getImageById(widget.imageId!);
//
//       if (image != null) {
//         setState(() {
//           _image = image;
//           _titleController.text = image.title;
//           _descriptionController.text = image.description ?? '';
//           _widthController.text = image.width.toString();
//           _heightController.text = image.height.toString();
//         });
//       } else {
//         context.pop();
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _titleController.dispose();
//     _descriptionController.dispose();
//     _widthController.dispose();
//     _heightController.dispose();
//     super.dispose();
//   }
//
//   void _saveForm() {
//     if (_formKey.currentState!.validate()) {
//       final imageOps = ref.read(imageOperationsProvider);
//       final width = int.tryParse(_widthController.text) ?? 10;
//       final height = int.tryParse(_heightController.text) ?? 10;
//
//       if (_isEditing && _image != null) {
//         imageOps.updateImage(
//           _image!.copyWith(
//             title: _titleController.text.trim(),
//             description: _descriptionController.text.trim().isEmpty
//                 ? null
//                 : _descriptionController.text.trim(),
//             width: width,
//             height: height,
//           ),
//         );
//       } else {
//         imageOps.createImage(
//           title: _titleController.text.trim(),
//           description: _descriptionController.text.trim().isEmpty
//               ? null
//               : _descriptionController.text.trim(),
//           width: width,
//           height: height,
//         );
//       }
//
//       context.pop();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_isEditing ? 'Редактировать изображение' : 'Создать изображение'),
//         backgroundColor: Colors.blue.shade700,
//         foregroundColor: Colors.white,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             context.pop();
//           },
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.save),
//             onPressed: _saveForm,
//             tooltip: 'Сохранить',
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               TextFormField(
//                 controller: _titleController,
//                 decoration: const InputDecoration(
//                   labelText: 'Название изображения *',
//                   hintText: 'Введите название',
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.trim().isEmpty) {
//                     return 'Пожалуйста, введите название';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _descriptionController,
//                 maxLines: 3,
//                 decoration: const InputDecoration(
//                   labelText: 'Описание',
//                   hintText: 'Необязательное описание изображения',
//                   border: OutlineInputBorder(),
//                   alignLabelWithHint: true,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextFormField(
//                       controller: _widthController,
//                       keyboardType: TextInputType.number,
//                       decoration: const InputDecoration(
//                         labelText: 'Ширина',
//                         border: OutlineInputBorder(),
//                       ),
//                       validator: (value) {
//                         final val = int.tryParse(value ?? '');
//                         if (val == null || val <= 0) {
//                           return 'Введите корректную ширину';
//                         }
//                         return null;
//                       },
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: TextFormField(
//                       controller: _heightController,
//                       keyboardType: TextInputType.number,
//                       decoration: const InputDecoration(
//                         labelText: 'Высота',
//                         border: OutlineInputBorder(),
//                       ),
//                       validator: (value) {
//                         final val = int.tryParse(value ?? '');
//                         if (val == null || val <= 0) {
//                           return 'Введите корректную высоту';
//                         }
//                         return null;
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 32),
//               ElevatedButton(
//                 onPressed: _saveForm,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue.shade700,
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                 ),
//                 child: Text(
//                   _isEditing ? 'Сохранить изменения' : 'Создать изображение',
//                   style: const TextStyle(fontSize: 16),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Container(
//                 height: 200,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.grey.shade300),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const SizedBox(height: 8),
//                       Text(
//                         'Тут будет картинка и рисовалка',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           color: Colors.grey.shade600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// lib/screens/image_editor_screen.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../providers/providers.dart';
import '../model/hex_image.dart';

class ImageEditorScreen extends ConsumerStatefulWidget {
  final String? imageId;
  final String? projectName;
  final int? gridWidth;
  final int? gridHeight;

  const ImageEditorScreen({
    Key? key,
    this.imageId,
    this.projectName,
    this.gridWidth = 16,
    this.gridHeight = 16,
  }) : super(key: key);

  @override
  ConsumerState createState() => _ImageEditorScreenState();
}

class _ImageEditorScreenState extends ConsumerState<ImageEditorScreen> {
  late int gridWidth;
  late int gridHeight;
  late List<List<Color>> grid;
  late String currentProjectName;
  late String? currentImageId;
  bool isEditing = false;

  Color selectedColor = Colors.blue;
  String currentTool = 'brush';
  bool isLoading = false;

  final _nameController = TextEditingController();
  final _widthController = TextEditingController();
  final _heightController = TextEditingController();

  final List<Color> colorPalette = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    Colors.pink,
    Colors.black,
    Colors.white,
    Colors.grey,
    Colors.brown,
  ];

  @override
  void initState() {
    super.initState();
    gridWidth = widget.gridWidth ?? 16;
    gridHeight = widget.gridHeight ?? 16;
    currentProjectName = widget.projectName ?? 'Новый проект';
    currentImageId = widget.imageId;
    isEditing = widget.imageId != null;

    _nameController.text = currentProjectName;
    _widthController.text = gridWidth.toString();
    _heightController.text = gridHeight.toString();

    if (widget.imageId != null) {
      _loadImageData();
    } else {
      _initializeGrid();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _loadImageData() {
    setState(() {
      isLoading = true;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final imageOps = ref.read(imageOperationsProvider);
      final image = imageOps.getImageById(widget.imageId!);

      if (image != null && mounted) {
        setState(() {
          currentProjectName = image.title;
          gridWidth = image.width;
          gridHeight = image.height;
          currentImageId = image.id;
          isEditing = true;
          _nameController.text = currentProjectName;
          _widthController.text = gridWidth.toString();
          _heightController.text = gridHeight.toString();

          // Загружаем grid из JSON данных
          _deserializeGrid(image.data);
          isLoading = false;
        });
      } else if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  void _initializeGrid() {
    grid = List.generate(
      gridHeight,
          (y) => List.generate(gridWidth, (x) => Colors.white),
    );
  }

  void _deserializeGrid(List<List<Color>> jsonData) {
    // try {
    //   final decodedData = jsonDecode(jsonData);
    //   final colors = decodedData['colors'] as List;
    //
    //   grid = [];
    //   for (var rowIndex = 0; rowIndex < gridHeight; rowIndex++) {
    //     final row = <Color>[];
    //     for (var colIndex = 0; colIndex < gridWidth; colIndex++) {
    //       final colorValue = colors[rowIndex * gridWidth + colIndex] as int;
    //       row.add(Color(colorValue));
    //     }
    //     grid.add(row);
    //   }
    // } catch (e) {
    //   print('Ошибка при десериализации grid: $e');
    //   _initializeGrid();
    // }
    grid = jsonData;
    _initializeGrid();
  }

  String _serializeGrid() {
    final colors = <int>[];
    for (var row in grid) {
      for (var color in row) {
        colors.add(color.value);
      }
    }
    return jsonEncode({'colors': colors});
  }

  void _paintCell(int x, int y) {
    if (x >= 0 && x < gridWidth && y >= 0 && y < gridHeight) {
      setState(() {
        if (currentTool == 'eraser') {
          grid[y][x] = Colors.white;
        } else {
          grid[y][x] = selectedColor;
        }
      });
    }
  }

  void _fillArea(int startX, int startY) {
    if (startX < 0 || startX >= gridWidth || startY < 0 || startY >= gridHeight) {
      return;
    }

    final targetColor = grid[startY][startX];
    final fillColor = currentTool == 'eraser' ? Colors.white : selectedColor;

    if (targetColor == fillColor) return;

    final queue = <(int, int)>[];
    queue.add((startX, startY));

    while (queue.isNotEmpty) {
      final (x, y) = queue.removeAt(0);

      if (x < 0 || x >= gridWidth || y < 0 || y >= gridHeight) continue;
      if (grid[y][x] != targetColor) continue;

      grid[y][x] = fillColor;

      queue.add((x + 1, y));
      queue.add((x - 1, y));
      queue.add((x, y + 1));
      queue.add((x, y - 1));
    }

    setState(() {});
  }

  void _clearGrid() {
    setState(() {
      grid = List.generate(
        gridHeight,
            (y) => List.generate(gridWidth, (x) => Colors.white),
      );
    });
  }

  void _saveImage() {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Введите название изображения')),
      );
      return;
    }

    try {
      final imageOps = ref.read(imageOperationsProvider);
      final gridData = _serializeGrid();

      if (isEditing && currentImageId != null) {
        // Обновляем существующее изображение
        imageOps.updateImage(
          HexImage(
            id: currentImageId!,
            title: name,
            width: gridWidth,
            height: gridHeight,
            data: grid,
            createdAt: DateTime.now(),
            userId: 'default_user', updatedAt: DateTime.now(),
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Изображение "$name" обновлено')),
        );
      } else {
        // Создаем новое изображение
        imageOps.createImage(
          title: name,
          width: gridWidth,
          height: gridHeight,
          data: grid,
        );

        // Обновляем список изображений через провайдер
        ref.refresh(imagesListProvider);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Изображение "$name" создано')),
        );
      }

      // Возвращаемся на предыдущий экран
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при сохранении: $e')),
      );
      print('Ошибка при сохранении изображения: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Редактировать: $currentProjectName' : 'Новый проект'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveImage,
            tooltip: 'Сохранить',
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Панель с информацией о проекте
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Название проекта',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText: 'Введите название',
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ширина',
                            style: TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          TextField(
                            controller: _widthController,
                            readOnly: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Высота',
                            style: TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          TextField(
                            controller: _heightController,
                            readOnly: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
          // Палитра цветов
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...colorPalette.map((color) => Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedColor = color;
                          currentTool = 'brush';
                        });
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color,
                          border: Border.all(
                            color: selectedColor == color ? Colors.black : Colors.grey,
                            width: selectedColor == color ? 3 : 1,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  )),
                  const SizedBox(width: 12),
                  // Инструменты
                  GestureDetector(
                    onTap: () => setState(() => currentTool = 'eraser'),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        border: Border.all(
                          color: currentTool == 'eraser' ? Colors.black : Colors.grey,
                          width: currentTool == 'eraser' ? 3 : 1,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.cleaning_services, size: 20),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => setState(() => currentTool = 'fill'),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        border: Border.all(
                          color: currentTool == 'fill' ? Colors.black : Colors.grey,
                          width: currentTool == 'fill' ? 3 : 1,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.format_color_fill, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          // Сетка для рисования
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridWidth,
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 1,
                ),
                itemCount: gridWidth * gridHeight,
                itemBuilder: (context, index) {
                  final x = index % gridWidth;
                  final y = index ~/ gridWidth;
                  final cellColor = grid[y][x];

                  return GestureDetector(
                    onTap: () {
                      if (currentTool == 'fill') {
                        _fillArea(x, y);
                      } else {
                        _paintCell(x, y);
                      }
                    },
                    onLongPress: () {
                      if (currentTool != 'fill') {
                        _paintCell(x, y);
                      }
                    },
                    child: Container(
                      color: cellColor,

                    ),
                  );
                },
              ),
            ),
          ),
          // Кнопки действия
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _clearGrid,
                    child: const Text('Очистить'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _saveImage,
                    icon: const Icon(Icons.save),
                    label: const Text('Сохранить'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:uuid/uuid.dart';
// import '../providers/providers.dart';
// import '../model/hex_image.dart';
//
// class ImageEditorScreen extends ConsumerStatefulWidget {
//   final String? imageId;
//   final String? projectName;
//   final int? gridWidth;
//   final int? gridHeight;
//
//   const ImageEditorScreen({
//     Key? key,
//     this.imageId,
//     this.projectName,
//     this.gridWidth = 16,
//     this.gridHeight = 16,
//   }) : super(key: key);
//
//   @override
//   ConsumerState<ImageEditorScreen> createState() => _ImageEditorScreenState();
// }
//
// class _ImageEditorScreenState extends ConsumerState<ImageEditorScreen> {
//   late int gridWidth;
//   late int gridHeight;
//   late List<List<Color>> grid;
//   late String currentProjectName;
//   Color selectedColor = Colors.blue;
//   String currentTool = 'brush';
//   bool isLoading = false;
//
//   final _nameController = TextEditingController();
//   final _widthController = TextEditingController();
//   final _heightController = TextEditingController();
//
//   final List<Color> colorPalette = [
//     Colors.red,
//     Colors.orange,
//     Colors.yellow,
//     Colors.green,
//     Colors.blue,
//     Colors.indigo,
//     Colors.purple,
//     Colors.pink,
//     Colors.black,
//     Colors.white,
//     Colors.grey,
//     Colors.brown,
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     gridWidth = widget.gridWidth ?? 16;
//     gridHeight = widget.gridHeight ?? 16;
//     currentProjectName = widget.projectName ?? 'Новый проект';
//     if (widget.imageId != null) {
//       _loadImageData();
//     } else {
//       _initializeGrid();
//     }
//   }
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _widthController.dispose();
//     _heightController.dispose();
//     super.dispose();
//   }
//
//   void _loadImageData() {
//     setState(() {
//       isLoading = true;
//     });
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final imageOps = ref.read(imageOperationsProvider);
//       final image = imageOps.getImageById(widget.imageId!);
//
//       if (image != null && mounted) {
//         setState(() {
//           currentProjectName = image.title;
//           gridWidth = image.width;
//           gridHeight = image.height;
//           _initializeGrid();
//           // TODO: Загрузить данные изображения в grid из image.data
//           isLoading = false;
//         });
//       } else if (mounted) {
//         // Если изображение не найдено - возвращаемся
//         Navigator.pop(context);
//       }
//     });
//   }
//
//   void _initializeGrid() {
//     grid = List.generate(
//       gridHeight,
//           (y) => List.generate(gridWidth, (x) => Colors.white),
//     );
//   }
//
//   void _paintCell(int x, int y) {
//     if (x >= 0 && x < gridWidth && y >= 0 && y < gridHeight) {
//       setState(() {
//         if (currentTool == 'eraser') {
//           grid[y][x] = Colors.white;
//         } else {
//           grid[y][x] = selectedColor;
//         }
//       });
//     }
//   }
//
//   void _fillArea(int startX, int startY) {
//     if (startX < 0 ||
//         startX >= gridWidth ||
//         startY < 0 ||
//         startY >= gridHeight) {
//       return;
//     }
//
//     final targetColor = grid[startY][startX];
//     final fillColor = currentTool == 'eraser' ? Colors.white : selectedColor;
//
//     if (targetColor == fillColor) return;
//
//     final queue = <(int, int)>[];
//     queue.add((startX, startY));
//
//     while (queue.isNotEmpty) {
//       final (x, y) = queue.removeAt(0);
//
//       if (x < 0 || x >= gridWidth || y < 0 || y >= gridHeight) continue;
//       if (grid[y][x] != targetColor) continue;
//
//       grid[y][x] = fillColor;
//
//       queue.add((x + 1, y));
//       queue.add((x - 1, y));
//       queue.add((x, y + 1));
//       queue.add((x, y - 1));
//     }
//
//     setState(() {});
//   }
//
//   void _clearGrid() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Очистить холст?'),
//         content: const Text('Это действие не может быть отменено'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Отмена'),
//           ),
//           TextButton(
//             onPressed: () {
//               _initializeGrid();
//               setState(() {});
//               Navigator.pop(context);
//             },
//             child: const Text('Очистить'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _updateGridSize() {
//     final newWidth = int.tryParse(_widthController.text);
//     final newHeight = int.tryParse(_heightController.text);
//
//     if (newWidth == null || newWidth <= 0 || newWidth > 64) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Ширина должна быть от 1 до 64')),
//       );
//       return;
//     }
//
//     if (newHeight == null || newHeight <= 0 || newHeight > 64) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Высота должна быть от 1 до 64')),
//       );
//       return;
//     }
//
//     setState(() {
//       gridWidth = newWidth;
//       gridHeight = newHeight;
//       _initializeGrid();
//     });
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('азмер сетки обновлён')),
//     );
//   }
//
//   void _saveProject() {
//     final name = _nameController.text.trim();
//     if (name.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Введите имя проекта')),
//       );
//       return;
//     }
//
//     // 1 Сериализуем сетку в JSON
//     // final gridData = jsonEncode(
//     //   List.generate(
//     //     gridHeight,
//     //         (y) => List.generate(
//     //       gridWidth,
//     //           (x) => grid[y][x].value, // Сохраняем цвет как число
//     //     ),
//     //   ),
//     // );
//
//     final imageOps = ref.read(imageOperationsProvider);
//
//     if (widget.imageId != null) {
//       imageOps.updateImage(
//         HexImage(
//           id: widget.imageId!,
//           title: name,
//           width: gridWidth,
//           height: gridHeight,
//           data: grid,
//           userId: 'all',
//           updatedAt: DateTime.now(),
//           createdAt: DateTime.now(),
//         ),
//       );
//     } else {
//       imageOps.createImage(
//         title: name,
//         width: gridWidth,
//         height: gridHeight,
//         data: grid,
//       );
//     }
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           widget.imageId != null
//               ? 'Изображение "$name" обновлено'
//               : 'Проект "$name" сохранён',
//         ),
//         backgroundColor: Colors.green,
//       ),
//     );
//
//     Future.delayed(const Duration(seconds: 1), () {
//       if (mounted) {
//         Navigator.of(context).pop();
//       }
//     });
//   }
//
//   Map<String, dynamic> _serializeGrid() {
//     final data = <String, dynamic>{};
//     for (int y = 0; y < gridHeight; y++) {
//       for (int x = 0; x < gridWidth; x++) {
//         final color = grid[y][x];
//         if (color != Colors.white) {
//           data['${x}_$y'] = color.value;
//         }
//       }
//     }
//     return data;
//   }
//
//   void _deserializeGrid(Map<String, dynamic> data) {
//     for (int y = 0; y < gridHeight; y++) {
//       for (int x = 0; x < gridWidth; x++) {
//         final key = '${x}_$y';
//         if (data.containsKey(key)) {
//           grid[y][x] = Color(data[key] as int);
//         }
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return Scaffold(
//         appBar: AppBar(
//           title: const Text('Загрузка...'),
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back),
//             onPressed: () { Navigator.pop(context); },
//           ),
//           elevation: 0,
//         ),
//         body: const Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(currentProjectName),
//         elevation: 0,
//         backgroundColor: Colors.blue.shade700,
//         foregroundColor: Colors.white,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.save),
//             onPressed: _saveProject,
//             tooltip: 'Сохранить',
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             color: Colors.grey[100],
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         controller: _nameController,
//                         decoration: InputDecoration(
//                           labelText: 'Имя проекта',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(6),
//                           ),
//                           isDense: true,
//                           contentPadding: const EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 12,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     SizedBox(
//                       width: 70,
//                       child: TextField(
//                         controller: _widthController,
//                         keyboardType: TextInputType.number,
//                         decoration: InputDecoration(
//                           labelText: 'Шир.',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(6),
//                           ),
//                           isDense: true,
//                           contentPadding: const EdgeInsets.symmetric(
//                             horizontal: 8,
//                             vertical: 12,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     SizedBox(
//                       width: 70,
//                       child: TextField(
//                         controller: _heightController,
//                         keyboardType: TextInputType.number,
//                         decoration: InputDecoration(
//                           labelText: 'Выс.',
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(6),
//                           ),
//                           isDense: true,
//                           contentPadding: const EdgeInsets.symmetric(
//                             horizontal: 8,
//                             vertical: 12,
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     ElevatedButton(
//                       onPressed: _updateGridSize,
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(horizontal: 8),
//                       ),
//                       child: const Text('OK'),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//
//                 Row(
//                   children: [
//                     _buildToolButton('brush', Icons.brush, 'Кисть'),
//                     const SizedBox(width: 8),
//                     _buildToolButton(
//                       'fill',
//                       Icons.format_color_fill,
//                       'Заливка',
//                     ),
//                     const SizedBox(width: 8),
//                     _buildToolButton('eraser', Icons.cleaning_services, 'Ластик'),
//                     const Spacer(),
//                     ElevatedButton.icon(
//                       onPressed: _clearGrid,
//                       icon: const Icon(Icons.delete_sweep),
//                       label: const Text('Очистить'),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                         foregroundColor: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 Row(
//                   children: [
//                     const Text(
//                       'Цвет:',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(width: 8),
//                     GestureDetector(
//                       onTap: () {
//                         setState(() {
//                         });
//                       },
//                       child: Container(
//                         width: 40,
//                         height: 40,
//                         decoration: BoxDecoration(
//                           color: currentTool == 'eraser'
//                               ? Colors.white
//                               : selectedColor,
//                           border: Border.all(
//                             color: Colors.grey,
//                             width: 2,
//                           ),
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                         child: currentTool == 'eraser'
//                             ? const Icon(Icons.close, color: Colors.grey)
//                             : null,
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     if (currentTool != 'eraser')
//                       Expanded(
//                         child: SingleChildScrollView(
//                           scrollDirection: Axis.horizontal,
//                           child: Row(
//                             children: colorPalette.map((color) {
//                               return GestureDetector(
//                                 onTap: () {
//                                   setState(() {
//                                     selectedColor = color;
//                                   });
//                                 },
//                                 child: Container(
//                                   width: 32,
//                                   height: 32,
//                                   margin: const EdgeInsets.only(right: 8),
//                                   decoration: BoxDecoration(
//                                     color: color,
//                                     border: Border.all(
//                                       color: selectedColor == color
//                                           ? Colors.black
//                                           : Colors.grey,
//                                       width:
//                                       selectedColor == color ? 2 : 1,
//                                     ),
//                                     borderRadius: BorderRadius.circular(4),
//                                   ),
//                                 ),
//                               );
//                             }).toList(),
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Container(
//               color: Colors.grey[50],
//               padding: const EdgeInsets.all(16),
//               child: Center(
//                 child: SingleChildScrollView(
//                   child: GridView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: gridWidth,
//                       crossAxisSpacing: 2,
//                       mainAxisSpacing: 2,
//                     ),
//                     itemCount: gridWidth * gridHeight,
//                     itemBuilder: (context, index) {
//                       final x = index % gridWidth;
//                       final y = index ~/ gridWidth;
//
//                       return GestureDetector(
//                         onTap: () {
//                           if (currentTool == 'fill') {
//                             _fillArea(x, y);
//                           } else {
//                             _paintCell(x, y);
//                           }
//                         },
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: grid[y][x],
//                             border: Border.all(
//                               color: Colors.grey[300]!,
//                               width: 0.5,
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.all(12),
//             color: Colors.grey[100],
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   'Размер сетки: ${gridWidth}×${gridHeight}',
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildToolButton(String toolName, IconData icon, String tooltip) {
//     final isActive = currentTool == toolName;
//     return Tooltip(
//       message: tooltip,
//       child: ElevatedButton.icon(
//         onPressed: () {
//           setState(() {
//             currentTool = toolName;
//           });
//         },
//         icon: Icon(icon),
//         label: Text(tooltip),
//         style: ElevatedButton.styleFrom(
//           backgroundColor:
//           isActive ? Colors.blue.shade700 : Colors.grey[300],
//           foregroundColor: isActive ? Colors.white : Colors.black,
//         ),
//       ),
//     );
//   }
// }
