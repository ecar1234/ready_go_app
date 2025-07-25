import 'package:json_annotation/json_annotation.dart';
import 'package:ready_go_project/data/models/account_model/amount_model.dart';

part 'account_model.g.dart';

@JsonSerializable()
class AccountModel {
  int? totalExchangeCost;
  int? useExchangeMoney;
  int? useKoCash;
  int? useCard;
  int? balance;
  List<List<AmountModel>?>? usageHistory;

  AccountModel({this.totalExchangeCost, this.useExchangeMoney, this.useKoCash, this.useCard, this.balance, this.usageHistory});

  factory AccountModel.fromJson(Map<String, dynamic> json) => _$AccountModelFromJson(json);
  Map<String, dynamic> toJson() => _$AccountModelToJson(this);
}