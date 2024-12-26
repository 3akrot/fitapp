// lib/widgets/sleep_chart.dart
import 'package:flutter/material.dart';
import 'package:healthapp/providers/sleep_monitor_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:healthapp/models/sleep_data.dart';

class SleepChart extends StatefulWidget {
  const SleepChart({super.key});

  @override
  State<SleepChart> createState() => _SleepChartState();
}

class _SleepChartState extends State<SleepChart> {
  late TooltipBehavior _tooltip;

  @override
  void initState() {
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sleepMonitorProvider =
        Provider.of<SleepMonitorProvider>(context, listen: true);

    final sleepData = sleepMonitorProvider.sleepHistory.entries
        .map((entry) => SleepData(entry.key, entry.value))
        .toList();

    return Center(
      child: Column(
        children: [
          const SizedBox(height: 5),
          Text(
            'Sleep Chart for Last 5 Days',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600]),
          ),
          const SizedBox(height: 20),
          SfCartesianChart(
            primaryXAxis: const CategoryAxis(
              title: AxisTitle(text: 'Days'),
            ),
            primaryYAxis: const NumericAxis(
              title: AxisTitle(text: 'Hours'),
            ),
            tooltipBehavior: _tooltip,
            series: <CartesianSeries<SleepData, String>>[
              ColumnSeries<SleepData, String>(
                dataSource: sleepData,
                xValueMapper: (SleepData sleep, _) => sleep.x,
                yValueMapper: (SleepData sleep, _) => sleep.y / 3600, // Convert seconds to hours
                name: 'Sleep Hours',
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                color: Colors.blue,
              )
            ],
          )
        ],
      ),
    );
  }
}
