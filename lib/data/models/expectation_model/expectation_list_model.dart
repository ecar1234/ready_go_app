import 'package:json_annotation/json_annotation.dart';
import 'package:ready_go_project/data/models/expectation_model/expectation_model.dart';

part 'expectation_list_model.g.dart';

@JsonSerializable()
class ExpectationListModel{
  List<ExpectationModel>? expectationList;
  int? numOfPeople;
  ExpectationListModel({this.expectationList, this.numOfPeople});

  factory ExpectationListModel.fromJson(Map<String, dynamic> json) => _$ExpectationListModelFromJson(json);
  Map<String, dynamic> toJson() => _$ExpectationListModelToJson(this);
}