

import 'package:json_annotation/json_annotation.dart';
part 'purchase_model.g.dart';

@JsonSerializable()
class PurchaseModel{
  final String productId;           // 상품 ID (고유)
  final String purchaseDate;        // 구매 일시 (ISO8601 형식)
  final String platform;            // ios / android
  final bool isVerified;            // 서버 검증 여부 (선택)

  PurchaseModel({
    required this.productId,
    required this.purchaseDate,
    required this.platform,
    required this.isVerified,
  });

  factory PurchaseModel.fromJson(Map<String, dynamic> json) => _$PurchaseModelFromJson(json);
  Map<String, dynamic> toJson() => _$PurchaseModelToJson(this);
}