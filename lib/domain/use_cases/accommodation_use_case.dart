
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:ready_go_project/domain/repositories/accommodation_repo.dart';

import '../../data/models/accommodation_model/accommodation_model.dart';
import '../../data/repositories/accommodation_local_data_repo.dart';

class AccommodationUseCase with AccommodationRepo{
final _getIt = GetIt.I;
final logger = Logger();

  @override
  Future<List<AccommodationModel>> getAccommodationList(int id)async{
    try{
      var list = _getIt.get<AccommodationLocalDateRepo>().getAccommodationList(id);
      return list;
    }catch(ex){
      logger.e(ex.toString());
      rethrow;
    }
  }

  @override
  Future<List<AccommodationModel>> addAccommodation(AccommodationModel info, int id) async {
    List<AccommodationModel> list = [];

    try{
      list = await _getIt.get<AccommodationLocalDateRepo>().getAccommodationList(id);
      list.add(info);

      await _getIt.get<AccommodationLocalDateRepo>().updateAccommodationList(list, id);
    }catch(ex){
      logger.e(ex.toString());
      rethrow;
    }
    return list;
  }

  @override
  Future<List<AccommodationModel>> removeAccommodation(int idx, int id) async {
    List<AccommodationModel> list = [];
    try{
      list = await _getIt<AccommodationLocalDateRepo>().getAccommodationList(id);
      list.removeAt(idx);

      await _getIt.get<AccommodationLocalDateRepo>().updateAccommodationList(list, id);

    }catch(ex){
      logger.e(ex.toString());
      rethrow;
    }
      return list;
  }

  @override
  Future<List<AccommodationModel>> removeAllData(int id)async{
    await _getIt.get<AccommodationLocalDateRepo>().removeAllData(id);
    return [];
  }
}
