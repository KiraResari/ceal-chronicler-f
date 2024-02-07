import 'package:ceal_chronicler_f/utils/validation/valid_result.dart';
import 'package:flutter/material.dart';

import '../../utils/validation/invalid_result.dart';
import '../../utils/validation/validation_result.dart';

class RenameDialogController extends ChangeNotifier {
  final TextEditingController textEditingController;
  final String _originalName;

  RenameDialogController(this._originalName)
      : textEditingController = TextEditingController(text: _originalName) {
    textEditingController.addListener(_notifyListenersCall);
  }

  void _notifyListenersCall() => notifyListeners();

  ValidationResult validateNewName(String newName) {
    if (newName == _originalName) {
      return InvalidResult("Name is unchanged");
    }
    if (newName.isEmpty) {
      return InvalidResult("Name can't be empty");
    }
    return ValidResult();
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.removeListener(_notifyListenersCall);
  }
}
