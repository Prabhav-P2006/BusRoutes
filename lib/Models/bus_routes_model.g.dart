// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bus_routes_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BusRouteAdapter extends TypeAdapter<BusRoute> {
  @override
  final int typeId = 0;

  @override
  BusRoute read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BusRoute(
      busNumber: fields[0] as String,
      fromLocation: fields[1] as String,
      toLocation: fields[2] as String,
      route: fields[3] as String,
      isFavourite: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, BusRoute obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.busNumber)
      ..writeByte(1)
      ..write(obj.fromLocation)
      ..writeByte(2)
      ..write(obj.toLocation)
      ..writeByte(3)
      ..write(obj.route)
      ..writeByte(4)
      ..write(obj.isFavourite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusRouteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
