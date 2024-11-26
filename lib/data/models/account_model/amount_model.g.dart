// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'amount_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AmountModel _$AmountModelFromJson(Map<String, dynamic> json) => AmountModel(
      id: json['id'] as String?,
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
      'usageTime': instance.usageTime?.toIso8601String(),
      'category': instance.category,
      'amount': instance.amount,
      'title': instance.title,
    };
