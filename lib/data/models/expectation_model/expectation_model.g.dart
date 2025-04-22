// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expectation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExpectationModel _$ExpectationModelFromJson(Map<String, dynamic> json) =>
    ExpectationModel(
      title: json['title'] as String?,
      type: $enumDecodeNullable(_$MethodTypeEnumMap, json['type']),
      amount: (json['amount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ExpectationModelToJson(ExpectationModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'type': _$MethodTypeEnumMap[instance.type],
      'amount': instance.amount,
    };

const _$MethodTypeEnumMap = {
  MethodType.ariPlane: 'ariPlane',
  MethodType.traffic: 'traffic',
  MethodType.food: 'food',
  MethodType.drink: 'drink',
  MethodType.shopping: 'shopping',
  MethodType.accommodation: 'accommodation',
  MethodType.tour: 'tour',
  MethodType.leisure: 'leisure',
  MethodType.ect: 'ect',
};
