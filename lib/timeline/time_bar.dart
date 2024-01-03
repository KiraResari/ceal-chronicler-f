import 'package:ceal_chronicler_f/timeline/point_in_time.dart';
import 'package:ceal_chronicler_f/timeline/time_bar_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class TimeBar extends StatelessWidget {
  const TimeBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TimeBarController(),
      builder: (context, child) => _buildTimeBar(context),
    );
  }

  Widget _buildTimeBar(BuildContext context) {
    List<PointInTime> points = context.watch<TimeBarController>().pointsInTime;
    ScrollController controller = ScrollController();

    return Scrollbar(
      controller: controller,
      child: SingleChildScrollView(
        controller: controller,
        scrollDirection: Axis.horizontal,
        child: Row(
          children: points.map((point) => _buildPointCard(point)).toList(),
        ),
      ),
    );
  }

  Widget _buildPointCard(PointInTime point) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: const EdgeInsets.all(10.0),
      child: Text(point.name, style: const TextStyle(fontSize: 18.0)),
    );
  }
}
