import 'package:hive/hive.dart';

part 'calculation_model.g.dart';

@HiveType(typeId: 1)
class CalculationData {
  @HiveField(0)
  final double humidity;
  
  @HiveField(1)
  final double temperature;
  
  @HiveField(2)
  final String comfortLevel;
  
  @HiveField(3)
  final DateTime timestamp;

  CalculationData({
    required this.humidity,
    required this.temperature,
    required this.comfortLevel,
    required this.timestamp,
  });
}