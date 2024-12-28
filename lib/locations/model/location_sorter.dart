import '../../get_it_context.dart';
import '../../key_fields/key_field_resolver.dart';
import 'location.dart';

class LocationSorter {
  final _resolver = getIt.get<KeyFieldResolver>();

  int sort(Location first, Location second) {
    var levelComparison =
        first.locationLevel.value.compareTo(second.locationLevel.value);
    if (levelComparison == 0) {
      String? firstName = _resolver.getCurrentValue(first.name);
      String? secondName = _resolver.getCurrentValue(second.name);
      if (firstName != null && secondName != null) {
        return firstName.compareTo(secondName);
      }
    }
    return levelComparison;
  }
}
