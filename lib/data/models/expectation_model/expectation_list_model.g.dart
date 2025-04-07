// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expectation_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExpectationListModel _$ExpectationListModelFromJson(
        Map<String, dynamic> json) =>
    ExpectationListModel(
      expectationList: (json['expectationList'] as List<dynamic>?)
          ?.map((e) => ExpectationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      numOfPeople: (json['numOfPeople'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ExpectationListModelToJson(
        ExpectationListModel instance) =>
    <String, dynamic>{
      'expectationList': instance.expectationList,
      'numOfPeople': instance.numOfPeople,
    };
