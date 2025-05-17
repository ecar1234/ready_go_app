
import 'package:json_annotation/json_annotation.dart';
part 'schedule_model.g.dart';

@JsonSerializable()
class ScheduleModel {
  int? id;
  String? title;
  ScheduleModel({this.id, this.title});

  factory ScheduleModel.fromJson(Map<String, dynamic> json) => _$ScheduleModelFromJson(json);
  Map<String, dynamic> toJson() => _$ScheduleModelToJson(this);
}