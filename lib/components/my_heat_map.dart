import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class MyHeatMap extends StatelessWidget {
  final DateTime startDate;
  final Map<DateTime, int> datasets;

  // when set, renders every "done" day in this single color instead of
  // the default green intensity ramp — used for a single habit's
  // heatmap, tinted to match its category color. The aggregate dashboard
  // heatmap (multiple habits, values 1-5) leaves this null.
  final Color? accentColor;

  const MyHeatMap({
    super.key,
    required this.startDate,
    required this.datasets,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorsets = accentColor != null
        ? {1: accentColor!}
        : {
            1: Colors.green.shade200,
            2: Colors.green.shade300,
            3: Colors.green.shade400,
            4: Colors.green.shade500,
            5: Colors.green.shade600,
          };

    return HeatMap(
      startDate: startDate,
      endDate: DateTime.now(),
      datasets: datasets,
      colorMode: ColorMode.color,
      defaultColor: Theme.of(context).colorScheme.secondary,
      textColor: Theme.of(context).colorScheme.inversePrimary,
      showColorTip: false,
      showText: true,
      scrollable: true,
      size: 30,
      colorsets: colorsets,
    );
  }
}
