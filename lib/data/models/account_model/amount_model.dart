import 'package:json_annotation/json_annotation.dart';

part 'amount_model.g.dart';

enum AmountType {add, use}
enum MethodType {traffic, food, drink, accommodation, tour, leisure, ect}

@JsonSerializable()
class AmountModel {

  String? id;
  AmountType? type;
  MethodType? methodType;
  DateTime? usageTime;
  int? category; // 0: exchange, 1: cash, 2: card
  int? amount;
  String? title;
  AmountModel({this.id, this.type, this.methodType, this.usageTime, this.category, this.amount, this.title});

  factory AmountModel.fromJson(Map<String, dynamic> json) => _$AmountModelFromJson(json);

  Map<String, dynamic> toJson() => _$AmountModelToJson(this);
}
