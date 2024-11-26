import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:ready_go_project/bloc/data_bloc.dart';
import 'package:ready_go_project/data/models/plan_model.dart';

import 'package:ready_go_project/domain/entities/Roaming_provider.dart';
import 'package:ready_go_project/domain/entities/accommodation_provider.dart';
import 'package:ready_go_project/domain/entities/account_provider.dart';
import 'package:ready_go_project/domain/entities/images_provider.dart';
import 'package:ready_go_project/domain/entities/supplies_provider.dart';
import 'package:ready_go_project/domain/entities/account_provider.dart';
import 'package:ready_go_project/presentation/accommodation_page.dart';

import 'package:ready_go_project/presentation/account_book_page.dart';
import 'package:ready_go_project/presentation/air_ticket_page.dart';
import 'package:ready_go_project/presentation/roaming_page.dart';
import 'package:ready_go_project/presentation/supplies_page.dart';


import '../util/date_util.dart';

class PlanPage extends StatefulWidget {
  final PlanModel plan;
  const PlanPage({super.key, required this.plan});

  @override
  State<PlanPage> createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {
  List<String> itemList = ["항공권", "준비물", "로밍 & ESIM", "여행 경비", "숙소", "일정"];

  @override
  Widget build(BuildContext context) {
    // PlanModel plan = ModalRoute.of(context)!.settings.arguments as PlanModel;
    DataState state = context.watch<DataBloc>().state;
    if (state.state == DataStatus.loadedPlanList) {
      context.read<ImagesProvider>().getImgList(widget.plan.id!);
      context.read<SuppliesProvider>().getList(widget.plan.id!);
      context.read<RoamingProvider>().getRoamingDate(widget.plan.id!);
      context.read<AccountProvider>().getAccountInfo(widget.plan.id!);
      context.read<AccommodationProvider>().getAccommodationList(widget.plan.id!);

      // context.read<ImagesProvider>().getImgList(widget.plan.id!);
      context.read<DataBloc>().add(DataLoadingPlanEvent());
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("여행준비"),
      ),
      body: Container(
        width: Get.width,
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.plan.nation}",
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
                const Gap(5),
                Text(
                  "${DateUtil.dateToString(widget.plan.schedule?.first ?? DateTime.now())} ~ ${DateUtil.dateToString(widget.plan.schedule?.last ?? DateTime.now())}",
                  style: const TextStyle(wordSpacing: 15),
                ),
                const Gap(5),
                const Divider()
              ],
            ),
            const Gap(20),
            Expanded(
              child: ListView.separated(
                  primary: false,
                  itemBuilder: (context, idx) {
                    return SizedBox(
                      width: Get.width,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          switch (itemList[idx]) {
                            case "항공권":
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AirTicketPage(planId: widget.plan.id!)));
                            case "준비물":
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SuppliesPage(planId: widget.plan.id!)));
                            case "로밍 & ESIM":
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => RoamingPage(planId: widget.plan.id!)));
                            case "여행 경비":
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AccountBookPage(plan: widget.plan)));
                            case "숙소":
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) => AccommodationPage(plan: widget.plan!)));
                            case "일정":
                            // Navigator.of(context)
                            //     .push(MaterialPageRoute(builder: (context) => const AirTicketPage()));
                            default:
                              print("page route failed");
                          }
                        },
                        style: ElevatedButton.styleFrom(side: const BorderSide(color: Colors.grey)),
                        child: Text(
                          itemList[idx],
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, idx) => const Gap(20),
                  itemCount: itemList.length),
            )
          ],
        ),
      ),
    );
  }
}
