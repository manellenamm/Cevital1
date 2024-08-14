import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../constants.dart';
import 'chart1.dart';
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
class StorageDetails extends StatefulWidget {
  final int selectedMonth;
  final int selectedYear;

  StorageDetails({required this.selectedMonth, required this.selectedYear});

  @override
  _StorageDetailsPageState createState() => _StorageDetailsPageState();
}

class _StorageDetailsPageState extends State<StorageDetails> {
  List<FormationResult> _formationResults = [];
  bool _isLoading = true;
  int categorieMetier = 0;
  int categorieOrdreLegal = 0;
  int categorieQualite = 0;
  int categorieTransverse = 0;

  @override
  void initState() {
    super.initState();
    _fetchFormationData(widget.selectedMonth, widget.selectedYear);
  }

  @override
  void didUpdateWidget(covariant StorageDetails oldWidget) {
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

          categorieMetier = jsonData['categorie_metier'] ?? 0;
          categorieOrdreLegal = jsonData['categorie_ordre_legal'] ?? 0;
          categorieQualite = jsonData['categorie_qualite'] ?? 0;
          categorieTransverse = jsonData['categorie_transverse'] ?? 0;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Map<String, double> _calculateCategoryPercentages() {
    int totalMetier = categorieMetier;
    int totalOrdreLegal = categorieOrdreLegal;
    int totalQualite = categorieQualite;
    int totalTransverse = categorieTransverse;

    int totalCategories = totalMetier + totalOrdreLegal + totalQualite + totalTransverse;

    return {
      'Métier': totalCategories > 0 ? (totalMetier / totalCategories) * 100 : 0,
      'Ordre légal': totalCategories > 0 ? (totalOrdreLegal / totalCategories) * 100 : 0,
      'Qualité': totalCategories > 0 ? (totalQualite / totalCategories) * 100 : 0,
      'Transverse': totalCategories > 0 ? (totalTransverse / totalCategories) * 100 : 0,
    };
  }

  @override
  Widget build(BuildContext context) {
    final categoryPercentages = _calculateCategoryPercentages();
    print("Métier: ${categoryPercentages['Métier']}%");
    print("Ordre légal: ${categoryPercentages['Ordre légal']}%");
    print("Qualité: ${categoryPercentages['Qualité']}%");
    print("Transverse: ${categoryPercentages['Transverse']}%");

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
            "Actions de formations/Catégorie de formation",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: defaultPadding),
          Chart1(
            categoryPercentages: categoryPercentages,
          ),
          StorageInfoCard(
            title: "Métier",
            color: Colors.yellow,
            percentage: categoryPercentages['Métier']!,
          ),
          StorageInfoCard(
            title: "Ordre légal",
            color: Color(0xFF014F8F),
            percentage: categoryPercentages['Ordre légal']!,
          ),
          StorageInfoCard(
            title: "Qualité",
            color: Colors.green,
            percentage: categoryPercentages['Qualité']!,
          ),
          StorageInfoCard(
            title: "Transverse",
            color: Colors.red,
            percentage: categoryPercentages['Transverse']!,
          ),
        ],
      ),
    );
  }
}
