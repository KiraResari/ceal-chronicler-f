import 'package:ceal_chronicler_f/toolBar/load_button.dart';
import 'package:ceal_chronicler_f/toolBar/save_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'redo_button.dart';
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
        SaveButton(),
        LoadButton(),
        Spacer(),
        UndoButton(),
        RedoButton(),
        Spacer(flex: 20),
      ],
    );
  }
}
