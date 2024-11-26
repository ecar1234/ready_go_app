import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:ready_go_project/domain/entities/supplies_provider.dart';

class SuppliesPage extends StatefulWidget {
  final int planId;

  const SuppliesPage({super.key, required this.planId});

  @override
  State<SuppliesPage> createState() => _SuppliesPageState();
}

class _SuppliesPageState extends State<SuppliesPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final list = context.watch<SuppliesProvider>().suppliesList;
    return Scaffold(
      appBar: AppBar(
        title: const Text("준비물"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: list.isEmpty
            ? const Center(
                child: Text("목록을 추가해 주세요"),
              )
            : ListView.separated(
                itemBuilder: (context, idx) {
                  return SizedBox(
                    height: 40,
                    child: TextButton(
                        onPressed: () {
                          context.read<SuppliesProvider>().updateItemState(list[idx], widget.planId);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${idx + 1}. ${list[idx].keys.first}",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: list[idx].values.first
                                      ? Colors.grey
                                      : (MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black87),
                                  decoration: list[idx].values.first ? TextDecoration.lineThrough : TextDecoration.none),
                            ),
                            PopupMenuButton(
                              iconColor: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black87,
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                    value: "edit",
                                    child: Text(
                                      "수정",
                                      style: TextStyle(
                                          color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black87),
                                    )),
                                PopupMenuItem(
                                    value: "delete",
                                    child: Text(
                                      "삭제",
                                      style: TextStyle(
                                          color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black87),
                                    )),
                              ],
                              onSelected: (value) {
                                switch (value) {
                                  case "edit":
                                    _controller.text = list[idx].keys.first;
                                    _itemEditDialog(context, idx);
                                  case "delete":
                                    context.read<SuppliesProvider>().removeItem(list[idx], widget.planId);
                                }
                              },
                            )
                          ],
                        )),
                  );
                },
                separatorBuilder: (context, idx) => const Gap(5),
                itemCount: list.length),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black87,
        onPressed: () {
          _itemAddDialog(context);
        },
        child: const Center(
          child: Icon(
            Icons.edit_document,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Future<void> _itemAddDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Container(
                width: 600,
                height: 200,
                child: Column(
                  children: [
                    Stack(children: [
                      const SizedBox(
                        width: 600,
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "목록 추가",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                      Positioned(
                          right: 5,
                          top: 5,
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(Icons.close),
                            ),
                          ))
                    ]),
                    const Divider(),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SizedBox(
                        height: 30,
                        child: TextField(
                          controller: _controller,
                          style: const TextStyle(fontSize: 12),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderSide: const BorderSide(), borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(borderSide: const BorderSide(), borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                    )),
                    SizedBox(
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: 40,
                              width: 100,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_controller.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("항목을 입력해 주세요")));
                                  } else {
                                    Map<String, bool> item = {_controller.text: false};
                                    context.read<SuppliesProvider>().addItem(item, widget.planId);
                                    _controller.text = "";
                                    Navigator.of(context).pop();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black87,
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                child: const Text(
                                  "추가하기",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ));
  }

  Future<void> _itemEditDialog(BuildContext context, int idx) {
    return showDialog(
        context: context,
        builder: (context) => Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Container(
                width: 600,
                height: 200,
                child: Column(
                  children: [
                    Stack(children: [
                      const SizedBox(
                        width: 600,
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "목록 추가",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                      Positioned(
                          right: 5,
                          top: 5,
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(Icons.close),
                            ),
                          ))
                    ]),
                    const Divider(),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SizedBox(
                        height: 30,
                        child: TextField(
                          controller: _controller,
                          style: const TextStyle(fontSize: 12),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderSide: const BorderSide(), borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(borderSide: const BorderSide(), borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                    )),
                    SizedBox(
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: 40,
                              width: 100,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_controller.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("항목을 입력해 주세요")));
                                  } else {
                                    Map<String, bool> item = {_controller.text: false};
                                    context.read<SuppliesProvider>().editItem(idx, item, widget.planId);
                                    _controller.text = "";
                                    Navigator.of(context).pop();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black87,
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                child: const Text(
                                  "수정하기",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ));
  }
}
