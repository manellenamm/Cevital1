import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../constants.dart';
import 'chart2.dart';
import 'storage_info_card.dart';

class FormationResult {
  final String formation;
  final String dateDebut;
  final String dateFin;
  final int nombreInterne;
  final int nombreExterne;
  final int effectifsInterne;
  final int effectifsExterne;

  FormationResult({
    required this.formation,
    required this.dateDebut,
    required this.dateFin,
    required this.nombreInterne,
    required this.nombreExterne,
    required this.effectifsInterne,
    required this.effectifsExterne,
  });

  factory FormationResult.fromJson(Map<String, dynamic> json) {
    return FormationResult(
      formation: json['formation'] ?? '',
      dateDebut: json['date_debut'] ?? '',
      dateFin: json['date_fin'] ?? '',
      nombreInterne: json['nombre_interne'] ?? 0,
      nombreExterne: json['nombre_externe'] ?? 0,
      effectifsInterne: json['effectifs_interne'] ?? 0,
      effectifsExterne: json['effectifs_externe'] ?? 0,
    );
  }
}
class StorageDetailss extends StatefulWidget {
  final int selectedMonth;
  final int selectedYear;

  StorageDetailss({required this.selectedMonth, required this.selectedYear});

  @override
  _StorageDetailsPageState createState() => _StorageDetailsPageState();
}

class _StorageDetailsPageState extends State<StorageDetailss> {
  List<FormationResult> _formationResults = [];
  bool _isLoading = true;
  int cspCadre = 0;
  int  cspMaitrise = 0;
  int  cspExecution = 0;


  @override
  void initState() {
    super.initState();
    _fetchFormationData(widget.selectedMonth, widget.selectedYear);
  }

  @override
  void didUpdateWidget(covariant StorageDetailss oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedYear != oldWidget.selectedYear || widget.selectedMonth != oldWidget.selectedMonth) {
      _fetchFormationData(widget.selectedMonth, widget.selectedYear);
    }
  }

  Future<void> _fetchFormationData(int month, int year) async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/count_formations/?mois=$month&annee=$year'));
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print('Decoded JSON Data: $jsonData');

        List<dynamic> data = jsonData['resultats'] ?? [];

        setState(() {
          _formationResults = data.map((json) {
            print('Formation JSON: $json');
            return FormationResult.fromJson(json);
          }).toList();
          _isLoading = false;

          if (_formationResults.isEmpty) {
            _formationResults.add(FormationResult(
              formation: '',
              dateDebut: '',
              dateFin: '',
              nombreInterne: 0,
              nombreExterne: 0,
              effectifsInterne: 0,
              effectifsExterne: 0,
            ));
          }

          cspCadre= jsonData['csp_cadre'] ?? 0;
          cspMaitrise = jsonData['csp_maitrise'] ?? 0;
          cspExecution = jsonData['csp_execution'] ?? 0;
      
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Map<String, double> _calculateCategoryPercentages() {
    int totalCadre = cspCadre;
    int totalExecution = cspExecution;
    int totalMaitrise = cspMaitrise;
  

    int totalCategories = totalCadre + totalExecution + totalMaitrise ;

    return {
      'Cadre': totalCategories > 0 ? (totalCadre / totalCategories) * 100 : 0,
      'Exécution': totalCategories > 0 ? (totalExecution/ totalCategories) * 100 : 0,
      'Maitrise': totalCategories > 0 ? (totalMaitrise/ totalCategories) * 100 : 0,
     
    };
  }

  @override
  Widget build(BuildContext context) {
    final categoryPercentages = _calculateCategoryPercentages();
    print("Cadre: ${categoryPercentages['Cadre']}%");
    print("Exécution: ${categoryPercentages['Exécution']}%");
    print("Maitrise: ${categoryPercentages['Maitrise']}%");
   
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
            "Action de formation/Catégorie socioprofessionnelle",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: defaultPadding),
          Chart2(
            categoryPercentages: categoryPercentages,
          ),
          StorageInfoCard(
            title: "Cadre",
            color: Colors.yellow,
            percentage: categoryPercentages['Cadre']!,
          ),
          StorageInfoCard(
            title: "Exécution",
            color: Color(0xFF014F8F),
            percentage: categoryPercentages['Exécution']!,
          ),
          StorageInfoCard(
            title: "Maitrise",
            color: Colors.green,
            percentage: categoryPercentages['Maitrise']!,
          ),
         
        ],
      ),
    );
  }
}



