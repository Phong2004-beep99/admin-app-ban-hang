import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DashboardChart extends StatelessWidget {
  final int pending;
  final int onTheWay;
  final int delivered;
  final int cancelled;

  const DashboardChart({
    Key? key,
    required this.pending,
    required this.onTheWay,
    required this.delivered,
    required this.cancelled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: pending.toDouble(),
              title: 'Đang chờ',
              color: Colors.orange,
            ),
            PieChartSectionData(
              value: onTheWay.toDouble(),
              title: 'Đang giao',
              color: Colors.blue,
            ),
            PieChartSectionData(
              value: delivered.toDouble(),
              title: 'Đã giao',
              color: Colors.green,
            ),
            PieChartSectionData(
              value: cancelled.toDouble(),
              title: 'Đã hủy',
              color: Colors.red,
            ),
          ],
          sectionsSpace: 2,
          centerSpaceRadius: 40,
        ),
      ),
    );
  }
}
