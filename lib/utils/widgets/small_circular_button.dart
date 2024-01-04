import 'package:flutter/material.dart';

abstract class SmallCircularButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;

  const SmallCircularButton(
      {super.key, required this.tooltip, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 24,
        width: 24,
        child: FloatingActionButton(
          tooltip: tooltip,
          onPressed: () => onPressed(context),
          child: Icon(icon),
        ),
      ),
    );
  }

  void onPressed(BuildContext context);
}
