import 'dart:io';

import 'package:ceal_chronicler_f/utils/widgets/title_medium.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class Overview<T, C extends ChangeNotifier> extends StatelessWidget {
  const Overview({super.key});

  Color get backgroundColor;

  String get title;

  List<T> getItems(C controller);

  Widget buildItem(T item);

  Widget buildAddButton();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => createController(),
      builder: (context, child) => _buildContent(context),
    );
  }

  C createController();

  Widget _buildContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: backgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TitleMedium(title: title),
            _buildScrollList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildScrollList(BuildContext context) {
    int scrollListHeightOffset =
        Platform.isAndroid || Platform.isIOS ? 275 : 225;

    return ConstrainedBox(
      constraints: BoxConstraints(
          maxHeight:
              MediaQuery.of(context).size.height - scrollListHeightOffset),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ..._buildPanels(context),
            buildAddButton(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPanels(BuildContext context) {
    var controller = context.watch<C>();
    List<T> items = getItems(controller);
    return items.map((item) => buildItem(item)).toList();
  }
}
