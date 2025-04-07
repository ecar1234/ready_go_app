// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expectation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExpectationModel _$ExpectationModelFromJson(Map<String, dynamic> json) =>
    ExpectationModel(
      title: json['title'] as String?,
      type: $enumDecodeNullable(_$ExpectationTypeEnumMap, json['type']),
      amount: (json['amount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ExpectationModelToJson(ExpectationModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'type': _$ExpectationTypeEnumMap[instance.type],
      'amount': instance.amount,
    };

const _$ExpectationTypeEnumMap = {
  ExpectationType.transportation: 'transportation',
  ExpectationType.accommodation: 'accommodation',
  ExpectationType.restaurant: 'restaurant',
  ExpectationType.dessert: 'dessert',
  ExpectationType.tour: 'tour',
  ExpectationType.ect: 'ect',
};
