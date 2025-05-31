import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart'; // Для форматирования даты
import 'package:weather_humidity_app/bloc/weather_bloc.dart';
import 'package:weather_humidity_app/models/weather_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Контроллер для текстового поля ввода города
    final TextEditingController cityController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Калькулятор температуры'),
        actions: [
          // Кнопка перехода на экран разработчика
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/developer');
            },
          ),
          // Кнопка перехода на экран расчетов
          IconButton(
            icon: const Icon(Icons.calculate),
            onPressed: () {
              Navigator.pushNamed(context, '/calculations');
            },
          ),
          // Кнопка перехода на экран камеры
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: () {
              Navigator.pushNamed(context, '/camera');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Строка с полем ввода и кнопкой поиска
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: cityController,
                    decoration: const InputDecoration(
                      labelText: 'Введите город',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    if (cityController.text.isNotEmpty) {
                      // Отправка события для загрузки погоды
                      context.read<WeatherBloc>().add(FetchWeather(cityController.text));
                      // Отправка события для загрузки истории
                      context.read<WeatherBloc>().add(LoadWeatherHistory());
                    }
                  },
                  child: const Text('Поиск'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Блок для отображения состояния погоды
            BlocBuilder<WeatherBloc, WeatherState>(
              builder: (context, state) {
                if (state is WeatherLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is WeatherError) {
                  return Center(child: Text(state.message));
                } else if (state is WeatherLoaded) {
                  return _buildWeatherCard(state.weatherData);
                } else if (state is WeatherHistoryLoaded) {
                  return const SizedBox.shrink();
                }
                return const Center(child: Text('Введите город'));
              },
            ),
            const SizedBox(height: 20),
            
            // Заголовок для истории поиска
            const Text(
              'История поиска',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            
            // Список истории поиска
            Expanded(
              child: ValueListenableBuilder(
                // Слушатель изменений в Hive-боксе
                valueListenable: Hive.box<WeatherData>('weather_history').listenable(),
                builder: (context, Box<WeatherData> box, _) {
                  // Получение и сортировка истории по дате (новые сверху)
                  final history = box.values.toList()
                    ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
                  
                  if (history.isEmpty) {
                    return const Center(child: Text('История пуста'));
                  }
                  
                  // Построение списка истории
                  return ListView.builder(
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final weather = history[index];
                      return Card(
                        child: ListTile(
                          title: Text(weather.city),
                          subtitle: Text('${weather.temperature}°C, ${weather.humidity}% влажность'),
                          // Форматирование даты
                          trailing: Text(DateFormat('MMM d, H:mm').format(weather.timestamp)),
                          onTap: () {
                            // Заполнение поля и повторный запрос при тапе
                            cityController.text = weather.city;
                            context.read<WeatherBloc>().add(FetchWeather(weather.city));
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

  // Виджет для отображения карточки с текущей погодой
  Widget _buildWeatherCard(WeatherData weather) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              weather.city,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              '${weather.temperature}°C',
              style: const TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 10),
            Text(
              'Влажность: ${weather.humidity}%',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Ветер: ${weather.windSpeed} m/s',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              weather.description,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}