enum LocationLevel {
  notSet('❔', _notSetName, -1),
  minayero('✨', _minayeroName, 0),
  universe('🌌', _universeName, 1),
  world('🪐', _worldName, 2),
  continent('🗺️', _continentName, 3),
  region('🗾', _regionName, 4),
  district('🏞️', _districtName, 5),
  locale('📍', _localeName, 6);

  static const _notSetName = "Not Set";
  static const _minayeroName = "Minayero";
  static const _universeName = "Universe";
  static const _worldName = "World";
  static const _continentName = "Continent";
  static const _regionName = "Region";
  static const _districtName = "District";
  static const _localeName = "Locale";
  static const Map<String, LocationLevel> _locationLevelMap = {
    _minayeroName: LocationLevel.minayero,
    _universeName: LocationLevel.universe,
    _worldName: LocationLevel.world,
    _continentName: LocationLevel.continent,
    _regionName: LocationLevel.region,
    _districtName: LocationLevel.district,
    _localeName: LocationLevel.locale,
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

  static LocationLevel fromJson(String? name) {
    return _locationLevelMap[name] ?? LocationLevel.notSet;
  }
}
