class InvalidOperationException implements Exception{
  final String cause;

  InvalidOperationException(this.cause);

  @override
  String toString() => cause;
}