import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'incident_overview_controller.dart';

class IncidentOverview extends StatelessWidget {
  const IncidentOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => IncidentOverviewController(),
      builder: (context, child) => _buildTitle(context),
    );
  }

  Center _buildTitle(BuildContext context) {
    String activePointInTimeName =
        context.watch<IncidentOverviewController>().activePointInTimeName;
    TextStyle style = Theme.of(context).textTheme.headlineSmall!;
    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text("Incidents at $activePointInTimeName", style: style),
      ),
    );
  }
}
