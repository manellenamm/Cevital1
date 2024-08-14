import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class Chart2 extends StatelessWidget {
  final Map<String, double> categoryPercentages;

  const Chart2({
    Key? key,
    required this.categoryPercentages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 70,
              startDegreeOffset: -90,
              sections: _pieChartSections(categoryPercentages),
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: defaultPadding),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _pieChartSections(Map<String, double> percentages) {
    return [
      PieChartSectionData(
        color: Colors.yellow,
        value: percentages['Cadre'] ?? 0,
        showTitle: false,
        radius: 29,
      ),
      PieChartSectionData(
        color: Color(0xFF014F8F),
        value: percentages['Exécution'] ?? 0,
        showTitle: false,
        radius: 30,
      ),
      PieChartSectionData(
        color: Colors.green,
        value: percentages['Maitrise'] ?? 0,
        showTitle: false,
        radius: 29,
      ),
  
    ];
  }
}