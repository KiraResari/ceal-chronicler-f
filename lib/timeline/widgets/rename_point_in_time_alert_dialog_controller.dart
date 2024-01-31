import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';
import 'package:ceal_chronicler_f/utils/validation/valid_result.dart';
import 'package:flutter/material.dart';

import '../../get_it_context.dart';
import '../../utils/validation/invalid_result.dart';
import '../../utils/validation/validation_result.dart';

class RenamePointInTimeAlertDialogController extends ChangeNotifier {
  final PointInTimeRepository _pointInTimeRepository =
      getIt.get<PointInTimeRepository>();
  final TextEditingController textEditingController;
  final String _originalName;

  RenamePointInTimeAlertDialogController(this._originalName)
      : textEditingController = TextEditingController(text: _originalName) {
    textEditingController.addListener(() {
      notifyListeners();
    });
  }

  ValidationResult validateNewName(String newName) {
    if (newName == _originalName) {
      return InvalidResult("Name is unchanged");
    }
    if (_pointInTimeRepository.existingNames.contains(newName)) {
      return InvalidResult("Name is already taken");
    }
    if (newName.isEmpty) {
      return InvalidResult("Name can't be empty");
    }
    return ValidResult();
  }
}
