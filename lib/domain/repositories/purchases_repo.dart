import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:ready_go_project/data/models/purchases/purchase_model.dart';

mixin PurchasesRepo {
  Future<List<PurchaseModel>> getPurchasesList();
  Future<List<PurchaseModel>> checkPurchasesData();
  Future<void> removePurchasesData(List<PurchaseModel> items);
  Future<List<PurchaseModel>> addPurchasesData(PurchaseModel item);
}