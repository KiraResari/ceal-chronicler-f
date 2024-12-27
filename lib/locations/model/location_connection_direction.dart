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

  LocationConnectionDirection get opposite => switch (this) {
        north => south,
        northeast => southwest,
        east => west,
        southeast => northwest,
        south => north,
        southwest => northeast,
        west => east,
        northwest => southeast,
      };
}
