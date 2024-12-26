enum LocationLevel {
  notSet('❔', notSetName, -1),
  minayero('✨', minayeroName, 0),
  universe('🌌', universeName, 1),
  world('🪐', worldName, 2),
  continent('🗺️', continentName, 3),
  region('🗾', regionName, 4),
  district('🏞️', districtName, 5),
  locale('📍', localeName, 6);

  static const notSetName = "Not Set";
  static const minayeroName = "Minayero";
  static const universeName = "Universe";
  static const worldName = "World";
  static const continentName = "Continent";
  static const regionName = "Region";
  static const districtName = "District";
  static const localeName = "Locale";
  static const Map<String, LocationLevel> _locationLevelMap = {
    minayeroName: LocationLevel.minayero,
    universeName: LocationLevel.universe,
    worldName: LocationLevel.world,
    continentName: LocationLevel.continent,
    regionName: LocationLevel.region,
    districtName: LocationLevel.district,
    localeName: LocationLevel.locale,
  };

  final String icon;
  final String name;
  final int value;

  const LocationLevel(this.icon, this.name, this.value);

  String get iconAndName => icon + name;

  bool isAbove(LocationLevel other) {
    return this == LocationLevel.notSet || other.value > value;
  }

  bool isBelow(LocationLevel other) {
    return this == LocationLevel.notSet || other.value < value;
  }

  bool isEquivalent(LocationLevel other) {
    return this == LocationLevel.notSet || other.value == value;
  }

  static LocationLevel fromJson(String? value) {
    return _locationLevelMap[value] ?? LocationLevel.notSet;
  }
}
