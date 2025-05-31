// Импортируем необходимые пакеты: Flutter, camera для работы с камерой устройства,
// image_picker для выбора изображений из галереи, dart:io для работы с файлами.
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

// Экран CameraScreen — основной экран приложения, предоставляющий доступ к камере и галерее.
class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller; // Контроллер камеры
  late Future<void> _initializeControllerFuture; // Результат инициализации камеры
  bool _isCameraReady = false; // Флаг, указывающий, готова ли камера к использованию

  @override
  void initState() {
    super.initState();
    _initializeCamera(); // Инициализируем камеру при создании состояния
  }

  // Метод инициализирует камеру устройства
  Future<void> _initializeCamera() async {
    final cameras = await availableCameras(); // Получаем список доступных камер
    _controller = CameraController(
      cameras.first, // Используем первую камеру (обычно заднюю)
      ResolutionPreset.medium, // Среднее качество изображения
    );

    // Инициализируем контроллер камеры
    _initializeControllerFuture = _controller.initialize().then((_) {
      if (!mounted) return;
      setState(() => _isCameraReady = true); // Обновляем состояние, если всё прошло успешно
    });
  }

  // Метод делает фото с камеры
  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture; // Ожидаем успешной инициализации
      final image = await _controller.takePicture(); // Делаем снимок

      if (!mounted) return;

      // Переходим на экран просмотра изображения
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(imagePath: image.path),
        ),
      );
    } catch (e) {
      // В случае ошибки показываем SnackBar с описанием
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: ${e.toString()}')),
      );
    }
  }

  // Метод позволяет выбрать изображение из галереи
  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery); // Открываем галерею

    if (pickedFile != null && mounted) {
      // Если изображение выбрано — открываем экран просмотра
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(imagePath: pickedFile.path),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose(); // Освобождаем ресурсы камеры при уничтожении состояния
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Камера'),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture, // Ждём инициализации камеры
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                // Предпросмотр с камеры
                Expanded(
                  child: CameraPreview(_controller),
                ),
                // Панель кнопок управления
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Кнопка открытия галереи
                      IconButton(
                        icon: const Icon(Icons.photo_library),
                        onPressed: _pickImageFromGallery,
                        tooltip: 'Выбрать с галереи',
                      ),
                      // Кнопка сделать фото
                      IconButton(
                        icon: const Icon(Icons.camera_alt),
                        onPressed: _takePicture,
                        tooltip: 'Получить изображение',
                        color: Colors.blue,
                        iconSize: 48,
                      ),
                      const SizedBox(width: 48), // Для выравнивания
                    ],
                  ),
                ),
              ],
            );
          } else {
            // Показываем индикатор загрузки, пока камера инициализируется
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

// Экран DisplayPictureScreen — экран просмотра выбранного или сделанного изображения
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath; // Путь к изображению

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Изображение')), // Заголовок экрана
      body: Center(
        // Отображаем изображение как виджет Image.file
        child: Image.file(File(imagePath)),
      ),
    );
  }
}