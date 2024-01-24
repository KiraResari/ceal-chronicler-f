class CommandFailedException implements Exception{
  final String cause;

  CommandFailedException(this.cause);

  @override
  String toString() => cause;
}