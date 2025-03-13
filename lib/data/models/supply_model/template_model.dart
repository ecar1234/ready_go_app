
import 'package:json_annotation/json_annotation.dart';
import 'package:ready_go_project/data/models/supply_model/supply_model.dart';

part 'template_model.g.dart';

@JsonSerializable()
class TemplateModel {
  String? tempTitle;
  List<SupplyModel>? temp;

  TemplateModel({this.tempTitle, this.temp});

  factory TemplateModel.fromJson(Map<String, dynamic> json) => _$TemplateModelFromJson(json);
  Map<String, dynamic> toJson() => _$TemplateModelToJson(this);
}
