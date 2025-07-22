
import 'package:json_annotation/json_annotation.dart';
import 'package:ready_go_project/data/models/plan_model/plan_model.dart';
part 'plan_list_model.g.dart';

@JsonSerializable()
class PlanListModel {
  List<PlanModel>? planList;

  PlanListModel({this.planList});

  factory PlanListModel.formJson(Map<String, dynamic> json) => _$PlanListModelFromJson(json);

  Map<String, dynamic> toJson(PlanListModel instance) => _$PlanListModelToJson(this);
}