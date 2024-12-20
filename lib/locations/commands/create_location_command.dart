import 'package:ceal_chronicler_f/key_fields/key_field_resolver.dart';
import 'package:ceal_chronicler_f/locations/model/location_repository.dart';

import '../../commands/command.dart';
import '../../get_it_context.dart';
import '../../timeline/model/point_in_time_id.dart';
import '../../view/templates/location_view_template.dart';
import '../../view/templates/main_view_template.dart';
import '../../view/templates/overview_view_template.dart';
import '../../view/view_repository.dart';
import '../model/location.dart';

class CreateLocationCommand extends Command {
  final _locationRepository = getIt.get<LocationRepository>();
  final _viewRepository = getIt.get<ViewRepository>();
  final _keyFieldResolver = getIt.get<KeyFieldResolver>();
  final PointInTimeId _pointId;
  Location? _createdLocation;

  CreateLocationCommand(this._pointId);

  @override
  void execute() {
    _createdLocation ??= Location(_pointId);
    _locationRepository.add(_createdLocation!);
  }

  @override
  String get executeMessage => "Created new Location";

  @override
  void undo() {
    if (_createdLocation != null) {
      _locationRepository.remove(_createdLocation!);
      _returnToOverviewViewIfLocationViewWasOpen();
    }
  }

  void _returnToOverviewViewIfLocationViewWasOpen() {
    MainViewTemplate mainViewTemplate = _viewRepository.mainViewTemplate;
    if (mainViewTemplate is LocationViewTemplate &&
        mainViewTemplate.entity == _createdLocation!) {
      _viewRepository.mainViewTemplate = OverviewViewTemplate();
    }
  }

  @override
  String get undoMessage =>
      "Undid creation of Location $_locationNameOrNothing";

  String get _locationNameOrNothing {
    if (_createdLocation != null) {
      String? name = _keyFieldResolver.getCurrentValue(_createdLocation!.name);
      return name != null ? "'$name'" : "";
    }
    return "";
  }
}
