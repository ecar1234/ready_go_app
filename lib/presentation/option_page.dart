import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ready_go_project/domain/entities/provider/purchase_manager.dart';

import '../domain/entities/provider/theme_mode_provider.dart';

class OptionPage extends StatefulWidget {
  const OptionPage({super.key});

  @override
  State<OptionPage> createState() => _OptionPageState();
}

class _OptionPageState extends State<OptionPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = context.watch<ThemeModeProvider>().isDarkMode;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Setting"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 100,
                        child: Text(
                          "Dark 모드",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        width: 80,
                        child: Center(
                          child: Switch(
                            activeColor: Theme.of(context).colorScheme.primary,
                            activeTrackColor: Colors.white,
                            thumbColor: WidgetStateProperty.resolveWith<Color?>(
                                  (Set<WidgetState> states) {
                                if (states.contains(WidgetState.selected)) {
                                  return Theme.of(context).colorScheme.primary; // Color when the switch is ON
                                }
                                return Colors.grey; // Default color when the switch is OFF
                              },
                            ),
                            trackOutlineColor: WidgetStateProperty.resolveWith<Color?>(
                                  (Set<WidgetState> states) {
                                if (states.contains(WidgetState.selected)) {
                                  return Colors.transparent; // Color when the switch is ON
                                }
                                return Colors.grey[300]; // Default color when the switch is OFF
                              },
                            ),
                            value: isDarkMode,
                            onChanged: (bool isDark) {
                              context.read<ThemeModeProvider>().changedThemeMode(isDark);
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        child: Text(
                          "구매 복원 하기",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        width: 80,
                        child: ElevatedButton(
                            onPressed: () async{
                              context.read<PurchaseManager>().loadPastPurchases();
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: const Text(
                                          "구매 복원 완료",
                                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                                        ),
                                        content: const Text(
                                          "구매 복원이 완료 되었습니다.",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        actions: [
                                          SizedBox(
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white),
                                                child: Text(
                                                  "닫기",
                                                  style: TextStyle(color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary),
                                                )),
                                          )
                                        ],
                                      ));
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white),
                            child: Text("복원", style: TextStyle(color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary))),
                      )
                    ],
                  ),
                ),
              ],
            ),
            FutureBuilder(
              future: PackageInfo.fromPlatform(),
              builder:(context, info) {
                int? versionNum = int.tryParse(info.data!.buildNumber);

                return Column(
                children: [
                 const SizedBox(
                    child: Text("버전 정보"),
                  ),
                  SizedBox(
                    child: Text("v.0.9.$versionNum", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                  )
                ],
              );}
            )
          ],
        ),
      ),
    );
  }
}
