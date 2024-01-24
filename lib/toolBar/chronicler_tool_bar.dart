import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'tool_bar_controller.dart';
import 'undo_button.dart';

class ChroniclerToolBar extends StatelessWidget {
  const ChroniclerToolBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ToolBarController(),
      builder: (context, child) => _buildToolBar(),
    );
  }

  Widget _buildToolBar() {
    return const Row(
      children: [
        UndoButton(),
      ],
    );
  }
}
