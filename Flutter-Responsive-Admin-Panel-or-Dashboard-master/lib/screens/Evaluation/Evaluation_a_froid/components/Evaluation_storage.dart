import 'package:flutter/material.dart';

import 'package:admin/constants.dart';
import 'Evaluation-graphe.dart';
import 'package:admin/models/Evaluation.dart';


class StorageDetailss extends StatefulWidget {
  final Map<String, String> ratesMap;


  const StorageDetailss({
    Key? key,
    required this.ratesMap,
  }) : super(key: key);
  

   @override
  _EvaluationFile210State createState() => _EvaluationFile210State();
}


class _EvaluationFile210State extends State<StorageDetailss> {
  
  // Map to store rates
  Map<String, String> ratesMap = {};
  double ? selectedtaux ;

 void _handleSelection(double? taux) {
    setState(() {
      selectedtaux = taux;
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
          Text(
            "Evaluation",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: defaultPadding),
          Chart_Evaluation(demoEvaluationFiles: demoEvaluationFiles ,
          onsatisfacationChanged : _handleSelection), 
          ...ratesMap.entries.map((entry) => Text("${entry.key}: ${entry.value}")),
        ],
      ),
    );
  }
}