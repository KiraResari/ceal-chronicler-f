enum LocationLevel {
  notSet('❔', "Not Set"),
  minayero('✨', "Minayero"),
  universe('🌌', "Universe"),
  world('🪐', "World"),
  continent('🗺️', "Continent"),
  region('🗾', "Region"),
  district('🏞️', "District"),
  locale('📍', "Locale");

  final String icon;
  final String name;

  const LocationLevel(this.icon, this.name);

  String get iconAndName => icon + name;

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
