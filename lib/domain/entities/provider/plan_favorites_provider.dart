import 'package:flutter/cupertino.dart';
import 'package:ready_go_project/data/models/plan_model/plan_model.dart';

class PlanFavoritesProvider {
  List<PlanModel> _favoriteList = [];
  List<PlanModel> get favoriteList => _favoriteList;



  void setFavoriteList(List<PlanModel> list) {
    _favoriteList = list;
  }
}