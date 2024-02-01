import 'package:ceal_chronicler_f/timeline/time_processor.dart';
import 'package:flutter/material.dart';

import '../../get_it_context.dart';

class IncidentOverviewController extends ChangeNotifier {
  final _timeProcessor = getIt.get<TimeProcessor>();

  IncidentOverviewController() {
    _timeProcessor.addListener(_notifyListenersCall);
  }

  void _notifyListenersCall() => notifyListeners();

  @override
  void dispose() {
    super.dispose();
    _timeProcessor.removeListener(_notifyListenersCall);
  }

  String get activePointInTimeName => _timeProcessor.activePointInTime.name;
}
