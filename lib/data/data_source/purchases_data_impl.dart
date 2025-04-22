import 'package:ready_go_project/data/data_source/preference/purchases_preference.dart';
import 'package:ready_go_project/data/repositories/purchases_local_data_repo.dart';

import '../models/purchases/purchase_model.dart';

class PurchasesDataImpl with PurchasesLocalDataRepo{
  PurchasesPreference get pref => PurchasesPreference.singleton;
  @override
  Future<List<PurchaseModel>> getPurchasesData() async{
    return pref.getPurchasesList();
  }

  @override
  Future<void> updatePurchasesData(List<PurchaseModel> list) async{
     pref.updatePurchasesList(list);
  }

}