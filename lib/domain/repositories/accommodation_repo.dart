import '../../data/models/accommodation_model/accommodation_model.dart';

mixin AccommodationRepo {
  Future<List<AccommodationModel>> getAccommodationList(int id);
  Future<List<AccommodationModel>> addAccommodation(AccommodationModel info, int id);
  Future<List<AccommodationModel>> removeAccommodation(int idx, int id);
  Future<List<AccommodationModel>> removeAllData(int id);
}