enum LocationLevel {
  notSet('❔'),
  minayero('🫧'),
  universe('🌌'),
  world('🪐'),
  continent('🗺️'),
  region('🗾'),
  district('🏞️'),
  locale('📍');

  final String icon;

  const LocationLevel(this.icon);

  String toJson() {
    switch (this) {
      case LocationLevel.notSet:
        return "Not Set";
      case LocationLevel.minayero:
        return "Minayero";
      case LocationLevel.universe:
        return "Universe";
      case LocationLevel.world:
        return "World";
      case LocationLevel.continent:
        return "Continent";
      case LocationLevel.region:
        return "Region";
      case LocationLevel.district:
        return "District";
      case LocationLevel.locale:
        return "Locale";
    }
  }

  static LocationLevel fromJson(String? value) {
    switch (value) {
      case "Minayero":
        return LocationLevel.minayero;
      case "Universe":
        return LocationLevel.universe;
      case "World":
        return LocationLevel.world;
      case "Continent":
        return LocationLevel.continent;
      case "Region":
        return LocationLevel.region;
      case "District":
        return LocationLevel.district;
      case "Locale":
        return LocationLevel.locale;
      default:
        return LocationLevel.notSet;
    }
  }
}
