// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'amount_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AmountModel _$AmountModelFromJson(Map<String, dynamic> json) => AmountModel(
      id: json['id'] as String?,
      type: $enumDecodeNullable(_$AmountTypeEnumMap, json['type']),
      methodType: $enumDecodeNullable(_$MethodTypeEnumMap, json['methodType']),
      usageTime: json['usageTime'] == null
          ? null
          : DateTime.parse(json['usageTime'] as String),
      category: (json['category'] as num?)?.toInt(),
      amount: (json['amount'] as num?)?.toInt(),
      title: json['title'] as String?,
    );

Map<String, dynamic> _$AmountModelToJson(AmountModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$AmountTypeEnumMap[instance.type],
      'methodType': _$MethodTypeEnumMap[instance.methodType],
      'usageTime': instance.usageTime?.toIso8601String(),
      'category': instance.category,
      'amount': instance.amount,
      'title': instance.title,
    };

const _$AmountTypeEnumMap = {
  AmountType.add: 'add',
  AmountType.use: 'use',
};

const _$MethodTypeEnumMap = {
  MethodType.traffic: 'traffic',
  MethodType.food: 'food',
  MethodType.drink: 'drink',
  MethodType.accommodation: 'accommodation',
  MethodType.tour: 'tour',
  MethodType.leisure: 'leisure',
  MethodType.ect: 'ect',
};
