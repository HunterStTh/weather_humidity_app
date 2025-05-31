// Импортируем необходимые пакеты: Flutter для построения UI, Bloc для управления состоянием,
// Hive для локального хранения данных, а также модели и экраны приложения.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weather_humidity_app/bloc/weather_bloc.dart';
import 'package:weather_humidity_app/models/weather_model.dart';
import 'package:weather_humidity_app/models/calculation_model.dart';
import 'package:weather_humidity_app/screens/developer_screen.dart';
import 'package:weather_humidity_app/screens/home_screen.dart';
import 'package:weather_humidity_app/screens/calculations_screen.dart';
import 'package:weather_humidity_app/screens/camera_screen.dart';

// Точка входа в приложение
void main() async {
  // Убеждаемся, что все Flutter-биндинги инициализированы
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализируем Hive для работы с локальным хранилищем
  await Hive.initFlutter();

  // Регистрируем адаптеры для кастомных классов, чтобы Hive мог их сериализовать
  Hive.registerAdapter(WeatherDataAdapter());
  Hive.registerAdapter(CalculationDataAdapter());

  // Открываем две коробки (boxes) в Hive:
  // - для хранения истории погоды ('weather_history')
  // - для хранения истории вычислений влажности ('calculation_history')
  await Hive.openBox<WeatherData>('weather_history');
  await Hive.openBox<CalculationData>('calculation_history');

  // Запускаем приложение
  runApp(const MyApp());
}

// Основной виджет приложения — MyApp
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      // Подключаем BLoC-архитектуру, регистрируя WeatherBloc как провайдер
      providers: [
        BlocProvider(
          create: (context) => WeatherBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Weather & Humidity App', // Название приложения
        theme: ThemeData(
          primarySwatch: Colors.blue, // Основная цветовая палитра
          visualDensity: VisualDensity.adaptivePlatformDensity, // Адаптация плотности под платформу
        ),
        home: const HomeScreen(), // Главный экран приложения
        routes: {
          // Маршруты для перехода между экранами
          '/developer': (context) => const DeveloperScreen(), // Информация о разработчике
          '/calculations': (context) => const CalculationsScreen(), // Калькулятор влажности
          '/camera': (context) => const CameraScreen(), // Камера
        },
      ),
    );
  }
}