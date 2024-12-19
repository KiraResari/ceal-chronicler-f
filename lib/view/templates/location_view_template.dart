import 'package:ceal_chronicler_f/locations/model/location.dart';
import 'package:ceal_chronicler_f/locations/model/location_repository.dart';

import '../../get_it_context.dart';
import '../../key_fields/key_field_resolver.dart';
import '../../locations/widgets/location_view.dart';
import '../../main_view/main_view_candidate.dart';
import '../../timeline/model/point_in_time_id.dart';
import 'main_view_template.dart';
import 'temporally_limited_template.dart';

class LocationViewTemplate extends TemporallyLimitedTemplate
    implements MainViewTemplate {
  final _locationRepository = getIt<LocationRepository>();
  final _keyFieldResolver = getIt.get<KeyFieldResolver>();

  final Location location;

  LocationViewTemplate(this.location);

  @override
  MainViewCandidate get associatedView => LocationView(location: location);

  @override
  bool get isValid => _locationRepository.contains(location.id);

  @override
  PointInTimeId? get firstAppearance => location.firstAppearance;

  @override
  PointInTimeId? get lastAppearance => location.lastAppearance;

  @override
  String get identifier{
    String name = _keyFieldResolver.getCurrentValue(location.name);
    return "Location '$name'";
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationViewTemplate &&
          runtimeType == other.runtimeType &&
          location == other.location;

  @override
  int get hashCode => location.hashCode;
}
