import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_id.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';
import 'package:ceal_chronicler_f/view/commands/view_command.dart';
import 'package:ceal_chronicler_f/view/templates/overview_view_template.dart';

import '../view_repository.dart';

class ActivateInitialViewCommand extends ViewCommand {
  final PointInTimeRepository repository = getIt.get<PointInTimeRepository>();
  final ViewRepository viewRepository = getIt.get<ViewRepository>();
  final PointInTimeId id;

  ActivateInitialViewCommand(this.id);

  @override
  void execute() {
    repository.activatePointInTime(id);
    viewRepository.activeViewTemplate = OverviewViewTemplate();
  }

  @override
  bool get isValid => repository.contains(id);
}
