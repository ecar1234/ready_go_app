
import 'package:ready_go_project/data/models/plan_model/plan_model.dart';

class PlanListModel {
  List<PlanModel>? planList;

  PlanListModel({this.planList});

  factory PlanListModel.formJson(Map<String, dynamic> json) {
    return PlanListModel(
      planList: (json['planList'] as List).map((e) => PlanModel.fromJson(e)).toList()
    );
  }

  Map<String, dynamic> toJson(PlanListModel instance) {
    return {'planList' : planList?.map((e) => e.toJson()).toList()};
  }
}