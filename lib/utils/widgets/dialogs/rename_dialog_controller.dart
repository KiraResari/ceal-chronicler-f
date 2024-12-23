import 'package:ceal_chronicler_f/utils/validation/valid_result.dart';
import 'package:flutter/material.dart';

import '../../validation/invalid_result.dart';
import '../../validation/validation_result.dart';

class RenameDialogController extends ChangeNotifier {
  final TextEditingController textEditingController;
  final String originalName;

  RenameDialogController(this.originalName)
      : textEditingController = TextEditingController(text: originalName) {
    textEditingController.addListener(_notifyListenersCall);
  }

  void _notifyListenersCall() => notifyListeners();

  ValidationResult validateNewName(String newName) {
    if (newName == originalName) {
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
