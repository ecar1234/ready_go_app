
import 'package:json_annotation/json_annotation.dart';
part 'plan_model.g.dart';

@JsonSerializable()
class PlanModel {
  int? id;
  String? nation;
  String? subject;
  List<DateTime?>? schedule;
  bool? favorites;

  PlanModel({this.id, this.nation, this.subject, this.schedule, this.favorites});

  factory PlanModel.fromJson(Map<String, dynamic> json) => _$PlanModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlanModelToJson(this);
}