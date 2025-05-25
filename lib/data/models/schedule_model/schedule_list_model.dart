import 'package:json_annotation/json_annotation.dart';
import 'package:ready_go_project/data/models/schedule_model/schedule_model.dart';

part 'schedule_list_model.g.dart';

@JsonSerializable()
class ScheduleListModel{
  int? id;
  List<ScheduleModel>? scheduleList;
  ScheduleListModel({this.id, this.scheduleList});

  factory ScheduleListModel.fromJson(Map<String, dynamic> json) => _$ScheduleListModelFromJson(json);
  Map<String, dynamic> toJson() => _$ScheduleListModelToJson(this);
}