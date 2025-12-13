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

