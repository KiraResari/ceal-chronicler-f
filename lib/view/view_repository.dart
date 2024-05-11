import 'package:ceal_chronicler_f/view/templates/overview_view_template.dart';
import 'package:ceal_chronicler_f/view/templates/view_template.dart';
import 'package:flutter/material.dart';

class ViewRepository extends ChangeNotifier {
  ViewTemplate _activeViewTemplate = OverviewViewTemplate();

  Widget get activeView => _activeViewTemplate.associatedView;

  set activeViewTemplate(ViewTemplate value) {
    _activeViewTemplate = value;
    notifyListeners();
  }
}
