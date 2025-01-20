import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Analytics'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Stock Levels'),
              Tab(text: 'Sales'),
              Tab(text: 'Revenue'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _StockLevelChart(),
            _SalesChart(),
            _RevenueChart(),
          ],
        ),
      ),
    );
  }
}

class _StockLevelChart extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 100,
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text('Product ${value.toInt()}');
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: true),
          barGroups: [
            BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 75)]),
            BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 45)]),
            BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 90)]),
          ],
        ),
      ),
    );
  }
}

class _SalesChart extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: true),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text('Day ${value.toInt()}');
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            LineChartBarData(
              spots: [
                const FlSpot(0, 3),
                const FlSpot(1, 5),
                const FlSpot(2, 4),
                const FlSpot(3, 7),
                const FlSpot(4, 6),
              ],
              isCurved: true,
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}

class _RevenueChart extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: 35,
              title: 'Product A',
              color: Colors.blue,
            ),
            PieChartSectionData(
              value: 25,
              title: 'Product B',
              color: Colors.red,
            ),
            PieChartSectionData(
              value: 40,
              title: 'Product C',
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}
