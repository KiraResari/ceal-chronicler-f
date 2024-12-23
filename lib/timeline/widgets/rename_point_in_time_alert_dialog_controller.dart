import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';

import '../../get_it_context.dart';
import '../../utils/validation/invalid_result.dart';
import '../../utils/validation/validation_result.dart';
import '../../utils/widgets/dialogs/rename_dialog_controller.dart';

class RenamePointInTimeAlertDialogController extends RenameDialogController {
  final PointInTimeRepository _pointInTimeRepository =
      getIt.get<PointInTimeRepository>();

  RenamePointInTimeAlertDialogController(super.originalName);

  @override
  ValidationResult validateNewName(String newName) {
    if (newName == originalName) {
      return InvalidResult("Name is unchanged");
    }
    if (_pointInTimeRepository.existingNames.contains(newName)) {
      return InvalidResult("Name is already taken");
    }
    return super.validateNewName(newName);
  }
}
