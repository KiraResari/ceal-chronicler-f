import 'package:ceal_chronicler_f/timeline/time_bar_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddPointInTimeButton extends StatelessWidget {
  final int insertionIndex;

  const AddPointInTimeButton({super.key, required this.insertionIndex});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 24,
        width: 24,
        child: FloatingActionButton(
          tooltip: "Add new point in time",
          onPressed: () => _addPointInTime(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _addPointInTime(BuildContext context) {
    TimeBarController controller = context.read<TimeBarController>();
    controller.addPointInTimeAtIndex(insertionIndex);
  }
}
