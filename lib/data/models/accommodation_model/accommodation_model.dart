
import 'package:json_annotation/json_annotation.dart';
part 'accommodation_model.g.dart';

@JsonSerializable()
class AccommodationModel {
  String? name;
  String? address;
  DateTime? startDay;
  int? period;
  String? checkInTime;
  String? checkOutTime;
  String? payment;
  String? bookApp;
  String? bookNum;

  AccommodationModel({this.name, this.address, this.startDay, this.period,
    this.checkInTime, this.checkOutTime, this.payment, this.bookApp, this.bookNum});

  factory AccommodationModel.fromJson(Map<String, dynamic> json) => _$AccommodationModelFromJson(json);
  Map<String, dynamic> toJson() => _$AccommodationModelToJson(this);
}
