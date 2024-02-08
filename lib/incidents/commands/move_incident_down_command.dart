import 'package:ceal_chronicler_f/utils/list_utils.dart';

import '../../commands/command.dart';
import '../../timeline/model/point_in_time.dart';
import '../model/incident.dart';

class MoveIncidentDownCommand extends Command {
  final Incident _incident;
  final PointInTime _point;

  MoveIncidentDownCommand(this._incident, this._point);

  @override
  void execute() {
    ListUtils.moveElementTowardsEndOfList(_point.incidentReferences, _incident.id);
  }

  @override
  String get executeMessage => "Moved incident ${_incident.name} down";

  @override
  void undo() {
    ListUtils.moveElementTowardsFrontOfList(_point.incidentReferences, _incident.id);
  }

  @override
  String get undoMessage => "Moved incident ${_incident.name} back up";
}
