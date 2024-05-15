import 'package:ceal_chronicler_f/get_it_context.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_id.dart';
import 'package:ceal_chronicler_f/timeline/model/point_in_time_repository.dart';
import 'package:ceal_chronicler_f/view/commands/view_command.dart';

class ActivatePointInTimeCommand extends ViewCommand {
  final PointInTimeRepository repository = getIt.get<PointInTimeRepository>();
  final PointInTimeId id;

  ActivatePointInTimeCommand(this.id);

  @override
  void execute() => repository.activatePointInTime(id);

  @override
  bool get isValid => repository.contains(id);
}
