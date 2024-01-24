import '../../commands/command.dart';
import '../../get_it_context.dart';
import '../point_in_time.dart';
import '../point_in_time_repository.dart';

class CreatePointInTimeCommand extends Command {
  final _pointInTimeRepository = getIt.get<PointInTimeRepository>();
  final int creationIndex;
  PointInTime? _createdPoint;

  CreatePointInTimeCommand(this.creationIndex);

  @override
  void execute() {
    _createdPoint = _pointInTimeRepository.createNewAtIndex(creationIndex);
  }

  @override
  void undo() {
    if (_createdPoint != null) {
      _pointInTimeRepository.remove(_createdPoint!);
    }
  }
}
