
import 'package:json_annotation/json_annotation.dart';
part 'schedule_model.g.dart';

@JsonSerializable()
class ScheduleModel {
  int? id;
  String? time;
  String? title;
  List<String>? details;
  ScheduleModel({this.id, this.time, this.title, this.details});

  factory ScheduleModel.fromJson(Map<String, dynamic> json) => _$ScheduleModelFromJson(json);
  Map<String, dynamic> toJson() => _$ScheduleModelToJson(this);
}