enum LocationConnectionDirection {
  north,
  northeast,
  east,
  southeast,
  south,
  southwest,
  west,
  northwest;

  static LocationConnectionDirection fromName(String name) {
    return LocationConnectionDirection.values.firstWhere(
      (direction) => direction.name == name,
      orElse: () => LocationConnectionDirection.north,
    );
  }
}
