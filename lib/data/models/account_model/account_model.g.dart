// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountModel _$AccountModelFromJson(Map<String, dynamic> json) => AccountModel(
      totalExchangeAccount: (json['totalExchangeAccount'] as num?)?.toInt(),
      exchange: (json['exchange'] as num?)?.toInt(),
      cash: (json['cash'] as num?)?.toInt(),
      card: (json['card'] as num?)?.toInt(),
      totalUseAccount: (json['totalUseAccount'] as num?)?.toInt(),
      usageHistory: (json['usageHistory'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
            int.parse(k),
            (e as List<dynamic>)
                .map((e) => AmountModel.fromJson(e as Map<String, dynamic>))
                .toList()),
      ),
    );

Map<String, dynamic> _$AccountModelToJson(AccountModel instance) =>
    <String, dynamic>{
      'totalExchangeAccount': instance.totalExchangeAccount,
      'exchange': instance.exchange,
      'cash': instance.cash,
      'card': instance.card,
      'totalUseAccount': instance.totalUseAccount,
      'usageHistory':
          instance.usageHistory?.map((k, e) => MapEntry(k.toString(), e)),
    };
