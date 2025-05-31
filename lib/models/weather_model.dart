// Импортируем библиотеку Hive для работы с локальной БД
import 'package:hive/hive.dart';

// Указываем, что этот файл является частью файла 'weather_model.g.dart' (генерируемого автоматически)
part 'weather_model.g.dart';

// Аннотация @HiveType говорит Hive, что данный класс можно сохранять в хранилище.
// typeId = 0 — уникальный идентификатор типа данных в Hive. Не менять после первого использования!
@HiveType(typeId: 0)
class WeatherData {
  // Поле city — название города
  @HiveField(0) // Индекс поля в Hive-записи
  final String city;

  // Поле temperature — температура в градусах
  @HiveField(1) // Порядковый номер поля при сериализации
  final double temperature;

  // Поле humidity — влажность воздуха
  @HiveField(2)
  final double humidity;

  // Поле description — текстовое описание погоды (например, "Облачно", "Солнечно")
  @HiveField(3)
  final String description;

  // Поле windSpeed — скорость ветра
  @HiveField(4)
  final double windSpeed;

  // Поле timestamp — время получения данных о погоде
  @HiveField(5)
  final DateTime timestamp;

  // Конструктор класса, требующий все поля
  WeatherData({
    required this.city,
    required this.temperature,
    required this.humidity,
    required this.description,
    required this.windSpeed,
    required this.timestamp,
  });
}