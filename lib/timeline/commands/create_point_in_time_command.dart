import '../../commands/command.dart';
import '../../get_it_context.dart';
import '../model/point_in_time.dart';
import '../model/point_in_time_repository.dart';

class CreatePointInTimeCommand extends Command {
  final _pointInTimeRepository = getIt.get<PointInTimeRepository>();
  final int _creationIndex;
  PointInTime? _createdPoint;

  CreatePointInTimeCommand(this._creationIndex);

  @override
  String get executeMessage =>
      "Created new Point in Time$_pointNameSuffixOrNothing";

  @override
  String get undoMessage =>
      "Undid creation of Point in Time$_pointNameSuffixOrNothing";

  String get _pointNameSuffixOrNothing {
    if (_createdPoint != null) {
      return " '${_createdPoint!.name}'";
    }
    return "";
  }

  @override
  void execute() {
    if (_createdPoint == null) {
      _createdPoint = _pointInTimeRepository.createNewAtIndex(_creationIndex);
    } else {
      _pointInTimeRepository.addAtIndex(_creationIndex, _createdPoint!);
    }
  }

  @override
  void undo() {
    if (_createdPoint != null) {
      _pointInTimeRepository.remove(_createdPoint!);
    }
  }
}
