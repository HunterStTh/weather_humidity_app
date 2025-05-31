// Импорт пакета Hive для работы с локальным хранилищем
import 'package:hive/hive.dart';

// Указание, что этот файл является частью сгенерированного файла адаптера
// Файл calculation_model.g.dart будет создан утилитой build_runner
part 'calculation_model.g.dart';

// Аннотация @HiveType указывает, что этот класс может храниться в Hive
// typeId должен быть уникальным числом (1 в данном случае) для каждого класса
@HiveType(typeId: 1)
class CalculationData {
  // Аннотация @HiveField для каждого поля, которое нужно хранить
  // Каждое поле получает уникальный номер (начинается с 0)
  @HiveField(0)
  final double humidity;  // Уровень влажности
  
  @HiveField(1)
  final double temperature;  // Температура
  
  @HiveField(2)
  final String comfortLevel;  // Уровень комфорта (текстовое описание)
  
  @HiveField(3)
  final DateTime timestamp;  // Временная метка создания записи

  // Конструктор класса с обязательными параметрами
  CalculationData({
    required this.humidity,
    required this.temperature,
    required this.comfortLevel,
    required this.timestamp,
  });
}