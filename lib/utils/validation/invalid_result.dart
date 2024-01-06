import 'package:ceal_chronicler_f/utils/validation/validation_result.dart';

class InvalidResult extends ValidationResult{
  final String reason;

  InvalidResult(this.reason);
}