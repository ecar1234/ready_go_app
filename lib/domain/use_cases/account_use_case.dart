import 'package:get_it/get_it.dart';
import 'package:ready_go_project/data/models/account_model/account_model.dart';
import 'package:ready_go_project/data/models/account_model/amount_model.dart';
import 'package:ready_go_project/domain/entities/account_entity.dart';
import 'package:ready_go_project/domain/repositories/account_local_data_repo.dart';

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
      Map<int, List<AmountModel>> history = account.usageHistory!;

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
        history[day] ??= [];
        history[day]!.add(amount);
      } else {
        if (history.containsKey(day)) {
          history[day]!.add(amount);
        } else {
          history[day] ??= [];
          history[day]!.add(amount);
        }

        List<MapEntry<int, List<AmountModel>>> entry = history.entries.toList();
        entry.sort((a, b) => a.key.compareTo(b.key));
        account.usageHistory = Map.fromEntries(entry);
      }

      await _getIt.get<AccountEntity>().updateAccountInfo(account, id);
    } catch (ex) {
      print(ex.toString());
      rethrow;
    }

    return account;
  }

  Future<AccountModel> addTotalAmount(int total, int id) async {
    AccountModel account = AccountModel();
    try {
      account = await _getIt.get<AccountEntity>().getAccountInfo(id);

      account.totalExchangeAccount = account.totalExchangeAccount! + total;
      account.totalUseAccount = account.totalExchangeAccount! - account.exchange!;

      await _getIt.get<AccountEntity>().updateAccountInfo(account, id);
    } catch (ex) {
      print(ex.toString());
      rethrow;
    }
    return account;
  }
}
