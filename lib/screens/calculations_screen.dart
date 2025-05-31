// Импортируем необходимые пакеты: Flutter, Hive для локального хранения данных,
// url_launcher для открытия ссылок, intl для форматирования дат и кастомную модель CalculationModel.
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weather_humidity_app/models/calculation_model.dart';

// Экран CalculationsScreen — экран калькулятора влажности и температуры.
class CalculationsScreen extends StatefulWidget {
  const CalculationsScreen({super.key});

  @override
  State<CalculationsScreen> createState() => _CalculationsScreenState();
}

class _CalculationsScreenState extends State<CalculationsScreen> {
  // Контроллеры для текстовых полей ввода влажности и температуры
  final TextEditingController humidityController = TextEditingController();
  final TextEditingController tempController = TextEditingController();

  // Метод рассчитывает уровень комфорта на основе влажности и температуры (Heat Index)
  String _calculateComfortLevel(double humidity, double temperature) {
    final heatIndex = _calculateHeatIndex(temperature, humidity); // Получаем "ощущаемую" температуру

    // Возвращаем уровень комфортности в зависимости от значения Heat Index
    if (heatIndex < 27) {
      return 'Комфортная погода - идеальные условия';
    } else if (heatIndex < 32) {
      return 'Не очень приятно - небольшой дискомфорт';
    } else if (heatIndex < 41) {
      return 'Значительно неприятно - на улице душно';
    } else if (heatIndex < 54) {
      return 'Опасность - вероятен тепловой удар';
    } else {
      return 'Тепловая аномалия - лучше не выходить на улицу';
    }
  }

  // Упрощённая формула расчёта ощущаемой температуры (Heat Index)
  double _calculateHeatIndex(double temp, double humidity) {
    return temp + 0.05 * humidity;
  }

  // Метод открывает статью о влиянии влажности на здоровье с помощью url_launcher
  Future<void> _openHumidityArticle() async {
    const url = 'https://www.healthline.com/health/humidity-levels'; 
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не загружен URL')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Калькулятор влажности'),
        actions: [
          IconButton(
            icon: const Icon(Icons.article),
            onPressed: _openHumidityArticle,
            tooltip: 'Читайте о влиянии влажности',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Поле ввода температуры
            TextField(
              controller: tempController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Температура (°C)',
                border: OutlineInputBorder(),
                suffixText: '°C',
              ),
            ),
            const SizedBox(height: 10),

            // Поле ввода влажности
            TextField(
              controller: humidityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Влажность (%)',
                border: OutlineInputBorder(),
                suffixText: '%',
              ),
            ),
            const SizedBox(height: 20),

            // Кнопка запуска расчёта уровня комфорта
            ElevatedButton(
              onPressed: () {
                if (humidityController.text.isNotEmpty && tempController.text.isNotEmpty) {
                  final humidity = double.tryParse(humidityController.text) ?? 0;
                  final temp = double.tryParse(tempController.text) ?? 0;
                  final comfortLevel = _calculateComfortLevel(humidity, temp);

                  // Создаем объект CalculationData
                  final calculation = CalculationData(
                    humidity: humidity,
                    temperature: temp,
                    comfortLevel: comfortLevel,
                    timestamp: DateTime.now(),
                  );

                  // Сохраняем его в Hive-боксе (локальное хранилище)
                  Hive.box<CalculationData>('calculation_history').add(calculation);
                  setState(() {}); // Обновляем UI

                  // Показываем диалоговое окно с результатом
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Уровень комфортности'),
                      content: Text(comfortLevel),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: const Text('Вычислить уровень комфорта'),
            ),
            const SizedBox(height: 20),

            // Заголовок истории вычислений
            const Text(
              'История',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Отображение истории через ValueListenableBuilder,
            // который автоматически обновляет список при изменении данных в Hive
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: Hive.box<CalculationData>('calculation_history').listenable(),
                builder: (context, Box<CalculationData> box, _) {
                  final history = box.values.toList()
                    ..sort((a, b) => b.timestamp.compareTo(a.timestamp)); // Сортировка по времени (свежие сверху)

                  if (history.isEmpty) {
                    return const Center(child: Text('История пуста'));
                  }

                  // Строим список из прошлых вычислений
                  return ListView.builder(
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final calculation = history[index];
                      return Card(
                        child: ListTile(
                          title: Text('${calculation.temperature}°C, ${calculation.humidity}%'),
                          subtitle: Text(calculation.comfortLevel),
                          trailing: Text(DateFormat('MMM d, H:mm').format(calculation.timestamp)), // Форматируем дату
                          onTap: () {
                            // При нажатии на элемент истории — подставляем значения в поля ввода
                            tempController.text = calculation.temperature.toString();
                            humidityController.text = calculation.humidity.toString();
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}