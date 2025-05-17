// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduleListModel _$ScheduleListModelFromJson(Map<String, dynamic> json) =>
    ScheduleListModel(
      startTime: json['stringTime'] as String?,
      scheduleList: (json['scheduleList'] as List<dynamic>?)
          ?.map((e) => ScheduleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ScheduleListModelToJson(ScheduleListModel instance) =>
    <String, dynamic>{
      'stringTime': instance.startTime,
      'scheduleList': instance.scheduleList,
    };
