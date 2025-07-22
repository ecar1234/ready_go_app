import 'package:flutter/material.dart';

class CustomAccordionTile extends StatefulWidget {
  final String title;
  final List<Widget> children;

  const CustomAccordionTile({super.key, required this.title, required this.children});

  @override
  State<CustomAccordionTile> createState() => _CustomAccordionTileState();
}

class _CustomAccordionTileState extends State<CustomAccordionTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(widget.title),
          trailing: Icon(_isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up),
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
        ),
        AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(5),
            color: const Color(0xffe1e1e1),
            height: _isExpanded ? (widget.children.length * 50)+20 : 0,
            child: SingleChildScrollView(
              child: Column(
                children: widget.children,
              ),
            ))
      ],
    );
  }
}
