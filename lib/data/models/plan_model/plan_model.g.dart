// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlanModel _$PlanModelFromJson(Map<String, dynamic> json) => PlanModel(
      id: (json['id'] as num?)?.toInt(),
      nation: json['nation'] as String?,
      schedule: (json['schedule'] as List<dynamic>?)
          ?.map((e) => e == null ? null : DateTime.parse(e as String))
          .toList(),
    )..favorites = json['favorites'] as bool?;

Map<String, dynamic> _$PlanModelToJson(PlanModel instance) => <String, dynamic>{
      'id': instance.id,
      'nation': instance.nation,
      'schedule': instance.schedule?.map((e) => e?.toIso8601String()).toList(),
      'favorites': instance.favorites,
    };
