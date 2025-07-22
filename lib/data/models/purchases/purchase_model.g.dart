// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchaseModel _$PurchaseModelFromJson(Map<String, dynamic> json) =>
    PurchaseModel(
      productId: json['productId'] as String,
      purchaseDate: json['purchaseDate'] as String,
      platform: json['platform'] as String,
      isVerified: json['isVerified'] as bool,
    );

Map<String, dynamic> _$PurchaseModelToJson(PurchaseModel instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'purchaseDate': instance.purchaseDate,
      'platform': instance.platform,
      'isVerified': instance.isVerified,
    };
