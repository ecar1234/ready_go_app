// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accommodation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccommodationModel _$AccommodationModelFromJson(Map<String, dynamic> json) =>
    AccommodationModel(
      name: json['name'] as String?,
      address: json['address'] as String?,
      startDay: json['startDay'] == null
          ? null
          : DateTime.parse(json['startDay'] as String),
      period: (json['period'] as num?)?.toInt(),
      checkInTime: json['checkInTime'] as String?,
      checkOutTime: json['checkOutTime'] as String?,
      payment: json['payment'] as String?,
      bookApp: json['bookApp'] as String?,
      bookNum: json['bookNum'] as String?,
    );

Map<String, dynamic> _$AccommodationModelToJson(AccommodationModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'address': instance.address,
      'startDay': instance.startDay?.toIso8601String(),
      'period': instance.period,
      'checkInTime': instance.checkInTime,
      'checkOutTime': instance.checkOutTime,
      'payment': instance.payment,
      'bookApp': instance.bookApp,
      'bookNum': instance.bookNum,
    };
