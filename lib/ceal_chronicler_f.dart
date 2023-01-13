import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'main_view.dart';

class CealChroniclerF extends StatelessWidget{
  const CealChroniclerF({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        title: "Ceal Chronicler f",
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: const MainView(),
      ),
    );
  }
}