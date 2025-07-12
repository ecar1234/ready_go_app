import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:ready_go_project/data/models/account_model/account_model.dart';
import 'package:ready_go_project/data/models/account_model/amount_model.dart';
import 'package:ready_go_project/data/models/plan_model/plan_model.dart';
import 'package:ready_go_project/data/repositories/plan_local_data_repo.dart';
import 'package:ready_go_project/domain/repositories/account_repo.dart';
import 'package:ready_go_project/domain/repositories/plan_repo.dart';

import '../../data/repositories/account_local_data_repo.dart';
import '../../util/date_util.dart';

final _getIt = GetIt.I.get<AccountLocalDataRepo>();
final logger = Logger();

class AccountUseCase with AccountRepo {
  @override
  Future<AccountModel> getAccountInfo(String id) async {
    try {
      var res = await _getIt.getAccountInfo(id);
      List<PlanModel> planList =
          await GetIt.I.get<PlanLocalDataRepo>().getLocalList();
      List<DateTime?>? startDate =
          planList.firstWhere((item) => item.id == id).schedule!;
      final daysIndex = DateUtil.datesDifference(startDate);

      if (res.usageHistory!.isEmpty) {
        for (var i = 0; i <= daysIndex; i++) {
          List<AmountModel> blank = [];
          res.usageHistory!.add(blank);
        }
        await _getIt.updateAccountInfo(res, id);
      } else {
        if (res.usageHistory!.length != daysIndex + 1) {
          if (res.usageHistory!.length < daysIndex + 1) {
            while (res.usageHistory!.length < daysIndex + 1) {
              List<AmountModel> blank = [];
              res.usageHistory!.add(blank);
            }
          } else if (res.usageHistory!.length > daysIndex + 1) {
            res.usageHistory!
                .removeRange(daysIndex + 1, res.usageHistory!.length);
          }
        }
        await _getIt.updateAccountInfo(res, id);
      }

      return res;
    } catch (ex) {
      logger.e(ex.toString());
      rethrow;
    }
  }

  @override
  Future<AccountModel> addAmount(AmountModel amount, int day, String id) async {
    try {
      AccountModel account = await _getIt.getAccountInfo(id);
      List<List<AmountModel>?> history = account.usageHistory!;

      switch (amount.category) {
        case 0:
          account.balance = (account.balance ?? 0) - amount.amount!;
          account.useExchangeMoney =
              (account.useExchangeMoney ?? 0) + amount.amount!;
          break;
        case 1:
          account.useKoCash = (account.useKoCash ?? 0) + amount.amount!;
          break;
        case 2:
          account.useCard = (account.useCard ?? 0) + amount.amount!;
          break;
      }

      if (history.length <= day || history[day] == null) {
        while (history.length <= day) {
          history.add([]);
        }
      }

      history[day]!.add(amount);

      account.usageHistory = history;
      await _getIt.updateAccountInfo(account, id);
      return account;
    } catch (ex) {
      logger.e(ex.toString());
      rethrow;
    }
  }

  @override
  Future<AccountModel> addTotalAmount(
      title, int total, int day, String id) async {
    try {
      AccountModel account = await _getIt.getAccountInfo(id);
      account.totalExchangeCost = (account.totalExchangeCost ?? 0) + total;
      account.balance =
          (account.totalExchangeCost ?? 0) - (account.useExchangeMoney ?? 0);

      final planList = await GetIt.I.get<PlanLocalDataRepo>().getLocalList();
      final plan = planList.firstWhere((item) => item.id == id,
          orElse: () => throw Exception("Plan not found"));

      if (plan.schedule == null || plan.schedule!.first == null) {
        throw Exception("Plan schedule is not valid");
      }

      final useDay = plan.schedule!.first!.add(Duration(days: day));

      final amount = AmountModel(
        id: day.toString(),
        type: AmountType.add,
        amount: total,
        usageTime: useDay,
        title: title,
        category: 0,
      );

      account.usageHistory ??= [];

      while (account.usageHistory!.length <= day) {
        account.usageHistory!.add([]);
      }

      account.usageHistory![day]!.add(amount);

      await _getIt.updateAccountInfo(account, id);
      return account;
    } catch (ex) {
      logger.e(ex.toString());
      rethrow;
    }
  }

  @override
  Future<AccountModel> removeAmountItem(
      int firstIdx, int secondIdx, String id) async {
    try {
      var account = await _getIt.getAccountInfo(id);
      var history = account.usageHistory!;
      var removeItem = history[firstIdx]![secondIdx];

      if (removeItem.type == AmountType.add) {
        account.totalExchangeCost =
            (account.totalExchangeCost ?? 0) - removeItem.amount!;
        account.balance = (account.totalExchangeCost ?? 0) -
            (account.useExchangeMoney ?? 0);
      } else if (removeItem.type == AmountType.use) {
        if (removeItem.category == 0) {
          account.balance = (account.balance ?? 0) + removeItem.amount!;
          account.useExchangeMoney =
              (account.useExchangeMoney ?? 0) - removeItem.amount!;
        } else if (removeItem.category == 2) {
          account.useCard = (account.useCard ?? 0) - removeItem.amount!;
        }
      }

      account.usageHistory![firstIdx]!.removeAt(secondIdx);

      await _getIt.updateAccountInfo(account, id);
      return account;
    } on Exception catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  void _updateAccountForAmount(
      AccountModel account, AmountModel amount, bool isReverting) {
    int sign = isReverting ? -1 : 1;
    if (amount.type == AmountType.add) {
      account.totalExchangeCost =
          (account.totalExchangeCost ?? 0) + (sign * amount.amount!);
    } else {
      // AmountType.use
      if (amount.category == 0) {
        // cash
        account.balance = (account.balance ?? 0) - (sign * amount.amount!);
        account.useExchangeMoney =
            (account.useExchangeMoney ?? 0) + (sign * amount.amount!);
      } else if (amount.category == 2) {
        // card
        account.useCard = (account.useCard ?? 0) + (sign * amount.amount!);
      }
    }
  }

  @override
  Future<AccountModel> editAmountItem(
      int firstIdx, int secondIdx, AmountModel newAmount, String id) async {
    try {
      AccountModel account = await _getIt.getAccountInfo(id);
      List<List<AmountModel>?>? history = account.usageHistory;

      if (history == null ||
          history.length <= firstIdx ||
          history[firstIdx] == null ||
          history[firstIdx]!.length <= secondIdx) {
        throw Exception("Invalid indices for editing amount");
      }

      AmountModel oldAmount = history[firstIdx]![secondIdx];

      _updateAccountForAmount(account, oldAmount, true); // Revert old
      _updateAccountForAmount(account, newAmount, false); // Apply new

      // Recalculate balance if totalExchangeCost changed
      if (oldAmount.type == AmountType.add || newAmount.type == AmountType.add) {
        account.balance =
            (account.totalExchangeCost ?? 0) - (account.useExchangeMoney ?? 0);
      }

      history[firstIdx]![secondIdx] = newAmount;
      account.usageHistory = history;

      await _getIt.updateAccountInfo(account, id);
      return account;
    } catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }

  @override
  Future<AccountModel> removeAllData(String id) async {
    await _getIt.removeAllData(id);
    return AccountModel();
  }

  @override
  Future<List<AccountModel>> getTotalUseAccountInfo(int planLength) async {
    final allAccountInfo = await _getIt.getAllAccountInfo(planLength);
    return allAccountInfo;
  }
}
