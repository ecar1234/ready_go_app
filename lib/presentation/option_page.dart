import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ready_go_project/domain/entities/provider/purchase_manager.dart';
import 'package:ready_go_project/util/localizations_util.dart';
import 'package:ready_go_project/util/nation_currency_unit_util.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


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
    final isDarkMode = context.watch<ThemeModeProvider>().isDarkMode;
    final isKor = Localizations.localeOf(context).languageCode == "ko";
    final localization = AppLocalizations.of(context)!;
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
                      SizedBox(
                        width: 100,
                        child: Text(
                          localization.darkMode,
                          style: LocalizationsUtil.setTextStyle(isKor, size: 18, fontWeight: FontWeight.w600),
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
                      SizedBox(
                        child: Text(
                          localization.restorePurchases,
                          style: LocalizationsUtil.setTextStyle(isKor, size: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        width: isKor ? 80 : 100,
                        child: ElevatedButton(
                            onPressed: () async{
                              context.read<PurchaseManager>().loadPastPurchases();
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text(
                                          localization.restoreResultTitle,
                                          style: LocalizationsUtil.setTextStyle(isKor, size: 20, fontWeight: FontWeight.w600),
                                        ),
                                        content: Text(
                                          localization.restoreResultDetail,
                                          style: LocalizationsUtil.setTextStyle(isKor, size: 16),
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
                                                  localization.close,
                                                  style: TextStyle(color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary),
                                                )),
                                          )
                                        ],
                                      ));
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white),
                            child: Text(localization.restore,
                                style: LocalizationsUtil.setTextStyle(isKor, color: isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary))),
                      )
                    ],
                  ),
                ),
              ],
            ),
            FutureBuilder(
              future: PackageInfo.fromPlatform(),
              builder:(context, info) {
                String? versionNum = info.data != null ? info.data!.buildNumber : "";
                String? buildNum = info.data != null ? info.data!.version : "";
                return Column(
                children: [
                 SizedBox(
                    child: Text(localization.version),
                  ),
                  SizedBox(
                    child: Text("v.$buildNum", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
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
