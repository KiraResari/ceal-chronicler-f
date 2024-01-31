import 'package:ceal_chronicler_f/message_bar/message_bar.dart';
import 'package:ceal_chronicler_f/timeline/widgets/time_bar.dart';
import 'package:flutter/material.dart';

import 'main_view.dart';
import 'toolBar/chronicler_tool_bar.dart';

class MainBody extends StatelessWidget{
  const MainBody({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: const SizedBox.expand(
        child: Column(
          children: [
            MessageBar(),
            ChroniclerToolBar(),
            TimeBar(),
            MainView(),
          ],
        ),
      ),
      backgroundColor: theme.colorScheme.inversePrimary,
    );
  }
}