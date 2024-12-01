
import '../../data/models/account_model/account_model.dart';
import '../../data/models/account_model/amount_model.dart';

mixin AccountLocalDataRepo {
  Future<AccountModel> getAccountInfo(int id);
  Future<void> updateAccountInfo(AccountModel info, int id);
  Future<void> removeAllData(int id);
}