import 'package:get_it/get_it.dart';
import 'package:ready_go_project/data/models/account_model/account_model.dart';
import 'package:ready_go_project/data/models/account_model/amount_model.dart';
import 'package:ready_go_project/data/models/plan_model/plan_model.dart';
import 'package:ready_go_project/domain/entities/account_entity.dart';
import 'package:ready_go_project/domain/use_cases/plan_use_case.dart';

GetIt _getIt = GetIt.I;

class AccountUseCase {
  Future<AccountModel> getAccountInfo(int id) async {
    try {
      var res = await _getIt.get<AccountEntity>().getAccountInfo(id);
      return res;
    } catch (ex) {
      print(ex.toString());
      rethrow;
    }
  }

  Future<AccountModel> addAmount(AmountModel amount, int day, int id) async {
    AccountModel account = AccountModel();

    try {
      account = await _getIt.get<AccountEntity>().getAccountInfo(id);
      List<List<AmountModel>?> history = account.usageHistory!;

      switch (amount.category) {
        case 0:
          account.totalUseAccount = account.totalUseAccount! - amount.amount!;
          account.exchange = account.exchange! + amount.amount!;
        case 1:
          account.cash = account.cash! + amount.amount!;
        case 2:
          account.card = account.card! + amount.amount!;
      }

      if(history.isEmpty){
        List<AmountModel> list = [];
        list.add(amount);
        history.add(list);
      }else{
        if(history.length >= day && history[day-1] != null){
          if(history[day-1]!.first.id != amount.id){
            List<AmountModel> list = [];
            list.add(amount);
            history.add(list);
          }
          history[day-1]!.add(amount);
        }else {
          List<AmountModel> list = [];
          list.add(amount);
          history.add(list);
        }
      }
      history.sort((a, b) => int.tryParse(a!.first.id!)!.compareTo(int.parse(b!.first.id!)));

      await _getIt.get<AccountEntity>().updateAccountInfo(account, id);
    } catch (ex) {
      print(ex.toString());
      rethrow;
    }

    return account;
  }

  Future<AccountModel> addTotalAmount(int total, int day, int id) async {
    try {
      AccountModel account = await _getIt.get<AccountEntity>().getAccountInfo(id);
      account.totalExchangeAccount = account.totalExchangeAccount! + total;
      account.totalUseAccount = account.totalExchangeAccount! - account.exchange!;

      try {
        var planList = await _getIt.get<PlanUseCase>().getLocalList();
        PlanModel? plan = PlanModel();
        for (var item in planList) {
          if (item.id == id) {
            plan = item;
            break;
          }
        }

        try {
          DateTime? useDay;
          if(plan != null){
            if(plan.schedule != null){
              if(plan.schedule!.first != null){
                if(day == 1){
                  useDay = plan.schedule!.first!;
                }else{
                  useDay = plan.schedule!.first!.add(Duration(days: day));
                }
              }else{
                throw("start schedule is null");
              }
            }else{
              throw("schedule is null");
            }
          }else {
            throw("plan is null");
          }
          try {
            List<List<AmountModel>?> history = account.usageHistory!;

            AmountModel amount = AmountModel();
            amount.id = day.toString();
            amount.type = AmountType.add;
            amount.amount = total;
            amount.usageTime = useDay;
            amount.title = "경비 추가";
            amount.category = 0;

            if(history.isEmpty){
              List<AmountModel> list = [];
              list.add(amount);
              history.add(list);
            }else{
             if(history.length > day && history[day-1] != null){
               history[day-1]!.add(amount);
             }else {
               List<AmountModel> list = [];
               list.add(amount);
               history.add(list);
             }
            }

            history.sort((a, b) => int.tryParse(a!.first.id!)!.compareTo(int.parse(b!.first.id!)));

          } on Exception catch (e) {
            print(e.toString());
            rethrow;
          }
        } on Exception catch (e) {
          print(e.toString());
          rethrow;
        }
      } on Exception catch (e) {
        print(e.toString());
        rethrow;
      }

      await _getIt.get<AccountEntity>().updateAccountInfo(account, id);

      return account;
    } catch (ex) {
      print(ex.toString());
      rethrow;
    }
  }

  Future<AccountModel> removeAmountItem(int firstIdx, int secondIdx, int id)async{
    try {
      var account = await _getIt.get<AccountEntity>().getAccountInfo(id);
      var history = account.usageHistory!;
      history[firstIdx]!.removeAt(secondIdx);

      if(history[firstIdx]!.isEmpty){
        history.removeAt(firstIdx);
      }

      await _getIt.get<AccountEntity>().updateAccountInfo(account, id);
      return account;
    } on Exception catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future<AccountModel> removeAllData(int id) async {
    await _getIt.get<AccountEntity>().removeAllData(id);
    return AccountModel();
  }
}
