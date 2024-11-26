class PlanModel {
  int? id;
  String? nation;
  List<DateTime?>? schedule;

  PlanModel({this.id, this.nation, this.schedule});

  factory PlanModel.fromJson(Map<String, dynamic>json){
    return PlanModel(
      id: json['id']??"",
      nation: json['nation']??"",
      schedule: (json['schedule'] as List).map((date) => DateTime.parse(date)).toList()
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nation':nation,
      'schedule':schedule?.map((e) => e?.toIso8601String()).toList()
    };
  }
}