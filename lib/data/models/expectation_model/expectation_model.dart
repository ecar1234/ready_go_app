import 'package:json_annotation/json_annotation.dart';
import 'package:ready_go_project/domain/entities/provider/expectation_provider.dart';

part 'expectation_model.g.dart';

@JsonSerializable()
class  ExpectationModel{
  String? title;
  ExpectationType? type;
  int? amount;

  ExpectationModel({this.title, this.type, this.amount});

  factory ExpectationModel.fromJson(Map<String, dynamic> json) => _$ExpectationModelFromJson(json);
  Map<String, dynamic> toJson() => _$ExpectationModelToJson(this);
}