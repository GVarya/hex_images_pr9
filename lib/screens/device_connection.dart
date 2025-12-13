import 'package:flutter/material.dart';

class DeviceConnectionScreen extends StatefulWidget {
  const DeviceConnectionScreen({Key? key}) : super(key: key);

  @override
  State<DeviceConnectionScreen> createState() => _DeviceConnectionScreenState();
}

class _DeviceConnectionScreenState extends State<DeviceConnectionScreen> {
  bool isScanning = false;
  List<DeviceModel> foundDevices = [];
  List<DeviceModel> savedDevices = [
    DeviceModel(
      id: '1',
      name: 'Hexagon Display 1',
      macAddress: 'AA:BB:CC:DD:EE:01',
      width: 16,
      height: 16,
      isConnected: false,
    ),
    DeviceModel(
      id: '2',
      name: 'Hexagon Display 2',
      macAddress: 'AA:BB:CC:DD:EE:02',
      width: 32,
      height: 32,
      isConnected: false,
    ),
  ];

  void startScan() {
    setState(() {
      isScanning = true;
      foundDevices = [];
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          foundDevices = [
            DeviceModel(
              id: '3',
              name: 'Hexagon Display NEW',
              macAddress: 'AA:BB:CC:DD:EE:FF',
              width: 24,
              height: 24,
              isConnected: false,
            ),
            DeviceModel(
              id: '4',
              name: 'LED Panel Pro',
              macAddress: 'AA:BB:CC:DD:EE:AA',
              width: 20,
              height: 20,
              isConnected: false,
            ),
          ];
          isScanning = false;
        });
      }
    });
  }

  void connectDevice(DeviceModel device) {
    setState(() {
      device.isConnected = !device.isConnected;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          device.isConnected
              ? 'Подключено к ${device.name}'
              : 'Отключено от ${device.name}',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void saveDevice(DeviceModel device) {
    setState(() {
      if (!savedDevices.any((d) => d.macAddress == device.macAddress)) {
        savedDevices.add(device);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${device.name} сохранено')),
    );
  }

  void deleteDevice(DeviceModel device) {
    setState(() {
      savedDevices.removeWhere((d) => d.macAddress == device.macAddress);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${device.name} удалено')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Подключение к устройству'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () { Navigator.pop(context); },
        ),
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
                    'Доступные устройства',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: isScanning ? null : startScan,
                      icon: isScanning
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor,
                                ),
                              ),
                            )
                          : const Icon(Icons.search),
                      label: Text(
                        isScanning ? 'Сканирование...' : 'Сканировать устройства',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (foundDevices.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Найденные устройства',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    ...foundDevices.map((device) => _buildDeviceCard(
                          device: device,
                          onConnect: connectDevice,
                          onSave: saveDevice,
                        )),
                  ],
                ),
              ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Сохранённые устройства',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (savedDevices.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text('Нет сохранённых устройств'),
                      ),
                    )
                  else
                    ...savedDevices.map((device) => _buildDeviceCard(
                          device: device,
                          onConnect: connectDevice,
                          onDelete: deleteDevice,
                          isSaved: true,
                        )),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceCard({
    required DeviceModel device,
    required Function(DeviceModel) onConnect,
    Function(DeviceModel)? onSave,
    Function(DeviceModel)? onDelete,
    bool isSaved = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        device.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        device.macAddress,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Размер: ${device.width}×${device.height}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: device.isConnected
                        ? Colors.green[100]
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    device.isConnected ? 'Подключено' : 'Отключено',
                    style: TextStyle(
                      fontSize: 12,
                      color: device.isConnected
                          ? Colors.green[800]
                          : Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => onConnect(device),
                  icon: Icon(
                    device.isConnected
                        ? Icons.link_off
                        : Icons.link,
                  ),
                  label: Text(
                    device.isConnected ? 'Отключить' : 'Подключить',
                  ),
                ),
                if (onSave != null)
                  TextButton.icon(
                    onPressed: () => onSave(device),
                    icon: const Icon(Icons.bookmark_border),
                    label: const Text('Сохранить'),
                  )
                else if (onDelete != null)
                  TextButton.icon(
                    onPressed: () => onDelete(device),
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Удалить'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DeviceModel {
  final String id;
  final String name;
  final String macAddress;
  final int width;
  final int height;
  bool isConnected;

  DeviceModel({
    required this.id,
    required this.name,
    required this.macAddress,
    required this.width,
    required this.height,
    this.isConnected = false,
  });
}
