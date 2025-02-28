
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:ready_go_project/data/models/account_model/account_model.dart';
import 'package:ready_go_project/data/models/account_model/amount_model.dart';
import 'package:ready_go_project/data/models/plan_model/plan_model.dart';
import 'package:ready_go_project/domain/repositories/account_repo.dart';
import 'package:ready_go_project/domain/repositories/plan_repo.dart';
import 'package:ready_go_project/domain/use_cases/plan_use_case.dart';

import '../../data/repositories/account_local_data_repo.dart';



class AccountUseCase with  AccountRepo{
  final _getIt = GetIt.I;
  final logger = Logger();

  @override
  Future<AccountModel> getAccountInfo(int id) async {
    try {
      var res = await _getIt.get<AccountLocalDataRepo>().getAccountInfo(id);
      return res;
    } catch (ex) {
      logger.e(ex.toString());
      rethrow;
    }
  }

  @override
  Future<AccountModel> addAmount(AmountModel amount, int day, int id) async {
    AccountModel account = AccountModel();

    try {
      account = await _getIt.get<AccountLocalDataRepo>().getAccountInfo(id);
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

      if (history.isEmpty) {
        List<AmountModel> list = [];
        list.add(amount);
        history.add(list);
      } else {
        if (history.length >= day && history[day - 1] != null) {
          if (history[day - 1]!.first.id != amount.id) {
            List<AmountModel> list = [];
            list.add(amount);
            history.add(list);
          }
          history[day - 1]!.add(amount);
        } else {
          List<AmountModel> list = [];
          list.add(amount);
          history.add(list);
        }
      }
      history.sort((a, b) => int.tryParse(a!.first.id!)!.compareTo(int.parse(b!.first.id!)));

      await _getIt.get<AccountLocalDataRepo>().updateAccountInfo(account, id);
    } catch (ex) {
      logger.e(ex.toString());
      rethrow;
    }

    return account;
  }

  @override
  Future<AccountModel> addTotalAmount(int total, int day, int id) async {
    try {
      AccountModel account = await _getIt.get<AccountLocalDataRepo>().getAccountInfo(id);
      account.totalExchangeAccount = account.totalExchangeAccount! + total;
      account.totalUseAccount = account.totalExchangeAccount! - account.exchange!;

      try {
        var planList = await _getIt.get<PlanRepo>().getLocalList();
        PlanModel? plan = PlanModel();
        for (var item in planList) {
          if (item.id == id) {
            plan = item;
            break;
          }
        }

        try {
          DateTime? useDay;
          if (plan != null) {
            if (plan.schedule != null) {
              if (plan.schedule!.first != null) {
                if (day == 1) {
                  useDay = plan.schedule!.first!;
                } else {
                  useDay = plan.schedule!.first!.add(Duration(days: day));
                }
              } else {
                throw ("start schedule is null");
              }
            } else {
              throw ("schedule is null");
            }
          } else {
            throw ("plan is null");
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

            if (history.isEmpty) {
              List<AmountModel> list = [];
              list.add(amount);
              history.add(list);
            } else {
              if (history.length >= day && history[day - 1] != null) {
                if (history[day - 1]!.first.id != amount.id) {
                  List<AmountModel> list = [];
                  list.add(amount);
                  history.add(list);
                }
                history[day - 1]!.add(amount);
              } else {
                List<AmountModel> list = [];
                list.add(amount);
                history.add(list);
              }
            }

            history.sort((a, b) => int.tryParse(a!.first.id!)!.compareTo(int.parse(b!.first.id!)));
          } on Exception catch (e) {
            logger.e(e.toString());
            rethrow;
          }
        } on Exception catch (e) {
          logger.e(e.toString());
          rethrow;
        }
      } on Exception catch (e) {
        logger.e(e.toString());
        rethrow;
      }

      await _getIt.get<AccountLocalDataRepo>().updateAccountInfo(account, id);

      return account;
    } catch (ex) {
      logger.e(ex.toString());
      rethrow;
    }
  }

  @override
  Future<AccountModel> removeAmountItem(int firstIdx, int secondIdx, int id) async {
    try {
      var account = await _getIt.get<AccountLocalDataRepo>().getAccountInfo(id);
      var history = account.usageHistory!;
      var removeItem = history[firstIdx]![secondIdx];

      if (removeItem.type == AmountType.add) {
        account.totalExchangeAccount = account.totalExchangeAccount! - removeItem.amount!;
        account.totalUseAccount = account.totalExchangeAccount! - account.exchange!;
      } else if (removeItem.type == AmountType.use) {
        if(removeItem.category == 0){
          account.totalUseAccount = account.totalUseAccount! + removeItem.amount!;
          account.exchange = account.exchange! - removeItem.amount!;
        }else if(removeItem.category == 2){
          account.card = account.card! - removeItem.amount!;
        }
      }

      account.usageHistory![firstIdx]!.removeAt(secondIdx);

      if (account.usageHistory![firstIdx]!.isEmpty) {
        account.usageHistory!.removeAt(firstIdx);
      }

      await _getIt.get<AccountLocalDataRepo>().updateAccountInfo(account, id);
      return account;
    } on Exception catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  @override
  Future<AccountModel> editAmountItem(int firstIdx, int secondIdx, AmountModel newAmount, int id) async {
    try {
      var account = await _getIt.get<AccountLocalDataRepo>().getAccountInfo(id);
      var history = account.usageHistory!;
      var item = history[firstIdx]![secondIdx];

      if (item.category == newAmount.category) {
        if (newAmount.type == AmountType.add) {
          account.totalExchangeAccount = (account.totalExchangeAccount! - item.amount!) + newAmount.amount!;
          account.totalUseAccount = account.totalExchangeAccount! - account.exchange!;
        } else if (newAmount.type == AmountType.use) {
          account.totalUseAccount = (account.totalUseAccount! + item.amount!) - newAmount.amount!;
          account.exchange = (account.exchange! - item.amount!) + newAmount.amount!;
        }
      } else {
        if (newAmount.category == 2) {
          account.exchange = account.exchange! - item.amount!;
          account.card = account.card! + newAmount.amount!;
          account.totalUseAccount = account.totalExchangeAccount! - account.exchange!;
        } else if (newAmount.category == 0) {
          account.card = account.card! - newAmount.amount!;
          account.exchange = account.exchange! + newAmount.amount!;
          account.totalUseAccount = account.totalExchangeAccount! - account.exchange!;
        }
      }
      account.usageHistory![firstIdx]![secondIdx] = newAmount;

      await _getIt.get<AccountLocalDataRepo>().updateAccountInfo(account, id);
      return account;
    } on Exception catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  @override
  Future<AccountModel> removeAllData(int id) async {
    await _getIt.get<AccountLocalDataRepo>().removeAllData(id);
    return AccountModel();
  }
}
