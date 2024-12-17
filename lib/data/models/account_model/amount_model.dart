import 'package:json_annotation/json_annotation.dart';

part 'amount_model.g.dart';

enum AmountType {add, use}

@JsonSerializable()
class AmountModel {

  String? id;
  AmountType? type;
  DateTime? usageTime;
  int? category; // 0: exchange, 1: cash, 2: card
  int? amount;
  String? title;
  AmountModel({this.id, this.type, this.usageTime, this.category, this.amount, this.title});

  factory AmountModel.fromJson(Map<String, dynamic> json) => _$AmountModelFromJson(json);

  Map<String, dynamic> toJson() => _$AmountModelToJson(this);
}
