import '../../data/models/account_model/account_model.dart';
import '../../data/models/account_model/amount_model.dart';

mixin AccountRepo {
  Future<List<AccountModel>> getTotalUseAccountInfo(int planLength);
  Future<AccountModel> getAccountInfo(String id);
  Future<AccountModel> addAmount(AmountModel amount, int day, String id);
  Future<AccountModel> addTotalAmount(String title, int total, int day, String id);
  Future<AccountModel> removeAmountItem(int firstIdx, int secondIdx, String id);
  Future<AccountModel> editAmountItem(int firstIdx, int secondIdx, AmountModel newAmount, String id);
  Future<AccountModel> removeAllData(String id);
}