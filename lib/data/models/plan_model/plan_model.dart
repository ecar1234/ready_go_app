
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
part 'plan_model.g.dart';


const Uuid _uuid = Uuid();
String _idFromJson(dynamic id) {
  if (id is int) {
    // 기존 int ID인 경우 String으로 변환
    return _uuid.v4();
  } else if (id is String) {
    // 이미 String ID인 경우 그대로 사용
    return id;
  }
  debugPrint('Warning: Invalid or missing ID found in JSON. Assigning new UUID.');
  return _uuid.v4();
}

// ID를 JSON으로 변환할 때 사용됩니다. (선택 사항, 보통 String 그대로 저장)
// dynamic _idToJson(String id) => id;

@JsonSerializable()
class PlanModel {
  @JsonKey(fromJson: _idFromJson)
  String? id;
  String? nation;
  String? subject;
  List<DateTime?>? schedule;
  bool? favorites;
  String? unit;

  PlanModel({this.id, this.nation, this.subject, this.schedule, this.favorites, this.unit});

  factory PlanModel.fromJson(Map<String, dynamic> json) => _$PlanModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlanModelToJson(this);
}