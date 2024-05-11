import 'package:ceal_chronicler_f/view/templates/overview_view_template.dart';
import 'package:ceal_chronicler_f/view/templates/main_view_template.dart';
import 'package:flutter/material.dart';

import '../main_view/main_view_candidate.dart';

class ViewRepository extends ChangeNotifier {
  MainViewTemplate _mainViewTemplate = OverviewViewTemplate();

  MainViewCandidate get mainView => _mainViewTemplate.associatedView;

  set activeViewTemplate(MainViewTemplate value) {
    _mainViewTemplate = value;
    notifyListeners();
  }
}
