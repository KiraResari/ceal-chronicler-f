import 'package:flutter/material.dart';

class StringKey extends ValueKey<String>{
  const StringKey(super.value);

  @override
  String toString() {
    return value;
  }
}