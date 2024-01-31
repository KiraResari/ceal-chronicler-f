import 'package:ceal_chronicler_f/timeline/model/point_in_time.dart';

import '../../commands/command.dart';
import '../../get_it_context.dart';
import '../model/incident.dart';
import '../model/incident_repository.dart';

class CreateIncidentCommand extends Command {
  final _repository = getIt.get<IncidentRepository>();
  final PointInTime _point;
  Incident? _createdIncident;

  CreateIncidentCommand(this._point);

  @override
  void execute() {
    _createdIncident ??= Incident();
    _repository.add(_createdIncident!);
    _point.addIncidentReference(_createdIncident!.id);
  }

  @override
  String get executeMessage =>
      "Created new Incident$_incidentNameSuffixOrNothing";

  @override
  void undo() {
    if (_createdIncident != null) {
      _repository.remove(_createdIncident!);
      _point.removeIncidentReference(_createdIncident!.id);
    }
  }

  @override
  String get undoMessage =>
      "Undid creation of Incident$_incidentNameSuffixOrNothing";

  String get _incidentNameSuffixOrNothing {
    if (_createdIncident != null) {
      return " '${_createdIncident!.name}'";
    }
    return "";
  }
}
