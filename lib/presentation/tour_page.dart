import 'package:flutter/material.dart';

import '../data/models/plan_model/plan_model.dart';

class TourPage extends StatelessWidget {
  final PlanModel plan;
  const TourPage({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("관광 일정"),
      ),
      body: Container(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
