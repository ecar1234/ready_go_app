import 'package:json_annotation/json_annotation.dart';
import 'package:ready_go_project/data/models/account_model/amount_model.dart';

part 'expectation_model.g.dart';


@JsonSerializable()
class  ExpectationModel{
  String? title;
  MethodType? type;
  int? amount;
  String? unit;

  ExpectationModel({this.title, this.type, this.amount, this.unit});

  factory ExpectationModel.fromJson(Map<String, dynamic> json) => _$ExpectationModelFromJson(json);
  Map<String, dynamic> toJson() => _$ExpectationModelToJson(this);
}