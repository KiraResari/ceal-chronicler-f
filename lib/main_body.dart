import 'package:ceal_chronicler_f/timeBar/time_bar.dart';
import 'package:flutter/material.dart';

import 'main_view.dart';
import 'menuBar/chronicler_menu_bar.dart';

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
            ChroniclerMenuBar(),
            TimeBar(),
            MainView(),
          ],
        ),
      ),
      backgroundColor: theme.colorScheme.inversePrimary,
    );
  }
}