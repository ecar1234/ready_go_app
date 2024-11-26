
import 'package:json_annotation/json_annotation.dart';
import 'package:ready_go_project/data/models/account_model/amount_model.dart';

part 'account_model.g.dart';

@JsonSerializable()
class AccountModel {
  int? totalExchangeAccount;
  int? exchange;
  int? cash;
  int? card;
  int? totalUseAccount;
  Map<int, List<AmountModel>>? usageHistory;

  AccountModel({this.totalExchangeAccount, this.exchange, this. cash, this.card, this.totalUseAccount, this.usageHistory});

  factory AccountModel.fromJson(Map<String, dynamic> json) => _$AccountModelFromJson(json);
  Map<String, dynamic> toJson() => _$AccountModelToJson(this);
}