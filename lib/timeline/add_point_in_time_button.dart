import 'package:ceal_chronicler_f/timeline/time_bar_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddPointInTimeButton extends StatelessWidget {
  final int insertionIndex;

  const AddPointInTimeButton({super.key, required this.insertionIndex});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () => _addPointInTime(context),
    );
  }

  void _addPointInTime(BuildContext context) {
    TimeBarController controller = context.read<TimeBarController>();
    controller.addPointInTimeAtIndex(insertionIndex);
  }
}
