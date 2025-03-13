// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TemplateModel _$TemplateModelFromJson(Map<String, dynamic> json) =>
    TemplateModel(
      tempTitle: json['tempTitle'] as String?,
      temp: (json['temp'] as List<dynamic>?)
          ?.map((e) => SupplyModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TemplateModelToJson(TemplateModel instance) =>
    <String, dynamic>{
      'tempTitle': instance.tempTitle,
      'temp': instance.temp,
    };
