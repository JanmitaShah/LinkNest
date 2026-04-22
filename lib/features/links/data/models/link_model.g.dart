// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'link_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LinkModelAdapter extends TypeAdapter<LinkModel> {
  @override
  final int typeId = 0;

  @override
  LinkModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LinkModel(
      id: fields[0] as String,
      url: fields[1] as String,
      title: fields[2] as String,
      categoryId: fields[3] as String,
      tags: (fields[4] as List).cast<String>(),
      notes: fields[5] as String,
      createdAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, LinkModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.url)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.categoryId)
      ..writeByte(4)
      ..write(obj.tags)
      ..writeByte(5)
      ..write(obj.notes)
      ..writeByte(6)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LinkModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}