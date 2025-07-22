
import 'package:json_annotation/json_annotation.dart';
part 'supply_model.g.dart';

@JsonSerializable()
class SupplyModel {
  String? item;
  bool? isCheck;

  SupplyModel({this.item, this.isCheck});

  factory SupplyModel.fromJson(Map<String, dynamic> json) => _$SupplyModelFromJson(json);
  Map<String, dynamic> toJson() => _$SupplyModelToJson(this);
}