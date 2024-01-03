import 'package:ceal_chronicler_f/timeline/point_in_time.dart';
import 'package:ceal_chronicler_f/timeline/time_bar_controller.dart';
import 'package:ceal_chronicler_f/timeline/time_bar_panel.dart';
import 'package:flutter/material.dart';
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
          children:
              points.map((point) => TimeBarPanel(pointInTime: point)).toList(),
        ),
      ),
    );
  }
}
