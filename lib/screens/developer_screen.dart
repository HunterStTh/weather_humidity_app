import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/developer.jpg'), // Add your image
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'О разработчике:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildInfoRow(Icons.person, 'ФИО:', 'Гаврилов Д.А.'),
            _buildInfoRow(Icons.school, 'Группа:', 'ИВТ-22'),
            _buildInfoRow(Icons.email, 'Email:', 'tompsjk@gmail.com'),
            _buildInfoRow(Icons.phone, 'Тел:', '+7 (924) 373 99 50'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _launchURL('https://github.com/HunterStTh'),
              child: const Text('View Github'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 24),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }
}