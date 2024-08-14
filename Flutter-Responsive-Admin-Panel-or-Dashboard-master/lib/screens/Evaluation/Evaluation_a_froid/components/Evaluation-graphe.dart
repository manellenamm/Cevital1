import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:admin/models/Evaluation.dart';

class Chart_Evaluation extends StatefulWidget {
  final List<EvaluationFile> demoEvaluationFiles;
  final void Function(double?) onsatisfacationChanged;

  const Chart_Evaluation({
    Key? key,
    required this.demoEvaluationFiles,
    required this.onsatisfacationChanged,
  }) : super(key: key);

  @override
  _Chart_EvaluationState createState() => _Chart_EvaluationState();
}
class _Chart_EvaluationState extends State<Chart_Evaluation> {
  double? previousAverage;

  @override
  void didUpdateWidget(Chart_Evaluation oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Recalculate average and notify parent if it has changed
    double currentAverage = calculateAverageEvaluation();
    if (currentAverage != previousAverage) {
      widget.onsatisfacationChanged(currentAverage);
      previousAverage = currentAverage;
    }
  }

  @override
  Widget build(BuildContext context) {
    double average = calculateAverageEvaluation();

    double blueValue = average; // La valeur moyenne en bleu
    double yellowValue = 100 - average; // Le reste en jaune

    return SizedBox(
      height: 200,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: PieChart(
                PieChartData(
                  sectionsSpace: 0,
                  centerSpaceRadius: 70,
                  startDegreeOffset: -90,
                  sections: [
                    PieChartSectionData(
                      color: Color(0xFFFFCF26), // Couleur bleue pour l'average
                      value: blueValue,
                      showTitle: false,
                      radius: 29,
                    ),
                    PieChartSectionData(
                      color: Color(0xFF014F8F), // Couleur jaune pour le reste
                      value: yellowValue,
                      showTitle: false,
                      radius: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 220,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Taux de satisfaction",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: 150,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "${average.toStringAsFixed(2)}%",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double calculateAverageEvaluation() {
    double total = 0;
    int count = 0;

    for (var file in widget.demoEvaluationFiles) {
      if (file.evaluation.isNotEmpty) {
        double evaluationValue =
            double.tryParse(file.evaluation.replaceAll("%", "")) ?? 0;
        total += evaluationValue;
        count++;
      }
    }

    if (count == 0) return 0;

    double average = total / count;
    return average;
  }
}
