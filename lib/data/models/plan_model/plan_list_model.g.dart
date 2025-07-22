// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlanListModel _$PlanListModelFromJson(Map<String, dynamic> json) =>
    PlanListModel(
      planList: (json['planList'] as List<dynamic>?)
          ?.map((e) => PlanModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PlanListModelToJson(PlanListModel instance) =>
    <String, dynamic>{
      'planList': instance.planList,
    };
