// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlanModel _$PlanModelFromJson(Map<String, dynamic> json) => PlanModel(
      id: _idFromJson(json['id']),
      nation: json['nation'] as String?,
      subject: json['subject'] as String?,
      schedule: (json['schedule'] as List<dynamic>?)
          ?.map((e) => e == null ? null : DateTime.parse(e as String))
          .toList(),
      favorites: json['favorites'] as bool?,
      unit: json['unit'] as String?,
    );

Map<String, dynamic> _$PlanModelToJson(PlanModel instance) => <String, dynamic>{
      'id': instance.id,
      'nation': instance.nation,
      'subject': instance.subject,
      'schedule': instance.schedule?.map((e) => e?.toIso8601String()).toList(),
      'favorites': instance.favorites,
      'unit': instance.unit,
    };
