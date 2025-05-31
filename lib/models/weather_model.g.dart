// Указывает, что этот файл является частью 'weather_model.dart'.
// Используется для разделения модели и её адаптера при работе с Hive.
part of 'weather_model.dart';

// Класс WeatherDataAdapter — это TypeAdapter для сериализации и десериализации объектов WeatherData.
// Он необходим, если вы не используете автоматическую генерацию кода через Hive аннотации.
class WeatherDataAdapter extends TypeAdapter<WeatherData> {

  // Уникальный идентификатор типа данных. 
  // Должен совпадать с typeId из @HiveType у класса WeatherData (в данном случае 0).
  @override
  final int typeId = 0;

  // Метод read() отвечает за чтение данных из бинарного формата и создание на его основе объекта WeatherData.
  @override
  WeatherData read(BinaryReader reader) {
    // Считываем количество полей, записанных в бинарном виде
    final numOfFields = reader.readByte();

    // Создаем словарь, где ключ — номер поля (int), значение — данные этого поля (dynamic)
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    // Возвращаем новый экземпляр WeatherData, заполняя его данными из словаря
    return WeatherData(
      city: fields[0] as String,
      temperature: fields[1] as double,
      humidity: fields[2] as double,
      description: fields[3] as String,
      windSpeed: fields[4] as double,
      timestamp: fields[5] as DateTime,
    );
  }

  // Метод write() отвечает за запись объекта WeatherData в бинарном формате.
  @override
  void write(BinaryWriter writer, WeatherData obj) {
    // Записываем количество полей (6) как byte
    writer
      ..writeByte(6)
      // Поле 0 — город
      ..writeByte(0)
      ..write(obj.city)
      // Поле 1 — температура
      ..writeByte(1)
      ..write(obj.temperature)
      // Поле 2 — влажность
      ..writeByte(2)
      ..write(obj.humidity)
      // Поле 3 — описание погоды
      ..writeByte(3)
      ..write(obj.description)
      // Поле 4 — скорость ветра
      ..writeByte(4)
      ..write(obj.windSpeed)
      // Поле 5 — временная метка
      ..writeByte(5)
      ..write(obj.timestamp);
  }

  // Переопределяем hashCode, чтобы объекты адаптера могли корректно работать в коллекциях
  @override
  int get hashCode => typeId.hashCode;

  // Переопределяем оператор == для сравнения двух адаптеров по типу и typeId
  @override
  bool operator ==(Object other) =>
      identical(this, other) || // Проверяем ссылочное равенство
      other is WeatherDataAdapter && // Проверяем тип
          runtimeType == other.runtimeType && // Совпадают ли типы
          typeId == other.typeId; // Совпадают ли ID типов
}