import 'package:ceal_chronicler_f/utils/list_utils.dart';

import '../../commands/command.dart';
import '../../timeline/model/point_in_time.dart';
import '../model/incident.dart';

class ShiftIncidentUpCommand extends Command {
  final Incident _incident;
  final PointInTime _point;

  ShiftIncidentUpCommand(this._incident, this._point);

  @override
  void execute() {
    ListUtils.moveElementTowardsFrontOfList(
      _point.incidentReferences,
      _incident.id,
    );
  }

  @override
  String get executeMessage => "Moved incident ${_incident.name} up";

  @override
  void undo() {
    ListUtils.moveElementTowardsEndOfList(
      _point.incidentReferences,
      _incident.id,
    );
  }

  @override
  String get undoMessage => "Moved incident ${_incident.name} back down";
}
