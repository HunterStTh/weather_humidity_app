// Указывает, что этот файл является частью файла 'calculation_model.dart'.
// Это позволяет использовать объявления из основного файла и делить логику на несколько частей.
part of 'calculation_model.dart';

// Класс CalculationDataAdapter отвечает за сериализацию и десериализацию объектов типа CalculationData.
// Он расширяет TypeAdapter<CalculationData> — стандартный механизм Hive для работы с кастомными типами.
class CalculationDataAdapter extends TypeAdapter<CalculationData> {
  // typeId — уникальный числовой идентификатор типа данных.
  // Используется Hive для определения, какой адаптер использовать при чтении/записи объекта.
  // ДОЛЖЕН оставаться неизменным после первого использования в production-среде!
  @override
  final int typeId = 1;
  // Метод read() отвечает за десериализацию: преобразует бинарные данные обратно в объект CalculationData.
  @override
  CalculationData read(BinaryReader reader) {
    // Считываем количество полей (numOfFields), записанное как byte в начале блока данных.
    final numOfFields = reader.readByte();

    // Читаем пары ключ-значение: 
    // ключ — это номер поля (int), значение — любое, в зависимости от типа.
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++)
        reader.readByte(): reader.read(), // читаем ключ и значение
    };

    // Создаём новый экземпляр CalculationData, используя прочитанные значения.
    return CalculationData(
      humidity: fields[0] as double,       // поле 0 — влажность
      temperature: fields[1] as double,    // поле 1 — температура
      comfortLevel: fields[2] as String,   // поле 2 — уровень комфорта
      timestamp: fields[3] as DateTime,    // поле 3 — время
    );
  }

  // Метод write() отвечает за сериализацию: сохраняет объект CalculationData в бинарном виде.
  @override
  void write(BinaryWriter writer, CalculationData obj) {
    writer
      ..writeByte(4) // Записываем количество полей (в данном случае их 4)
      ..writeByte(0) // Ключ поля 0
      ..write(obj.humidity) // Значение поля 0 — влажность
      ..writeByte(1) // Ключ поля 1
      ..write(obj.temperature) // Значение поля 1 — температура
      ..writeByte(2) // Ключ поля 2
      ..write(obj.comfortLevel) // Значение поля 2 — уровень комфорта
      ..writeByte(3) // Ключ поля 3
      ..write(obj.timestamp); // Значение поля 3 — временная метка
  }

  // Переопределяем hashCode для корректной работы в коллекциях и сравнений.
  @override
  int get hashCode => typeId.hashCode;

  // Переопределяем оператор == для проверки равенства двух адаптеров.
  // Адаптеры считаются равными, если они одного типа и имеют одинаковый typeId.
  @override
  bool operator ==(Object other) =>
      identical(this, other) || // Проверяем ссылочное равенство
      other is CalculationDataAdapter && // Проверяем тип
          runtimeType == other.runtimeType && // Совпадают ли типы во время выполнения
          typeId == other.typeId; // И совпадают ли ID типов
}
