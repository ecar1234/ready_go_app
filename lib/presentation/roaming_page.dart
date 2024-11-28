import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';

import '../provider/Roaming_provider.dart';


class RoamingPage extends StatefulWidget {
  final int planId;

  const RoamingPage({super.key, required this.planId});

  @override
  State<RoamingPage> createState() => _RoamingPageState();
}

class _RoamingPageState extends State<RoamingPage> {
  ImagePicker picker = ImagePicker();
  TextEditingController dpAddressController = TextEditingController();
  TextEditingController activeCodeController = TextEditingController();

  int? selectedValue;

  @override
  Widget build(BuildContext context) {
    final List<XFile> list = context.watch<RoamingProvider>().imageList;
    final Map<String, bool> code = context.watch<RoamingProvider>().code;
    final Map<String, bool> address = context.watch<RoamingProvider>().dpAddress;
    final Map<String, dynamic> period = context.watch<RoamingProvider>().period;

    if (address.isNotEmpty) {
      dpAddressController.text = address.keys.first;
    }
    if (code.isNotEmpty) {
      activeCodeController.text = code.keys.first;
    }

    DateTime startDate = period["startDate"] as DateTime;
    DateTime endDate = period["endDate"] as DateTime;
    DateTime now = DateTime.now();
    // Duration currentDuration = now.difference(startDate);
    Duration useDuration = now.difference(startDate);
    Duration remainDuration = endDate.difference(now);
    Duration totalDuration = endDate.difference(startDate);

    if (context.watch<RoamingProvider>().isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator())); // 로딩 상태 표시
    }

    if (kDebugMode) {
      print("address loaded: $address");
      print("code loaded: $code");
      print("period loaded: $period");
      // print("total: $totalValue");
    }
    return GestureDetector(
      onTap: (){
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("로밍 & ESIM"),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _voucherImageSection(context, list),
                const Gap(10),
                const Divider(),
                _dpAddressSection(context, address),
                _activeCodeSection(context, code),
                const Divider(),
                const Gap(10),
                _periodSection(context, period, startDate, useDuration, remainDuration, totalDuration)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _voucherImageSection(BuildContext context, List<XFile> list) {
    return SizedBox(
      height: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
              height: 30,
              child: Text(
                "바우처 이미지",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              )),
          SizedBox(
            width: list.isEmpty ? 120 : list.length * 130 + 80,
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                list.isEmpty
                    ? SizedBox()
                    : Expanded(
                        child: ListView.separated(
                            itemBuilder: (context, idx) {
                              return Stack(children: [
                                Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                  child: GestureDetector(
                                      onTap: () {
                                        OpenFile.open(list[idx].path);
                                      },
                                      child: Image.file(
                                        File(list[idx].path),
                                        fit: BoxFit.cover,
                                      )),
                                ),
                                Positioned(
                                    right: 0,
                                    top: 0,
                                    child: IconButton(
                                        onPressed: () {
                                          context.read<RoamingProvider>().removeImage(list[idx], widget.planId);
                                        },
                                        icon: const Icon(Icons.close))),
                              ]);
                            },
                            separatorBuilder: (context, idx) {
                              return const Gap(10);
                            },
                            itemCount: list.length)),
                SizedBox(
                  height: 100,
                  width: 100,
                  child: ElevatedButton(
                      onPressed: () async {
                        final imgProvider = context.read<RoamingProvider>();
                        final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          imgProvider.addImage(image, widget.planId);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          side: const BorderSide(color: Colors.white12),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          )),
                      child: const Icon(Icons.add)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dpAddressSection(BuildContext context, Map<String, bool> address) {
    return SizedBox(
      height: 120,
      child: Column(
        children: [
          Column(
            children: [
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "SM-DP주소",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    address.isNotEmpty
                        ? SizedBox(
                            width: 150,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 50,
                                  child: TextButton(
                                    onPressed: () {
                                      if (dpAddressController.text.isEmpty) {
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("SM-DP주소가 비어있습니다.")));
                                        return;
                                      }
                                      Clipboard.setData(ClipboardData(text: dpAddressController.text));
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("SM-DP주소가 복사 되었습니다.")));
                                    },
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                    ),
                                    child: const Text("복사"),
                                  ),
                                ),
                                SizedBox(
                                  width: 50,
                                  child: TextButton(
                                    onPressed: () {
                                      if (dpAddressController.text.isEmpty) {
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("수정 할 SM-DP주소를 입력해 주세요")));
                                        return;
                                      }
                                      if (dpAddressController.text == address.keys.first) {
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("변경 할 내용을 확인해 주세요")));
                                        return;
                                      }
                                      Map<String, bool> addr = {dpAddressController.text: false};
                                      context.read<RoamingProvider>().editAddress(addr, widget.planId);
                                    },
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                    ),
                                    child: const Text("수정"),
                                  ),
                                ),
                                SizedBox(
                                  width: 50,
                                  child: TextButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                content: Text("삭제 하시겠습니까?"),
                                                actions: [
                                                  SizedBox(
                                                    child: ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: Text("취소")),
                                                  ),
                                                  SizedBox(
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        dpAddressController.text = "";
                                                        context.read<RoamingProvider>().removeAddress(widget.planId);
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: Text("삭제"),
                                                    ),
                                                  )
                                                ],
                                              ));
                                    },
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                    ),
                                    child: const Text("삭제"),
                                  ),
                                )
                              ],
                            ),
                          )
                        : SizedBox(
                            width: 100,
                            child: TextButton(
                              onPressed: () {
                                if (dpAddressController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("빈 값은 입력 할 수 없습니다.")));
                                  return;
                                }
                                Map<String, bool> newAddress = {dpAddressController.text: false};
                                context.read<RoamingProvider>().enterAddress(newAddress, widget.planId);
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              child: const Text("입력하기"),
                            ),
                          )
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                child: TextField(
                    controller: dpAddressController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    )),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _activeCodeSection(BuildContext context, Map<String, bool> code) {
    return SizedBox(
      height: 120,
      child: Column(
        children: [
          Column(
            children: [
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "활성화 코드",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    code.isNotEmpty
                        ? SizedBox(
                            width: 150,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 50,
                                  child: TextButton(
                                    onPressed: () {
                                      if (activeCodeController.text.isEmpty) {
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("활성화 코드가 비어있습니다.")));
                                        return;
                                      }
                                      Clipboard.setData(ClipboardData(text: activeCodeController.text));
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("활성화 코드가 복사 되었습니다..")));
                                    },
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                    ),
                                    child: const Text("복사"),
                                  ),
                                ),
                                SizedBox(
                                  width: 50,
                                  child: TextButton(
                                    onPressed: () {
                                      if (activeCodeController.text.isEmpty) {
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("수정 할 활성화 코드를 입력해 주세요")));
                                        return;
                                      }
                                      if (activeCodeController.text == code.keys.first) {
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("변경 할 내용을 확인해 주세요")));
                                        return;
                                      }
                                      Map<String, bool> newCode = {activeCodeController.text: false};
                                      context.read<RoamingProvider>().editCode(newCode, widget.planId);
                                    },
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                    ),
                                    child: const Text("수정"),
                                  ),
                                ),
                                SizedBox(
                                  width: 50,
                                  child: TextButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                content: Text("삭제 하시겠습니까?"),
                                                actions: [
                                                  SizedBox(
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      child: Text("취소"),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    child: ElevatedButton(
                                                        onPressed: () {
                                                          activeCodeController.text = "";
                                                          context.read<RoamingProvider>().removeCode(widget.planId);
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: Text("삭제")),
                                                  )
                                                ],
                                              ));
                                    },
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                    ),
                                    child: const Text("삭제"),
                                  ),
                                )
                              ],
                            ),
                          )
                        : SizedBox(
                            width: 100,
                            child: TextButton(
                              onPressed: () {
                                if (activeCodeController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("빈 값은 입력 할 수 없습니다.")));
                                  return;
                                }
                                Map<String, bool> newCode = {activeCodeController.text: false};
                                context.read<RoamingProvider>().enterCode(newCode, widget.planId);
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              child: const Text("입력하기"),
                            ),
                          )
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                child: TextField(
                    controller: activeCodeController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    )),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _periodSection(
      BuildContext context, Map<String, dynamic> period, DateTime startDate, Duration useDuration, Duration remainDuration, totalDuration) {
    int? selectedValue = period["period"] as int?;
    return SizedBox(
      height: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 80,
            child: Row(
              children: [
                const Text(
                  "사용시간 설정",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
                const Gap(20),
                DropdownMenu(
                  enabled: period["isActive"] == false,
                  initialSelection: selectedValue,
                  hintText: "기간 선택",
                  width: 120,
                  menuHeight: 300,
                  dropdownMenuEntries: List.generate(31, (idx) => DropdownMenuEntry(value: idx + 1, label: "${idx + 1}일")),
                  onSelected: (value) {
                    if (period.containsKey("period") && period["isActive"] == true) {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                content: const SizedBox(
                                  height: 150,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [Text("사용시간을 변경하면 활성화된 데이터가"), Text(" 변경 될 수 있습니다."), Gap(10), Text("변경 하시겠습니까?")],
                                  ),
                                ),
                                actions: [
                                  SizedBox(
                                    width: 120,
                                    height: 40,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          context.read<RoamingProvider>().setPeriodDate(period["period"], widget.planId);
                                          selectedValue = period["period"];
                                        },
                                        child: const Text("취소")),
                                  ),
                                  SizedBox(
                                    width: 120,
                                    height: 40,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          if (value != null) {
                                            context.read<RoamingProvider>().setPeriodDate(value, widget.planId);
                                            Navigator.of(context).pop();
                                          } else {
                                            print("$value");
                                          }
                                        },
                                        child: Text("확인")),
                                  )
                                ],
                              ));
                    } else {
                      if (value != null) {
                        context.read<RoamingProvider>().setPeriodDate(value, widget.planId);
                      }
                    }
                  },
                ),
              ],
            ),
          ),
          const Gap(10),
          Row(
            children: [
              period["isActive"] == true
                  ? SizedBox(
                      width: 80,
                      height: 40,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              backgroundColor: Colors.orangeAccent,
                              side: const BorderSide(color: Colors.grey),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                          onPressed: () {
                            context.read<RoamingProvider>().resetPeriod(widget.planId);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(("데이터가 초기화 되었습니다"))));
                            selectedValue = period["period"];
                          },
                          child: const Text(
                            "초기화",
                            style: TextStyle(color: Colors.black87, fontSize: 16),
                          )),
                    )
                  : SizedBox(
                      width: 80,
                      height: 40,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              backgroundColor: Colors.black87,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                          onPressed: () {
                            if (period["period"] == 0) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("사용기간을 설정 또는 재설정 해주세요")));
                              return;
                            }
                            context.read<RoamingProvider>().startPeriod(widget.planId);
                          },
                          child: const Text(
                            "활성화",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          )),
                    ),
              const Gap(10),
              period["isActive"] == true
                  ? Text(
                      "시작시간: ${startDate.month}월 ${startDate.day}일 ${startDate.hour}시 ${startDate.minute}분",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    )
                  : SizedBox()
            ],
          ),
          const Gap(10),
          period["isActive"] == true
              ? Column(
                  children: [
                    SizedBox(
                      height: 30,
                      child: Row(
                        children: [
                          useDuration.inSeconds < totalDuration.inSeconds
                              ? Text("사용시간(분): ${useDuration.inMinutes}분")
                              : Text("사용시간(분): ${totalDuration.inMinutes}"),
                          const Gap(10),
                          const Text("/"),
                          const Gap(10),
                          useDuration.inSeconds < totalDuration.inSeconds
                              ? Text("잔여시간(분): ${remainDuration.inMinutes}분")
                              : const Text("잔여시간(분): 사용완료")
                        ],
                      ),
                    ),
                    const Gap(10),
                    SizedBox(
                      height: 20,
                      child: LinearProgressIndicator(
                        value: useDuration.inSeconds / totalDuration.inSeconds,
                        // 사용량을 비율로 변환
                        backgroundColor: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
                        minHeight: 10,
                      ),
                    ),
                  ],
                )
              : SizedBox()
        ],
      ),
    );
  }
}
