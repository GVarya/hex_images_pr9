import 'package:flutter/material.dart';
class EffectsScreen extends StatefulWidget {
  const EffectsScreen({Key? key}) : super(key: key);

  @override
  State<EffectsScreen> createState() => _EffectsScreenState();
}

class _EffectsScreenState extends State<EffectsScreen> {
  String selectedEffect = '';
  bool isApplying = false;
  double effectIntensity = 0.25;
  double effectSpeed = 0.25;

  final List<EffectItem> effects = [
    EffectItem(
      id: 'clock',
      name: 'Часы',
      icon: Icons.schedule,
      description: 'Отображение времени на экране',
      color: Colors.blue,
    ),
    EffectItem(
      id: 'rainbow',
      name: 'Переливание цветом',
      icon: Icons.gradient,
      description: 'Плавное изменение цветовой палитры',
      color: Colors.red,
    ),
    EffectItem(
      id: 'pulse',
      name: 'Пульс',
      icon: Icons.favorite,
      description: 'Ритмичное изменение яркости',
      color: Colors.pink,
    ),
    EffectItem(
      id: 'wave',
      name: 'Волны',
      icon: Icons.water,
      description: 'Волнообразное движение цветов',
      color: Colors.cyan,
    ),
    EffectItem(
      id: 'fire',
      name: 'Огонь',
      icon: Icons.local_fire_department,
      description: 'Эффект горящего огня',
      color: Colors.orange,
    ),
    EffectItem(
      id: 'snow',
      name: 'Снег',
      icon: Icons.cloud_download,
      description: 'Падающие снежинки',
      color: Colors.blue[200]!,
    ),
    EffectItem(
      id: 'matrix',
      name: 'Матрица',
      icon: Icons.border_all,
      description: 'Эффект матричного кода',
      color: Colors.green,
    ),
    EffectItem(
      id: 'plasma',
      name: 'Плазма',
      icon: Icons.flash_on,
      description: 'Анимированная плазма',
      color: Colors.purple,
    ),
  ];

  void _selectEffect(String effectId) {
    setState(() {
      selectedEffect = effectId;
      effectIntensity = 0.5;
      effectSpeed = 0.5;
    });
  }

  void _applyEffect() {
    if (selectedEffect.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Выберите эффект')),
      );
      return;
    }

    setState(() {
      isApplying = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          isApplying = false;
        });
        _showApplyDialog();
      }
    });
  }

  void _showApplyDialog() {
    final effect = effects.firstWhere((e) => e.id == selectedEffect);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Эффект применён'),
        content: Text(
          'Эффект "${effect.name}" успешно применён к изображению',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _resetSettings() {
    setState(() {
      selectedEffect = '';
      effectIntensity = 0.5;
      effectSpeed = 0.5;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedEffectItem = selectedEffect.isNotEmpty
        ? effects.firstWhere((e) => e.id == selectedEffect)
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Эффекты'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Доступные эффекты',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 8,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: effects.length,
                    itemBuilder: (context, index) {
                      final effect = effects[index];
                      final isSelected = selectedEffect == effect.id;

                      return GestureDetector(
                        onTap: () => _selectEffect(effect.id),
                        child: Card(
                          elevation: isSelected ? 4 : 1,
                          color: isSelected
                              ? effect.color.withOpacity(0.1)
                              : null,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isSelected
                                  ? effect.color
                                  : Colors.grey[300]!,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: effect.color.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  effect.icon,
                                  color: effect.color,
                                  size: 32,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                effect.name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0),
                                child: Text(
                                  effect.description,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            if (selectedEffectItem != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(),
                    const SizedBox(height: 12),
                    Text(
                      'Параметры: ${selectedEffectItem.name}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Интенсивность'),
                            Text(
                              '${(effectIntensity * 100).toInt()}%',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Slider(
                          value: effectIntensity,
                          onChanged: (value) {
                            setState(() {
                              effectIntensity = value;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Скорость'),
                            Text(
                              '${(effectSpeed * 100).toInt()}%',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Slider(
                          value: effectSpeed,
                          onChanged: (value) {
                            setState(() {
                              effectSpeed = value;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: selectedEffectItem.color),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  selectedEffectItem.color.withOpacity(0.3),
                                  selectedEffectItem.color.withOpacity(0.1),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                selectedEffectItem.icon,
                                size: 48,
                                color: selectedEffectItem.color,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Предпросмотр эффекта',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _resetSettings,
                            icon: const Icon(Icons.restore),
                            label: const Text('Сбросить'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: isApplying ? null : _applyEffect,
                            icon: isApplying
                                ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                                : const Icon(Icons.check),
                            label: const Text('Применить'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            if (selectedEffectItem == null)
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.touch_app,
                        size: 64,
                        color: Colors.grey[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Выберите эффект',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class EffectItem {
  final String id;
  final String name;
  final IconData icon;
  final String description;
  final Color color;

  EffectItem({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    required this.color,
  });
}
