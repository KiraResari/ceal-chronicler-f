import 'package:flutter/material.dart';

import '../../../get_it_context.dart';
import '../../../key_fields/key_field_resolver.dart';
import '../../validation/invalid_result.dart';
import '../../validation/valid_result.dart';
import '../../validation/validation_result.dart';

class SelectKeyDropdownDialogController<T> extends ChangeNotifier {
  static final resolver = getIt.get<KeyFieldResolver>();

  final T? initialSelection;
  T? currentSelection;

  SelectKeyDropdownDialogController(this.initialSelection)
      : currentSelection = initialSelection;

  ValidationResult get validateSelection =>
      initialSelection == currentSelection
          ? InvalidResult("Value was not changed")
          : ValidResult();

  void onSelected(T? selection) {
    currentSelection = selection;
    notifyListeners();
  }
}
