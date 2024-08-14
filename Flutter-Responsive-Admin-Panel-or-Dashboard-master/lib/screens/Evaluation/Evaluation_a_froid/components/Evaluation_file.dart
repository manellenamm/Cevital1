import 'package:flutter/material.dart';
import 'package:admin/constants.dart';
import 'package:admin/models/Evaluation.dart';
import 'Evaluation-graphe.dart';
import 'storage_info_Evaluation.dart';

class EvaluationFiles extends StatefulWidget {
  final void Function(Map<String, String>) onRatesMapChanged; 
  final void Function(double?) handleSelection; 
  final double? selectedtaux;

  const EvaluationFiles({
    Key? key,
    required this.onRatesMapChanged, 
    required this.handleSelection,
    this.selectedtaux,
  }) : super(key: key);

  @override
  _EvaluationFilesState createState() => _EvaluationFilesState();
}
class _EvaluationFilesState extends State<EvaluationFiles> {
  // Map to store rates
  Map<String, String> ratesMap = {};
  double? selectedtaux;

  @override
  void initState() {
    super.initState();
    selectedtaux = widget.selectedtaux;
  }

  void handleSelection(double? taux) {
    setState(() {
      selectedtaux = taux;
      widget.handleSelection(taux);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: DataTable(
              columnSpacing: defaultPadding,
              columns: [
                DataColumn(
                  label: Container(
                    width: 200,
                    child: Text(
                      "Objectif de la formation",
                      style: TextStyle(fontWeight: FontWeight.bold),
                      softWrap: true,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text("Sur 5 quel est votre degré de satisfaction"),
                ),
                DataColumn(
                  label: Text("Evaluation"),
                ),
              ],
              rows: List.generate(
                demoEvaluationFiles.length,
                (index) => recentFileDataRow(context, demoEvaluationFiles[index]),
              ),
            ),
          ),
          SizedBox(height: defaultPadding),
          Chart_Evaluation(
            demoEvaluationFiles: demoEvaluationFiles,
            onsatisfacationChanged: handleSelection,
          ),
          StorageEvaluation(
            title: "Satisfaction",
            color: Colors.yellow,
          ),
          StorageEvaluation(
            title: "Ecart",
            color: Color(0xFF014F8F),
          ),
        ],
      ),
    );
  }

  DataRow recentFileDataRow(BuildContext context, EvaluationFile fileInfo) {
    TextEditingController rateController =
        TextEditingController(text: fileInfo.rate);

    return DataRow(
      cells: [
        DataCell(Text(fileInfo.Objectif!)),
        DataCell(
          TextFormField(
            controller: rateController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: 'Enter rate (1-5)'),
            onChanged: (value) {
              setState(() {
                fileInfo.rate = value;
                fileInfo.evaluation = calculateEvaluation(value);
                ratesMap[fileInfo.Objectif!] = value;
                print("Updated ratesMap: $ratesMap");
                
                widget.onRatesMapChanged(ratesMap);
              });
            },
          ),
        ),
        DataCell(Text(fileInfo.evaluation)),
      ],
    );
  }

  String calculateEvaluation(String rate) {
    if (rate.isEmpty) {
      return "";
    }
    int rateValue = int.tryParse(rate) ?? 0;
    if (rateValue < 1 || rateValue > 5) {
      return "Invalid rate";
    }
    return "${(rateValue / 5 * 100).toStringAsFixed(2)}%";
  }
}
