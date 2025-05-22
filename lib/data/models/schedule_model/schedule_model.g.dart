// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduleModel _$ScheduleModelFromJson(Map<String, dynamic> json) =>
    ScheduleModel(
      id: (json['id'] as num?)?.toInt(),
      time: json['time'] as String?,
      title: json['title'] as String?,
      details:
          (json['details'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ScheduleModelToJson(ScheduleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'time': instance.time,
      'title': instance.title,
      'details': instance.details,
    };
