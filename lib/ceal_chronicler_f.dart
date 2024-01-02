import 'package:flutter/material.dart';

import 'main_body.dart';

class CealChroniclerF extends StatelessWidget{

  static const title = "Ceal Chronicler f";
  const CealChroniclerF({super.key});

  @override
  Widget build(BuildContext context) {
    var themeData = ThemeData(
        primarySwatch: Colors.teal,
      );
    return MaterialApp(
      title: title,
      theme: themeData,
      home: const MainBody(),
    );
  }
}