
part of 'calculation_model.dart';


class CalculationDataAdapter extends TypeAdapter<CalculationData> {
  @override
  final int typeId = 1;

  @override
  CalculationData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CalculationData(
      humidity: fields[0] as double,
      temperature: fields[1] as double,
      comfortLevel: fields[2] as String,
      timestamp: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, CalculationData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.humidity)
      ..writeByte(1)
      ..write(obj.temperature)
      ..writeByte(2)
      ..write(obj.comfortLevel)
      ..writeByte(3)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalculationDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
