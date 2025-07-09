// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'productsHiveAdapter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductsHiveAdapter extends TypeAdapter<ProductsHive> {
  @override
  final int typeId = 0;

  @override
  ProductsHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductsHive(
      id: fields[0] as int?,
      title: fields[1] as String?,
      price: fields[2] as double?,
      description: fields[3] as String?,
      category: fields[4] as String?,
      image: fields[5] as String?,
      rate: fields[6] as double?,
      count: fields[7] as int?,
      isCached: fields[8] as bool,
      lastUpdated: fields[9] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ProductsHive obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.image)
      ..writeByte(6)
      ..write(obj.rate)
      ..writeByte(7)
      ..write(obj.count)
      ..writeByte(8)
      ..write(obj.isCached)
      ..writeByte(9)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductsHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
