class SerializationException implements Exception{
  String message;
  SerializationException([this.message = "Error while serializing/deserializing"]);
}