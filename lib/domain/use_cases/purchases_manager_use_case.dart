

import 'package:get_it/get_it.dart';
// import 'package:in_app_purchase_platform_interface/src/types/purchase_details.dart';
import 'package:ready_go_project/data/models/purchases/purchase_model.dart';
import 'package:ready_go_project/data/repositories/purchases_local_data_repo.dart';
import 'package:ready_go_project/domain/repositories/purchases_repo.dart';

class PurchasesManagerUseCase with PurchasesRepo {
  @override
  Future<List<PurchaseModel>> addPurchasesData(PurchaseModel item)async {
    List<PurchaseModel> list = await GetIt.I.get<PurchasesLocalDataRepo>().getPurchasesData();
    list.add(item);
    await GetIt.I.get<PurchasesLocalDataRepo>().updatePurchasesData(list);
    return list;
  }

  @override
  Future<List<PurchaseModel>> checkPurchasesData()async {
    // TODO: implement checkPurchasesData
    throw UnimplementedError();
  }

  @override
  Future<List<PurchaseModel>> getPurchasesList() async{
    final list = await GetIt.I.get<PurchasesLocalDataRepo>().getPurchasesData();
    return list;
  }

  @override
  Future<void> removePurchasesData(List<PurchaseModel> items) async{
    final list = await GetIt.I.get<PurchasesLocalDataRepo>().getPurchasesData();
    if(list.length != items.length){
      await GetIt.I.get<PurchasesLocalDataRepo>().updatePurchasesData(items);
    }else{
      return;
    }
  }

}