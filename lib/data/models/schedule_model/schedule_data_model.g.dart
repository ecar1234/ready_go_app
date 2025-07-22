// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduleDataModel _$ScheduleDataModelFromJson(Map<String, dynamic> json) =>
    ScheduleDataModel(
      roundData: (json['roundData'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
            int.parse(k),
            (e as List<dynamic>)
                .map((e) =>
                    ScheduleListModel.fromJson(e as Map<String, dynamic>))
                .toList()),
      ),
    );

Map<String, dynamic> _$ScheduleDataModelToJson(ScheduleDataModel instance) =>
    <String, dynamic>{
      'roundData': instance.roundData?.map((k, e) => MapEntry(k.toString(), e)),
    };
