import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
      formation: json['formation'],
      dateDebut: json['date_debut'],
      dateFin: json['date_fin'],
      nombreInterne: json['nombre_interne'],
      nombreExterne: json['nombre_externe'],
      effectifsInterne: json['effectifs_interne'],
      effectifsExterne: json['effectifs_externe'],
    
    );
  }
}

class Dashboard {
  final String prevuAction;
  final String prevuEffectif;
  final String planFormation;
  final int planEffectifs;

  Dashboard({
    required this.prevuAction,
    required this.prevuEffectif,
    required this.planFormation,
    required this.planEffectifs,
  });

  factory Dashboard.fromJson(Map<String, dynamic> json) {
    return Dashboard(
      prevuAction: json['prevu_action_formation'] ?? '',
      prevuEffectif: json['prevu_effectifs'] ?? '',
      planFormation: json['Plan_fromation'] ?? '',  // Correction du nom de la clé
      planEffectifs: json['Plan_effectifs'] != null ? json['Plan_effectifs'] as int : 0,
    );
  }
}

class EffectifTablePage extends StatefulWidget {
  final int selectedMonth;
  final int selectedYear;

  EffectifTablePage({required this.selectedMonth, required this.selectedYear});

  @override
  _EffectifTablePageState createState() => _EffectifTablePageState();
}

class _EffectifTablePageState extends State<EffectifTablePage> {
  List<FormationResult> _results = [];
  bool _isLoading = true;
  List<int> _sommeInterne = [];
  List<int> _sommeExterne = [];
  List<int> _sommeTotale = [];
  List<int> _sommePrecedente = [];
  List<int> _totalEffectifsInterne = [];
  List<int> _totalEffectifsExterne = [];
  List<int> _totalEffectifsPrecedent = [];
  List<int> _categorieMetier = [];
  List<int> _categorieOrdreLegal = [];
  List<int> _categorieQualite = [];
  List<Dashboard> _dashboardResults = [];

  @override
  void initState() {
    super.initState();
    _fetchData(widget.selectedMonth, widget.selectedYear);
    _fetchDashboardData(widget.selectedMonth, widget.selectedYear);
 
  }

  @override
  void didUpdateWidget(covariant EffectifTablePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedYear != oldWidget.selectedYear || widget.selectedMonth != oldWidget.selectedMonth) {
     _fetchData(widget.selectedMonth, widget.selectedYear);
     _fetchDashboardData(widget.selectedMonth, widget.selectedYear);
    
    }
  }
Future<void> _fetchData(int month, int year) async {
  // Réinitialisation des listes
  setState(() {
    _results = [];
    _sommeInterne = List.filled(month, 0);
    _sommeExterne = List.filled(month, 0);
    _sommeTotale = List.filled(month, 0);
    _sommePrecedente = List.filled(month, 0);
    _totalEffectifsInterne = List.filled(month, 0);
    _totalEffectifsExterne = List.filled(month, 0);
    _totalEffectifsPrecedent = List.filled(month, 0);
    _categorieMetier = List.filled(month, 0);
    _categorieOrdreLegal = List.filled(month, 0);
    _categorieQualite = List.filled(month, 0);
    _isLoading = true;
  });

  for (int i = 1; i <= month; i++) {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/count_formations/?mois=$i&annee=$year'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List<dynamic> data = jsonData['resultats'] ?? [];

      setState(() {
        _results.addAll(data.map((json) => FormationResult.fromJson(json)).toList());

        if (i <= _sommeInterne.length) {
          _sommeInterne[i - 1] = jsonData['somme_interne'] ?? 0;
          _sommeExterne[i - 1] = jsonData['somme_externe'] ?? 0;
          _sommeTotale[i - 1] = jsonData['somme_totale'] ?? 0;
          _sommePrecedente[i - 1] = jsonData['somme_precedente'] ?? 0;
          _totalEffectifsInterne[i - 1] = jsonData['total_effectifs_interne'] ?? 0;
          _totalEffectifsExterne[i - 1] = jsonData['total_effectifs_externe'] ?? 0;
          _totalEffectifsPrecedent[i - 1] = jsonData['total_effectifs_precedent'] ?? 0;
          _categorieMetier[i - 1] = jsonData['categorie_metier'] ?? 0;
          _categorieOrdreLegal[i - 1] = jsonData['categorie_ordre_legal'] ?? 0;
          _categorieQualite[i - 1] = jsonData['categorie_qualite'] ?? 0;
        }
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load data for month $i');
    }
  }
}

Future<void> _fetchDashboardData(int month, int year) async {
  try {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/filter-dashbaord/?mois=$month&annee=$year'));
   
  

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List<dynamic> data = jsonData['resultats'] ?? [];

      setState(() {
        _dashboardResults = data.map((json) => Dashboard.fromJson(json)).toList();
        print(_dashboardResults); // Vérifiez que les données sont correctement décodées

        // Si vous devez ajouter une ligne vide ou un élément par défaut, faites-le ici
        _dashboardResults.add(Dashboard(
          prevuAction: '',
          prevuEffectif: '',
          planFormation: '',
          planEffectifs: 0,
        ));

        _isLoading = false;
      });
    } else {
      print('Failed to load dashboard data: ${response.reasonPhrase}');
      throw Exception('Failed to load dashboard data');
    }
  } catch (e) {
    print('Error occurred: $e');
  }
}

  List<DataColumn> _buildColumns() {
    List<String> monthNames = ['Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin', 'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'];
    List<DataColumn> columns = [DataColumn(label: Text(''))];

    for (int i = 0; i < widget.selectedMonth; i++) {
      columns.add(DataColumn(label: Text(monthNames[i], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))));
    }

    return columns;
  }

  List<DataRow> _buildRows() {
  List<DataRow> rows = [];

  // Row for "Effectif formé"
  rows.add(DataRow(cells: [
    DataCell(Text('Effectif formé', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
    ...List.generate(widget.selectedMonth, (index) {
      return DataCell(Text('${_totalEffectifsPrecedent[index]}'));
    })
  ]));

  // Row for "% Effectif formé / mois"
  rows.add(DataRow(cells: [
    DataCell(Text('% Effectif formé / mois', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
    ...List.generate(widget.selectedMonth, (index) {
      final effectif = _totalEffectifsPrecedent[index];
      final plan = _dashboardResults.isNotEmpty
        ? _dashboardResults[0].planEffectifs
        : 1; // Valeur par défaut pour éviter la division par zéro
   
      final percentage = plan > 0 ? (effectif / plan * 100) : 0;
      return DataCell(Text('${percentage.toStringAsFixed(8)} %'));
    })
  ]));

  // Row for "Action formation"
  rows.add(DataRow(cells: [
    DataCell(Text('Action formation', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
    ...List.generate(widget.selectedMonth, (index) {
      return DataCell(Text('${_sommePrecedente[index]}'));
    })
  ]));

  return rows;
}

@override
Widget build(BuildContext context) {
  
  return Container(
    padding: EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width,
                      ),
                      child: DataTable(
                        border: TableBorder.all(
                          color: Colors.grey.withOpacity(0.5),
                          width: 2,
                        ),
                        columns: _buildColumns(),
                        rows: _buildRows(),
                      ),
                    ),
                  ),
                ),
        ),
      ],
    ),
  );
}
}