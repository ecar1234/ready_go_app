

import 'package:ready_go_project/data/models/accommodation_model/accommodation_model.dart';

mixin AccommodationLocalDateRepo {
  Future<List<AccommodationModel>> getAccommodationList(String id);
  Future<void> updateAccommodationList(List<AccommodationModel> list, String id);
  Future<void> removeAllData(String id);
}