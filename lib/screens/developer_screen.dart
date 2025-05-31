// Импортируем необходимые пакеты: Flutter для построения интерфейса и url_launcher для открытия ссылок.
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Экран DeveloperScreen — экран с информацией о разработчике приложения.
class DeveloperScreen extends StatelessWidget {
  const DeveloperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Информация о разработчике'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Круглое изображение разработчика (заменить на своё в assets/developer.jpg)
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/developer.jpg'), // Путь к фото разработчика
              ),
            ),
            const SizedBox(height: 20), // Отступ

            // Заголовок раздела "О разработчике"
            const Text(
              'О разработчике:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20), // Отступ

            // Информационные строки с иконками
            _buildInfoRow(Icons.person, 'ФИО:', 'Гаврилов Д.А.'),
            _buildInfoRow(Icons.school, 'Группа:', 'ИВТ-22'),
            _buildInfoRow(Icons.email, 'Email:', 'tompsjk@gmail.com'),
            _buildInfoRow(Icons.phone, 'Тел:', '+7 (924) 373 99 50'),

            const SizedBox(height: 20), // Отступ

            // Кнопка перехода на GitHub
            ElevatedButton(
              onPressed: () => _launchURL('https://github.com/HunterStTh'), 
              child: const Text('View Github'),
            ),
          ],
        ),
      ),
    );
  }

  // Вспомогательный метод для построения строк информации с иконкой, меткой и значением
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 24), // Иконка слева
          const SizedBox(width: 10), // Отступ между иконкой и текстом
          Text(
            label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 10), // Отступ между меткой и значением
          Text(
            value,
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  // Метод открывает URL в браузере устройства
  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }
}