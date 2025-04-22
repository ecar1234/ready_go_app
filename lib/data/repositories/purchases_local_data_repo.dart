import 'package:in_app_purchase/in_app_purchase.dart';

import '../models/purchases/purchase_model.dart';

mixin PurchasesLocalDataRepo {
  Future<List<PurchaseModel>> getPurchasesData();
  Future<void> updatePurchasesData(List<PurchaseModel> list);
}