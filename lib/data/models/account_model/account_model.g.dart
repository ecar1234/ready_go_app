// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountModel _$AccountModelFromJson(Map<String, dynamic> json) => AccountModel(
      totalExchangeCost: (json['totalExchangeCost'] as num?)?.toInt(),
      useExchangeMoney: (json['useExchangeMoney'] as num?)?.toInt(),
      useKoCash: (json['useKoCash'] as num?)?.toInt(),
      useCard: (json['useCard'] as num?)?.toInt(),
      balance: (json['balance'] as num?)?.toInt(),
      usageHistory: (json['usageHistory'] as List<dynamic>?)
          ?.map((e) => (e as List<dynamic>?)
              ?.map((e) => AmountModel.fromJson(e as Map<String, dynamic>))
              .toList())
          .toList(),
    );

Map<String, dynamic> _$AccountModelToJson(AccountModel instance) =>
    <String, dynamic>{
      'totalExchangeCost': instance.totalExchangeCost,
      'useExchangeMoney': instance.useExchangeMoney,
      'useKoCash': instance.useKoCash,
      'useCard': instance.useCard,
      'balance': instance.balance,
      'usageHistory': instance.usageHistory,
    };
