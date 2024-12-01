import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:ready_go_project/bloc/data_bloc.dart';
import 'package:ready_go_project/presentation/add_plan_page.dart';
import 'package:ready_go_project/presentation/plan_page.dart';
import 'package:ready_go_project/util/date_util.dart';

import '../data/models/plan_model/plan_model.dart';
import '../provider/plan_list_provider.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DataBloc(),
      child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.white,
            ),
            inputDecorationTheme: const InputDecorationTheme(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black87, // 원하는 색상
                  width: 1.0,
                ), 
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black87, // 원하는 색상
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
            ),
            textSelectionTheme: const TextSelectionThemeData(cursorColor: Colors.black87),
            fontFamily: 'Nanum',
            appBarTheme: const AppBarTheme(
              titleTextStyle: TextStyle(color: Colors.black, fontSize: 18, fontFamily: 'Nanum'),
              backgroundColor: Colors.white,
              elevation: 0.5,
              iconTheme: IconThemeData(color: Colors.black87),
            ),
          ),
          darkTheme: ThemeData.dark(),
          themeMode: MediaQuery.of(context).platformBrightness == Brightness.light ? ThemeMode.light : ThemeMode.dark,
          home: const MainPage2()),
    );
  }
}

class MainPage2 extends StatefulWidget {
  const MainPage2({super.key});

  @override
  State<MainPage2> createState() => _MainPage2State();
}

class _MainPage2State extends State<MainPage2> {
  @override
  Widget build(BuildContext context) {
    final list = context.watch<PlanListProvider>().planList;

    return BlocBuilder<DataBloc, DataState>(builder: (context, state) {
      if (state.state == DataStatus.beforePlanList) {
        context.read<PlanListProvider>().getPlanList();
        context.read<DataBloc>().add(DataLoadingPlanListEvent());
      }

      if (kDebugMode) {
        print("$list");
      }
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {},
              icon: Image.asset(
                  MediaQuery.of(context).platformBrightness == Brightness.dark ? 'assets/images/logo_white.png' : 'assets/images/logo.png')),
          leadingWidth: 120,
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
            const SizedBox(
              width: 10,
            )
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.all(20),
            child: list.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("생성된 여행이 없습니다."),
                      ],
                    ),
                  )
                : _planListSection(context, list)),
        floatingActionButton: FloatingActionButton(
          // backgroundColor: Colors.black87,
          child: const Icon(
            Icons.add,
            // color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddPlanPage()),
            );
          },
        ),
      );
    });
  }

  Widget _planListSection(BuildContext context, List<PlanModel> list) {
    return ListView.separated(
        primary: false,
        itemBuilder: (context, idx) {
          return InkWell(
            onTap: () {
              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const PlanPage(), settings: RouteSettings(arguments: list[idx])));
              Get.to(() => PlanPage(plan: list[idx]));
            },
            child: Slidable(
              endActionPane: ActionPane(extentRatio: 0.2, motion: const ScrollMotion(), children: [
                SlidableAction(
                    icon: Icons.delete,
                    label: "삭제",
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.redAccent,
                    onPressed: (context) {
                      context.read<PlanListProvider>().removePlanList(list[idx].id ?? -1);
                    })
              ]),
              child: Container(
                width: 600,
                height: 100,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    border: Border.all(color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black87),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        child: Text(
                      "${list[idx].nation}",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    )),
                    SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              "${DateUtil.dateToString(list[idx].schedule?.first ?? DateTime.now())} ~ ${DateUtil.dateToString(list[idx].schedule?.last ?? DateTime.now())}"),
                          const Gap(10),
                          list[idx].schedule!.last!.isAfter(DateTime.now()) ? const Text("(준비중)") : const Text("(완료)")
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, idx) => const Gap(10),
        itemCount: list.length);
  }
}
