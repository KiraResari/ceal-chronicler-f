import '../../commands/command.dart';
import '../../get_it_context.dart';
import '../point_in_time.dart';
import '../point_in_time_repository.dart';

class RenamePointInTimeCommand extends Command {
  final _pointInTimeRepository = getIt.get<PointInTimeRepository>();
  PointInTime point;
  String newName;
  String? oldName;

  RenamePointInTimeCommand(this.point, this.newName);

  @override
  void execute() {
    oldName = point.name;
    _pointInTimeRepository.rename(point, newName);
  }

  @override
  void undo() {
    if (oldName != null) {
      _pointInTimeRepository.rename(point, oldName!);
    }
  }
}
