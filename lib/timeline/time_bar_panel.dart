import 'package:ceal_chronicler_f/timeline/point_in_time.dart';
import 'package:flutter/material.dart';

class TimeBarPanel extends StatelessWidget {
  final PointInTime pointInTime;

  const TimeBarPanel({super.key, required this.pointInTime});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.all(10.0),
      child: Text(pointInTime.name, style: const TextStyle(fontSize: 18.0)),
    );
  }
}
