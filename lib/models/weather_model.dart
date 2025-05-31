import 'package:hive/hive.dart';

part 'weather_model.g.dart';

@HiveType(typeId: 0)
class WeatherData {
  @HiveField(0)
  final String city;
  
  @HiveField(1)
  final double temperature;
  
  @HiveField(2)
  final double humidity;
  
  @HiveField(3)
  final String description;
  
  @HiveField(4)
  final double windSpeed;
  
  @HiveField(5)
  final DateTime timestamp;

  WeatherData({
    required this.city,
    required this.temperature,
    required this.humidity,
    required this.description,
    required this.windSpeed,
    required this.timestamp,
  });
}