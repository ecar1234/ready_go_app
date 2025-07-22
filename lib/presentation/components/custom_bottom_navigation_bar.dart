import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:ready_go_project/domain/entities/provider/theme_mode_provider.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final List<Map<String, IconData>> items;
  final Function(int) onTap;

  const CustomBottomNavigationBar({super.key, required this.items, required this.onTap});

  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIdx = 0;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeModeProvider>().isDarkMode;
    return Container(
      height: 50,
      width: widget.items.length * 70,
      decoration: BoxDecoration(
        color: isDarkMode ? Theme.of(context).colorScheme.primary : Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: isDarkMode ? null : [
          const BoxShadow(
            offset: Offset(0, 5),
            color: Colors.black26,
            blurRadius: 5.0,
            blurStyle: BlurStyle.outer,
            spreadRadius: 0,
          )
        ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
              itemBuilder: (context, idx){
                List<String> title = widget.items[idx].keys.toList();
                List<IconData> icon = widget.items[idx].values.toList() ;
            return GestureDetector(
              onTap: (){
                setState(() {
                  _selectedIdx = idx;
                });
                widget.onTap(idx);
              },
              child: SizedBox(
                width: 40,
                height: 40,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon.first, color: _selectedIdx == idx
                        ? (isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary)
                        : Colors.grey,),
                    // Text(title.first ,style: TextStyle(
                    // color: _selectedIdx == idx
                    //     ? (isDarkMode ? Colors.white : Theme.of(context).colorScheme.primary)
                    //     : Colors.grey, // 선택된 아이템과 선택되지 않은 아이템의 텍스트 색상 구분
                    // ),)
                  ],
                ),
              ),
            );
          },
              separatorBuilder: (context, idx){return const Gap(10);}, itemCount: widget.items.length),
        ],
      )
    );
  }
}
