// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roaming_period_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoamingPeriodModel _$RoamingPeriodModelFromJson(Map<String, dynamic> json) =>
    RoamingPeriodModel(
      period: (json['period'] as num?)?.toInt(),
      isActive: json['isActive'] as bool?,
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
    );

Map<String, dynamic> _$RoamingPeriodModelToJson(RoamingPeriodModel instance) =>
    <String, dynamic>{
      'period': instance.period,
      'isActive': instance.isActive,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
    };
