
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ready_go_project/domain/entities/roaming_entity.dart';

import '../../data/models/roaming_model/roaming_model.dart';
import '../../data/models/roaming_model/roaming_period_model.dart';

class RoamingUseCase {
  final GetIt _getIt = GetIt.I;
  
  Future<RoamingModel> getRoamingData(int id)async{
    var data = await _getIt.get<RoamingEntity>().getRoamingData(id);
    return data;
  }
  Future<List<XFile>> addImage(XFile image, int id) async {
    var list = await _getIt.get<RoamingEntity>().getRoamingImgList(id);
    list.add(image);
    await _getIt.get<RoamingEntity>().updateRoamingImgList(list, id);
    return list;
  }

  Future<List<XFile>> removeImage(XFile image, int id) async {
    var list = await _getIt.get<RoamingEntity>().getRoamingImgList(id);
    list.removeWhere((img) => img.path == image.path);
    await _getIt.get<RoamingEntity>().updateRoamingImgList(list, id);
    return list;
  }

  Future<void> enterAddress(String addr, int id) async {
    await _getIt.get<RoamingEntity>().updateRoamingAddress(addr, id);
  }


  Future<void> removeAddress(int id) async {
    await _getIt.get<RoamingEntity>().updateRoamingAddress("", id);
  }

  Future<void> enterCode(String code, int id) async {
    await _getIt.get<RoamingEntity>().updateRoamingCode(code, id);
  }

  Future<void> removeCode(int id) async {
    await _getIt.get<RoamingEntity>().updateRoamingCode("", id);
  }

  Future<RoamingPeriodModel> setPeriodDate(int day, int id)async{
    RoamingPeriodModel period = RoamingPeriodModel();

    period.period = day;
    period.isActive = false;
    period.startDate = DateTime.now();
    period.endDate = DateTime.now().add(Duration(days: day));
    await _getIt.get<RoamingEntity>().updateRoamingPeriod(period, id);

    return period;
  }
  Future<RoamingPeriodModel> startPeriod(int id)async{
    var period = await _getIt.get<RoamingEntity>().getRoamingPeriod(id);
    period.startDate = DateTime.now();
    await _getIt.get<RoamingEntity>().updateRoamingPeriod(period, id);

    return period;
  }
  Future<RoamingPeriodModel> resetPeriod(int id)async{
    RoamingPeriodModel period = RoamingPeriodModel(
      period: 0,
      isActive: false,
      startDate: DateTime.now(),
      endDate: DateTime.now()
    );
    await _getIt.get<RoamingEntity>().updateRoamingPeriod(period, id);

    return period;
  }


}