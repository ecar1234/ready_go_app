
import 'package:get_it/get_it.dart';
import 'package:ready_go_project/data/data_source/preference/preference_provider.dart';
import 'package:ready_go_project/data/models/account_model/account_model.dart';
import 'package:ready_go_project/domain/repositories/account_local_data_repo.dart';

class AccountDataUseCase implements AccountLocalDataRepo {
  PreferenceProvider get pref => PreferenceProvider.singleton;
  @override
  Future<AccountModel> getAccountInfo(int id) async{
    AccountModel accountInfo = await pref.getAccountInfo(id);
    return accountInfo;
  }

  @override
  Future<void> updateAccountInfo(AccountModel info, int id)async {
    await pref.updateAccountInfo(info ,id);
  }

}