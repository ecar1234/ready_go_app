import '../../data/models/account_model/account_model.dart';
import '../../data/models/account_model/amount_model.dart';

mixin AccountRepo {
  Future<List<AccountModel>> getTotalUseAccountInfo(int planLength);
  Future<AccountModel> getAccountInfo(int id);
  Future<AccountModel> addAmount(AmountModel amount, int day, int id);
  Future<AccountModel> addTotalAmount(int total, int day, int id);
  Future<AccountModel> removeAmountItem(int firstIdx, int secondIdx, int id);
  Future<AccountModel> editAmountItem(int firstIdx, int secondIdx, AmountModel newAmount, int id);
  Future<AccountModel> removeAllData(int id);
}