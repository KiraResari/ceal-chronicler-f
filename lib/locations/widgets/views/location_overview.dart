import 'package:ceal_chronicler_f/locations/widgets/buttons/delete_location_button.dart';
import 'package:flutter/material.dart';

import '../../../utils/widgets/overview.dart';
import '../../model/location.dart';
import '../buttons/add_location_button.dart';
import '../buttons/location_button.dart';
import 'location_overview_controller.dart';

class LocationOverview extends Overview<Location, LocationOverviewController> {
  const LocationOverview({super.key});

  @override
  LocationOverviewController createController() {
    return LocationOverviewController();
  }

  @override
  Color get backgroundColor => Colors.blue;

  @override
  String get title => "Locations";

  @override
  List<Location> getItems(LocationOverviewController controller) {
    return controller.sortedActiveLocations;
  }

  @override
  Widget buildItem(Location item) {
    return Row(
      children: [
        LocationButton(item),
        DeleteLocationButton(item),
      ],
    );
  }

  @override
  Widget buildAddButton() {
    return AddLocationButton();
  }
}
