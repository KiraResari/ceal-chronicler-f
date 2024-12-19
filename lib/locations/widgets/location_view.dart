import 'package:flutter/material.dart';

import '../../main_view/main_view_candidate.dart';
import '../model/location.dart';

class LocationView extends MainViewCandidate {
  final Location location;

  const LocationView({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}
