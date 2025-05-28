import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:ready_go_project/data/models/account_model/account_model.dart';
import 'package:ready_go_project/data/models/account_model/amount_model.dart';
import 'package:ready_go_project/data/models/plan_model/plan_model.dart';
import 'package:ready_go_project/domain/entities/provider/plan_list_provider.dart';
import 'package:ready_go_project/domain/repositories/account_repo.dart';
import 'package:ready_go_project/domain/repositories/plan_repo.dart';
import 'package:ready_go_project/domain/use_cases/plan_use_case.dart';

import '../../data/repositories/account_local_data_repo.dart';
import '../../util/date_util.dart';

class AccountUseCase with AccountRepo {
  final _getIt = GetIt.I;
  final logger = Logger();

  @override
  Future<AccountModel> getAccountInfo(int id) async {
    try {
      var res = await _getIt.get<AccountLocalDataRepo>().getAccountInfo(id);
      List<PlanModel> planList = await GetIt.I.get<PlanRepo>().getLocalList();
      List<DateTime?>? startDate = planList.firstWhere((item) => item.id == id).schedule!;
      final daysIndex = DateUtil.datesDifference(startDate);
      if (res.usageHistory!.isEmpty || res.usageHistory!.length != daysIndex + 1) {
        for (var i = 0; i <= daysIndex; i++) {
          if(res.usageHistory![i] == null){
            List<AmountModel> blank = [];
            res.usageHistory!.add(blank);
          }
        }
        if (res.usageHistory!.length > daysIndex + 1) {
          res.usageHistory!.removeRange(daysIndex + 1, res.usageHistory!.length);
        }
      }

      await _getIt.get<AccountLocalDataRepo>().updateAccountInfo(res, id);
      return res;
    } catch (ex) {
      logger.e(ex.toString());
      rethrow;
    }
  }

  @override
  Future<AccountModel> addAmount(AmountModel amount, int day, int id) async {
    AccountModel account = await _getIt.get<AccountLocalDataRepo>().getAccountInfo(id);
    List<List<AmountModel>?> history = account.usageHistory!;

    try {
      switch (amount.category) {
        case 0:
          account.balance = account.balance! - amount.amount!;
          account.useExchangeMoney = account.useExchangeMoney! + amount.amount!;
        case 1:
          account.useKoCash = account.useKoCash! + amount.amount!;
        case 2:
          account.useCard = account.useCard! + amount.amount!;
      }

      history[day]!.add(amount);

      account.usageHistory = history;
      await _getIt.get<AccountLocalDataRepo>().updateAccountInfo(account, id);
      return account;
    } catch (ex) {
      logger.e(ex.toString());
      rethrow;
    }
  }

  @override
  Future<AccountModel> addTotalAmount(int total, int day, int id) async {
    try {
      AccountModel account = await _getIt.get<AccountLocalDataRepo>().getAccountInfo(id);
      account.totalExchangeCost = account.totalExchangeCost! + total;
      account.balance = account.totalExchangeCost! - account.useExchangeMoney!;

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
                if (day == 0) {
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

            history[day]!.add(amount);

            // if (history.isEmpty) {
            //   List<AmountModel> list = [];
            //   list.add(amount);
            //   history.add(list);
            // } else {
            //   if (history[day] != null) {
            //     if (history[day]!.first.id != amount.id) {
            //       List<AmountModel> list = [];
            //       list.add(amount);
            //       history.add(list);
            //     }else{
            //       history[day]!.add(amount);
            //     }
            //   } else {
            //     List<AmountModel> list = [];
            //     list.add(amount);
            //     history.add(list);
            //   }
            // }

            // history.sort((a, b) => int.tryParse(a!.first.id!)!.compareTo(int.parse(b!.first.id!)));
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
        account.totalExchangeCost = account.totalExchangeCost! - removeItem.amount!;
        account.balance = account.totalExchangeCost! - account.useExchangeMoney!;
      } else if (removeItem.type == AmountType.use) {
        if (removeItem.category == 0) {
          account.balance = account.balance! + removeItem.amount!;
          account.useExchangeMoney = account.useExchangeMoney! - removeItem.amount!;
        } else if (removeItem.category == 2) {
          account.useCard = account.useCard! - removeItem.amount!;
        }
      }

      account.usageHistory![firstIdx]!.removeAt(secondIdx);

      await _getIt.get<AccountLocalDataRepo>().updateAccountInfo(account, id);
      return account;
    } on Exception catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  @override
  Future<AccountModel> editAmountItem(int firstIdx, int secondIdx, AmountModel newAmount, int id) async {
    AccountModel account = await _getIt.get<AccountLocalDataRepo>().getAccountInfo(id);
    List<List<AmountModel>?>? history = account.usageHistory!;
    AmountModel item = history[firstIdx]![secondIdx];

    try {
      if (newAmount.type == AmountType.add) {
        account.totalExchangeCost = (account.totalExchangeCost! - item.amount!) + newAmount.amount!;
        account.balance = account.totalExchangeCost! - account.useExchangeMoney!;
      } else {
        if (item.category == newAmount.category) {
          if (item.category == 0) {
            account.balance = (account.balance! + item.amount!) - newAmount.amount!;
            account.useExchangeMoney = (account.useExchangeMoney! - item.amount!) + newAmount.amount!;
          } else {
            account.useCard = (account.useCard! - item.amount!) + newAmount.amount!;
          }
        } else {
          if (item.category == 0) {
            account.balance = account.balance! + item.amount!;
            account.useExchangeMoney = account.useExchangeMoney! - item.amount!;
            account.useCard = account.useCard! + newAmount.amount!;
          } else {
            account.balance = account.balance! - newAmount.amount!;
            account.useCard = account.useCard! - item.amount!;
            account.useExchangeMoney = account.useExchangeMoney! + newAmount.amount!;
          }
        }
      }

      history[firstIdx]!.removeAt(secondIdx);
      history[firstIdx]!.insert(secondIdx, newAmount);

      // if(item.id != newAmount.id){
      //   account.usageHistory![firstIdx]!.removeAt(secondIdx);
      //   if(account.usageHistory![firstIdx]!.isEmpty){
      //     account.usageHistory!.removeAt(firstIdx);
      //   }
      //   if(history.length >= firstIdx && history[firstIdx] != null){
      //     history[firstIdx]!.add(newAmount);
      //   }else {
      //     List<AmountModel> list = [];
      //     list.add(newAmount);
      //     account.usageHistory!.add(list);
      //   }
      //
      //   if (item.type == AmountType.add) {
      //     // account.usageHistory![day-1]![secondIdx] = newAmount;
      //     account.totalExchangeCost = (account.totalExchangeCost! - item.amount!) + newAmount.amount!;
      //     account.balance = account.totalExchangeCost! - account.useExchangeMoney!;
      //   } else {
      //     // account.usageHistory![day-1]![secondIdx] = newAmount;
      //     if (item.category == newAmount.category) {
      //       if (item.category == 0) {
      //         account.balance = (account.balance! - item.amount!) + newAmount.amount!;
      //         account.useExchangeMoney = (account.useExchangeMoney! - item.amount!) + newAmount.amount!;
      //       } else {
      //         account.useCard = (account.useCard! - item.amount!) + newAmount.amount!;
      //       }
      //     } else {
      //       if (item.category == 0) {
      //         account.balance = account.balance! + item.amount!;
      //         account.useExchangeMoney = account.useExchangeMoney! - item.amount!;
      //         account.useCard = account.useCard! + newAmount.amount!;
      //       } else {
      //         account.balance = account.balance! - newAmount.amount!;
      //         account.useCard = account.useCard! - item.amount!;
      //         account.useExchangeMoney = account.useExchangeMoney! + newAmount.amount!;
      //       }
      //     }
      //   }
      //
      // }
      // else {
      //   if (item.type == AmountType.add) {
      //     account.usageHistory![firstIdx]![secondIdx] = newAmount;
      //     account.totalExchangeCost = (account.totalExchangeCost! - item.amount!) + newAmount.amount!;
      //     account.balance = account.totalExchangeCost! - account.useExchangeMoney!;
      //   } else {
      //     account.usageHistory![firstIdx]![secondIdx] = newAmount;
      //     if (item.category == newAmount.category) {
      //       if (item.category == 0) {
      //         account.balance = (account.balance! - item.amount!) + newAmount.amount!;
      //         account.useExchangeMoney = (account.useExchangeMoney! - item.amount!) + newAmount.amount!;
      //       } else {
      //         account.useCard = (account.useCard! - item.amount!) + newAmount.amount!;
      //       }
      //     } else {
      //       if (item.category == 0) {
      //         account.balance = account.balance! + item.amount!;
      //         account.useExchangeMoney = account.useExchangeMoney! - item.amount!;
      //         account.useCard = account.useCard! + newAmount.amount!;
      //       } else {
      //         account.balance = account.balance! - newAmount.amount!;
      //         account.useCard = account.useCard! - item.amount!;
      //         account.useExchangeMoney = account.useExchangeMoney! + newAmount.amount!;
      //       }
      //     }
      //   }
      // }
      account.usageHistory = history;

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

  @override
  Future<List<AccountModel>> getTotalUseAccountInfo(int planLength) async {
    final allAccountInfo = await _getIt.get<AccountLocalDataRepo>().getAllAccountInfo(planLength);
    return allAccountInfo;
  }
}
