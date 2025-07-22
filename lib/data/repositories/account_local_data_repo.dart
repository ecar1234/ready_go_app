
import '../models/account_model/account_model.dart';

mixin AccountLocalDataRepo {
  Future<AccountModel> getAccountInfo(String id);
  Future<void> updateAccountInfo(AccountModel info, String id);
  Future<void> removeAllData(String id);
  Future<List<AccountModel>> getAllAccountInfo(int planLength);
}