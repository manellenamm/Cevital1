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
  final String prevu_action;
  final String prevu_effectif;
  final String plan_formation;
  final int plan_effetcifs;
  
 Dashboard({
    required this.prevu_action,
    required this.prevu_effectif,
    required this.plan_formation,
    required this.plan_effetcifs,
   
  });

  factory Dashboard.fromJson(Map<String, dynamic> json) {
    return Dashboard(
      prevu_action: json['prevu_action_formation'],
      prevu_effectif: json['prevu_effectifs'],
      plan_formation: json['Plan_fromation'],
      plan_effetcifs: json['Plan_effectifs'],
    
    );
  }
}

class BudjetsResult {
  final String realise;
  final String prevu;
  final String plan;
  final double pourcentageRealise;

  BudjetsResult({
    required this.realise,
    required this.prevu,
    required this.plan,
    required this.pourcentageRealise,
  });

  factory BudjetsResult.fromJson(Map<String, dynamic> json) {
    final double realise = double.tryParse(json['realise'] ?? '0') ?? 0;
    final double prevu = double.tryParse(json['Prevu'] ?? '0') ?? 0;
    final double pourcentageRealise = prevu > 0 ? (realise / prevu) * 100 : 0;

    return BudjetsResult(
      realise: json['realise'] ?? '0',
      prevu: json['Prevu'] ?? '0',
      plan: json['Plan'] ?? '0',
      pourcentageRealise: pourcentageRealise,
    );
  }
}

class BudjetsResponse {
  final List<BudjetsResult> resultats;
  final int cumul;

  BudjetsResponse({
    required this.resultats,
    required this.cumul,
  });

  factory BudjetsResponse.fromJson(Map<String, dynamic> json) {
    return BudjetsResponse(
      resultats: (json['resultats'] as List<dynamic>)
          .map((item) => BudjetsResult.fromJson(item as Map<String, dynamic>))
          .toList(),
      cumul: json['cumul'] ?? 0,
    );
  }
}

class SampleTablePage extends StatefulWidget {
  final void Function(int?, int?) Onmonth_yearChanged;

  const SampleTablePage({
    Key? key,
    required this.Onmonth_yearChanged,
  }) : super(key: key);

  @override
  _SampleTablePageState createState() => _SampleTablePageState();
}

class _SampleTablePageState extends State<SampleTablePage> {
  List<FormationResult> _formationResults = [];
  List<Dashboard> _dashboardResults = [];
  List<BudjetsResult> _budjetsResults = [];
  int _cumul = 0; // Déclaration de _cumul
  bool _isLoading = true;
  int _selectedMonth = DateTime.now().month; // Default to current month
  int _selectedYear = DateTime.now().year; // Default to current year
  double _pourcentageAction = 0.0;
  double _pourcentageEffectif = 0.0;

  void Onmonth_yearChanged() {
    // La valeur saisie est stockée dans une variable locale
    int month = _selectedMonth;
    int year = _selectedYear;
    
    // Utiliser la fonction callback pour notifier le parent
    widget.Onmonth_yearChanged(month, year  );
  }

  final List<String> _monthNames = [
    'janvier',
    'février',
    'mars',
    'avril',
    'mai',
    'juin',
    'juillet',
    'août',
    'septembre',
    'octobre',
    'novembre',
    'décembre'
  ];

  final List<int> _years =
      List.generate(10, (index) => DateTime.now().year - index);

  int _sommeInterne = 0;
  int _sommeExterne = 0;
  int _sommeTotale = 0;
  int _sommePrecedente = 0;
  int _totalEffectifsInterne = 0;
  int _totalEffectifsExterne = 0;
  int _totalsommeEffectifs = 0;
  int _totalEffectifsPrecedent = 0;
  int _categorieMetier = 0;
  int _categorieOrdreLegal = 0;
  int _categorieQualite = 0;

  @override
  void initState() {
    super.initState();
    _fetchFormationData(_selectedMonth, _selectedYear);
    _fetchBudjetsData(_selectedMonth, _selectedYear);
    _fetchDashboardData(_selectedMonth, _selectedYear);
  }

  Future<void> _fetchBudjetsData(int month, int year) async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/filter-budjets/?mois=$month&annee=$year'));
   

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      
      // Parse the JSON response using the BudjetsResponse class
      BudjetsResponse budjetsResponse = BudjetsResponse.fromJson(jsonData);

      setState(() {
        _budjetsResults = budjetsResponse.resultats;
        _cumul = budjetsResponse.cumul; 
        _isLoading = false;

        if (_budjetsResults.isEmpty) {
          // Ajouter une ligne vide si aucune donnée n'est disponible
          _budjetsResults.add(BudjetsResult(
            realise: '',
            prevu: '',
            plan: '',
            pourcentageRealise: 0.0,
          ));
        }
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> _fetchFormationData(int month, int year) async {
    final response = await http.get(Uri.parse(
        'http://127.0.0.1:8000/count_formations/?mois=$month&annee=$year'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List<dynamic> data = jsonData['resultats'] ?? [];

      setState(() {
        _formationResults =
            data.map((json) => FormationResult.fromJson(json)).toList();
        _isLoading = false;

        if (_formationResults.isEmpty) {
          // Ajouter une ligne vide si aucune donnée n'est disponible
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

        _sommeInterne = jsonData['somme_interne'] ?? 0;
        _sommeTotale = jsonData['somme_totale'] ?? 0;
        _sommeExterne = jsonData['somme_externe'] ?? 0;
        _sommePrecedente = jsonData['somme_precedente'] ?? 0;
        _totalEffectifsInterne = jsonData['total_effectifs_interne'] ?? 0;
        _totalEffectifsExterne = jsonData['total_effectifs_externe'] ?? 0;
        _totalsommeEffectifs = _totalEffectifsInterne + _totalEffectifsExterne;
        _totalEffectifsPrecedent = jsonData['total_effectifs_precedent'] ?? 0;
        _categorieMetier = jsonData['categorie_metier'] ?? 0;
        _categorieOrdreLegal = jsonData['categorie_ordre_legal'] ?? 0;
        _categorieQualite = jsonData['categorie_qualite'] ?? 0;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }
  Future<void> _fetchDashboardData(int month, int year) async {
    final response = await http.get(Uri.parse(
        'http://127.0.0.1:8000/api/filter-dashbaord/?mois=$month&annee=$year'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List<dynamic> data = jsonData['resultats'] ?? [];

      setState(() {
        _dashboardResults =
            data.map((json) => Dashboard.fromJson(json)).toList();
        _isLoading = false;

       if (_dashboardResults.isNotEmpty) {
        var dashboard = _dashboardResults[0];

        // Assurez-vous que les champs sont bien des entiers ou des nombres pour éviter les erreurs
        double prevuAction = double.tryParse(dashboard.prevu_action) ?? 0.0;
        double sommeExterne = _sommeExterne.toDouble();
        
        // Calculer le pourcentage basé sur `prevu_action`
        _pourcentageAction = sommeExterne > 0 ? (sommeExterne/ prevuAction ) * 100 : 0.0;

        double prevuEffectif = double.tryParse(dashboard.prevu_effectif) ?? 0.0;
        double totalEffectifExterne = _totalEffectifsExterne.toDouble();
        
        // Calculer le pourcentage basé sur `prevu_effectif`
        _pourcentageEffectif = totalEffectifExterne > 0 ? (totalEffectifExterne / prevuEffectif) * 100 : 0.0;
      } else {
        // Ajouter une ligne vide si aucune donnée n'est disponible
        _dashboardResults.add(Dashboard(
          prevu_action: '',
          prevu_effectif: '',
          plan_formation: '',
          plan_effetcifs: 0,
        ));
        // Remettre les pourcentages à zéro en cas d'absence de données
        _pourcentageAction = 0.0;
        _pourcentageEffectif = 0.0;
      }
    });
  } else {
    throw Exception('Failed to load data');
  }
}

  @override
  Widget build(BuildContext context) {
    String monthName =
        _monthNames[_selectedMonth - 1]; // Convert month number to name

    bool actionFormationAdded = false;
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Row(
  children: [
    Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
          color: Colors.yellow.withOpacity(0.8),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: DropdownButton<int>(
          value: _selectedMonth,
          items: List.generate(
            12,
            (index) => DropdownMenuItem<int>(
              value: index + 1,
              child: Text(_monthNames[index]),
            ),
          ),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedMonth = value;
                // Appeler la fonction pour notifier les changements
                Onmonth_yearChanged();
                _fetchFormationData(_selectedMonth, _selectedYear);
                _fetchBudjetsData(_selectedMonth, _selectedYear);
                _fetchDashboardData(_selectedMonth, _selectedYear);
              });
            }
          },
          hint: Text('Choisissez le mois'),
          isExpanded: true,
          underline: SizedBox(),
        ),
      ),
    ),
    SizedBox(width: 16.0),
    Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
          color: Colors.yellow.withOpacity(0.8),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: DropdownButton<int>(
          value: _selectedYear,
          items: _years
              .map((year) => DropdownMenuItem<int>(
                    value: year,
                    child: Text(year.toString()),
                  ))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedYear = value;
                // Appeler la fonction pour notifier les changements
                Onmonth_yearChanged();
                _fetchFormationData(_selectedMonth, _selectedYear);
                _fetchBudjetsData(_selectedMonth, _selectedYear);
                _fetchDashboardData(_selectedMonth, _selectedYear);
              });
            }
          },
          hint: Text('Choisissez l\'année'),
          isExpanded: true,
          underline: SizedBox(),
        ),
      ),
    ),
  ],
),
          SizedBox(height: 16.0),
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      columnSpacing: 20.0,
                      headingRowHeight: 60.0,
                      dataRowHeight: 60.0,
                      border: TableBorder.all(
                          color: Colors.grey.withOpacity(0.5), width: 1),
                      columns: [
                        DataColumn(
                          label: Text('', style: TextStyle()),
                        ),
                        DataColumn(
                          label: Text('Réalisé $monthName en externe',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ),
                        DataColumn(
                          label: Text('Prévu $monthName plan $_selectedYear',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ),
                        DataColumn(
                          label: Text(
                              'Réalisé vs Prévu $monthName en $_selectedYear',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ),
                        DataColumn(
                          label: Text('Formation (interne)',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ),
                        DataColumn(
                          label: Text('Total',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ),
                        DataColumn(
                          label: Text(
                              'Cumul réalisé $monthName en $_selectedYear',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ),
                        DataColumn(
                          label: Text('Plan de formation $_selectedYear',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ),
                      ],
                      rows: [
                        DataRow(cells: [
                          DataCell(Text('Action formation',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black))),
                          DataCell(Text(_sommeExterne
                              .toString())), // Utiliser les données des résultats
                           DataCell(Text(_dashboardResults.isNotEmpty
                              ? _dashboardResults[0].prevu_action
                              : '')), // Exemple : utiliser 0 pour les valeurs fictives
                           DataCell(Text('${_pourcentageAction.toStringAsFixed(2)}%')),

                          DataCell(Text(_sommeInterne.toString())),
                          DataCell(Text(_sommeTotale.toString())),
                          DataCell(Text(_sommePrecedente
                              .toString())), // Exemple : utiliser la somme externe pour les valeurs fictives
                          DataCell(Text(_dashboardResults.isNotEmpty
                              ? _dashboardResults[0].plan_formation
                              : '')), // 
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Cumul des effectifs formés',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black))),
                          DataCell(Text(_totalEffectifsExterne.toString())),
                               DataCell(Text(_dashboardResults.isNotEmpty
                              ? _dashboardResults[0].prevu_effectif
                              : '')),
                           DataCell(Text('${_pourcentageEffectif.toStringAsFixed(2)}%')),
                          DataCell(Text(_totalEffectifsInterne.toString())),
                          DataCell(Text(_totalsommeEffectifs.toString())),
                          DataCell(Text(_totalEffectifsPrecedent.toString())),
                          DataCell(Text(
                          _dashboardResults.isNotEmpty
                              ? _dashboardResults[0].plan_effetcifs.toString() // Convertir l'entier en chaîne pour l'affichage
                              : '', // Valeur par défaut si la liste est vide
                        )),
                        ]),
                        // Ligne des budgets
                        DataRow(cells: [
                          DataCell(Text('Budget',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black))),
                          DataCell(Text(_budjetsResults.isNotEmpty
                              ? _budjetsResults[0].realise
                              : '')),
                          DataCell(Text(_budjetsResults.isNotEmpty
                              ? _budjetsResults[0].prevu
                              : '')),
                          DataCell(Text(_budjetsResults.isNotEmpty
      ? _budjetsResults[0].pourcentageRealise.toStringAsFixed(2) + '%'
      : '')),
                          DataCell(Text('')),
                          DataCell(Text('')),
                         (DataCell(Text(_cumul.toString()))), 
                         DataCell(Text(_budjetsResults.isNotEmpty
                              ? _budjetsResults[0].plan
                              : '0')),
                        ]),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}


