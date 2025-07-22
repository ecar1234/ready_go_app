import '../../data/models/accommodation_model/accommodation_model.dart';

mixin AccommodationRepo {
  Future<List<AccommodationModel>> getAccommodationList(String id);
  Future<List<AccommodationModel>> addAccommodation(AccommodationModel info, String id);
  Future<List<AccommodationModel>> removeAccommodation(int idx, String id);
  Future<List<AccommodationModel>> removeAllData(String id);
}