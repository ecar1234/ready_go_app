// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduleModel _$ScheduleModelFromJson(Map<String, dynamic> json) =>
    ScheduleModel(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
    );

Map<String, dynamic> _$ScheduleModelToJson(ScheduleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
    };
