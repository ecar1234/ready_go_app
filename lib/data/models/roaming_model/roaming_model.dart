import 'package:json_annotation/json_annotation.dart';
import 'package:ready_go_project/data/models/roaming_model/roaming_period_model.dart';

part "roaming_model.g.dart";

@JsonSerializable()
class RoamingModel {
  List<String>? imgList;
  String? dpAddress;
  String? activeCode;
  RoamingPeriodModel? period;

  RoamingModel({this.imgList, this.dpAddress, this.activeCode, this.period});

  factory RoamingModel.fromJson(Map<String, dynamic> json) => _$RoamingModelFromJson(json);
  Map<String, dynamic> toJson() => _$RoamingModelToJson(this);
}