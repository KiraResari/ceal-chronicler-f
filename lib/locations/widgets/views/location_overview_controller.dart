import 'package:ceal_chronicler_f/key_fields/key_field_resolver.dart';

import '../../../get_it_context.dart';
import '../../../utils/widgets/temporal_overview_controller.dart';
import '../../model/location.dart';
import '../../model/location_id.dart';
import '../../model/location_repository.dart';

class LocationOverviewController
    extends TemporalOverviewController<Location, LocationId> {
  LocationOverviewController() : super(getIt.get<LocationRepository>());

  final KeyFieldResolver resolver = getIt.get<KeyFieldResolver>();

  List<Location> get sortedActiveLocations {
    var activeLocations = super.entitiesAtActivePointInTime;
    activeLocations.sort(_sortLocations);
    return activeLocations;
  }

  int _sortLocations(Location first, Location second) {
    var levelComparison =
        first.locationLevel.value.compareTo(second.locationLevel.value);
    if (levelComparison == 0) {
      String? firstName = resolver.getCurrentValue(first.name);
      String? secondName = resolver.getCurrentValue(second.name);
      if (firstName != null && secondName != null) {
        return firstName.compareTo(secondName);
      }
    }
    return levelComparison;
  }
}
