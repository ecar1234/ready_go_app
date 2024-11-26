

import 'package:ready_go_project/data/models/accommodation_model/accommodation_model.dart';

mixin AccommodationLocalDateRepo {
  Future<List<AccommodationModel>> getAccommodationList(int id);
  Future<void> updateAccommodationList(List<AccommodationModel> list, int id);
}