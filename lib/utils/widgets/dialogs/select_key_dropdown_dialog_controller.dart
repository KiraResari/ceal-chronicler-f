import 'package:flutter/material.dart';

import '../../validation/invalid_result.dart';
import '../../validation/valid_result.dart';
import '../../validation/validation_result.dart';

class SelectKeyDropdownDialogController<T> extends ChangeNotifier {
  final T? initialSelection;
  T? currentSelection;

  SelectKeyDropdownDialogController(this.initialSelection)
      : currentSelection = initialSelection;

  ValidationResult get validateSelection => initialSelection == currentSelection
      ? InvalidResult("Value was not changed")
      : ValidResult();

  void onSelected(T? selection) {
    currentSelection = selection;
    notifyListeners();
  }
}
