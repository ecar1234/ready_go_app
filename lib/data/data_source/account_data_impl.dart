
import 'package:ready_go_project/data/data_source/preference/account_preference.dart';
import 'package:ready_go_project/data/models/account_model/account_model.dart';
import 'package:ready_go_project/data/repositories/account_local_data_repo.dart';

class AccountDataImpl implements AccountLocalDataRepo {
  AccountPreference get pref => AccountPreference.singleton;

  @override
  Future<AccountModel> getAccountInfo(int id)async {
    var res = await pref.getAccountInfo(id);
    return res;
  }

  @override
  Future<void> updateAccountInfo(AccountModel info, int id)async {
    await pref.updateAccountInfo(info, id);
  }

  @override
  Future<void> removeAllData(int id)async {
    await pref.removeAllData(id);
  }

  @override
  Future<List<AccountModel>> getAllAccountInfo(int planLength)async {
    final list = await pref.getAllAccountData(planLength);
    return list;
  }
}