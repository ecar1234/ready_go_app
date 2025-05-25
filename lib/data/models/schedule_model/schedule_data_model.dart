import 'package:json_annotation/json_annotation.dart';
import 'package:ready_go_project/data/models/schedule_model/schedule_list_model.dart';

part 'schedule_data_model.g.dart';
@JsonSerializable()
class ScheduleDataModel{
  Map<int, List<ScheduleListModel>>? roundData;
  ScheduleDataModel({this.roundData});

  factory ScheduleDataModel.fromJson(Map<String, dynamic> json) => _$ScheduleDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$ScheduleDataModelToJson(this);
}