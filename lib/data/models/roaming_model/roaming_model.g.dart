// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roaming_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoamingModel _$RoamingModelFromJson(Map<String, dynamic> json) => RoamingModel(
      imgList:
          (json['imgList'] as List<dynamic>?)?.map((e) => e as String).toList(),
      dpAddress: json['dpAddress'] as String?,
      activeCode: json['activeCode'] as String?,
      period: json['period'] == null
          ? null
          : RoamingPeriodModel.fromJson(json['period'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RoamingModelToJson(RoamingModel instance) =>
    <String, dynamic>{
      'imgList': instance.imgList,
      'dpAddress': instance.dpAddress,
      'activeCode': instance.activeCode,
      'period': instance.period,
    };
