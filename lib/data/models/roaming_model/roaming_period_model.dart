import 'package:json_annotation/json_annotation.dart';

part 'roaming_period_model.g.dart';

@JsonSerializable()
class RoamingPeriodModel{
  int? period;
  bool? isActive;
  DateTime? startDate;
  DateTime? endDate;

  RoamingPeriodModel({this.period, this.isActive, this.startDate, this.endDate});

  factory RoamingPeriodModel.fromJson(Map<String, dynamic> json) => _$RoamingPeriodModelFromJson(json);
  Map<String, dynamic> toJson() => _$RoamingPeriodModelToJson(this);
}