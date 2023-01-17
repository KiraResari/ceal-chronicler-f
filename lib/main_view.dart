import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: SizedBox.expand(
        child: Material(child: appState.activeView),
      ),
    );
  }
}
