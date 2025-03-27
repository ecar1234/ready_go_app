import 'package:flutter/cupertino.dart';
import 'package:ready_go_project/data/models/plan_model/plan_model.dart';

class PlanFavoritesProvider with ChangeNotifier {
  List<PlanModel> _favoriteList = [];

  List<PlanModel> get favoriteList => _favoriteList;

  void setFavoriteList(List<PlanModel> list) {
    List<PlanModel> favorite = list.where((item) => item.favorites == true).toList();

    _favoriteList = favorite;
    notifyListeners();
  }

  void addFavoriteList(PlanModel plan) {
    _favoriteList.add(plan);
    notifyListeners();
  }

  void removeFavoriteList(int planId) {
    _favoriteList.removeWhere((item) => item.id == planId);
    notifyListeners();
  }
}
