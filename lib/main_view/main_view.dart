import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main_view_controller.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MainViewController(),
      builder: (context, child) =>
      context.watch<MainViewController>().activeView,
    );
  }
}
