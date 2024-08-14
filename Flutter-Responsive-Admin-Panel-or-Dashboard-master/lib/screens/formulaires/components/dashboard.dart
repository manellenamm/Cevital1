import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DashboardForm extends StatefulWidget {
  @override
  _DashboardFormState createState() => _DashboardFormState();
}

class _DashboardFormState extends State<DashboardForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'prevu_action_formation': '',
    'prevu_effectifs': '',
    'Plan_fromation': '',
    'Plan_effectifs': 0,
    'mois': 1,
    'annee': DateTime.now().year,
  };

  final List<Map<int, String>> moisOptions = [
    {1: 'Janvier'},
    {2: 'Février'},
    {3: 'Mars'},
    {4: 'Avril'},
    {5: 'Mai'},
    {6: 'Juin'},
    {7: 'Juillet'},
    {8: 'Août'},
    {9: 'Septembre'},
    {10: 'Octobre'},
    {11: 'Novembre'},
    {12: 'Décembre'},
  ];

  final _prevuActionFormationController = TextEditingController();
  final _prevuEffectifsController = TextEditingController();
  final _planFormationController = TextEditingController();
  final _planEffectifsController = TextEditingController();
  final _anneeController = TextEditingController(text: DateTime.now().year.toString());

  @override
  void dispose() {
    _prevuActionFormationController.dispose();
    _prevuEffectifsController.dispose();
    _planFormationController.dispose();
    _planEffectifsController.dispose();
    _anneeController.dispose();
    super.dispose();
  }

  void _loadDashboard(int mois, int annee) async {
    print('Chargement du dashboard pour mois: $mois et année: $annee');
    final uri = Uri.parse(
        'http://127.0.0.1:8000/api/filter-dashbaord/?mois=$mois&annee=$annee');
    try {
      final response = await http.get(uri);
      print('Code de statut: ${response.statusCode}');
      print('Réponse du serveur: ${response.body}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['resultats'] as List;
        if (data.isNotEmpty) {
          final dashboardData = data.first;
          setState(() {
            _formData['prevu_action_formation'] =
                dashboardData['prevu_action_formation'];
            _formData['prevu_effectifs'] = dashboardData['prevu_effectifs'];
            _formData['Plan_fromation'] = dashboardData['Plan_fromation'];
            _formData['Plan_effectifs'] = dashboardData['Plan_effectifs'];
            _formData['mois'] = dashboardData['mois'];
            _formData['annee'] = dashboardData['annee'];

            _prevuActionFormationController.text =
                _formData['prevu_action_formation'];
            _prevuEffectifsController.text = _formData['prevu_effectifs'];
            _planFormationController.text = _formData['Plan_fromation'];
            _planEffectifsController.text =
                _formData['Plan_effectifs'].toString();
            _anneeController.text = _formData['annee'].toString();
          });
        }
      } else {
        print('Échec du chargement des données du dashboard');
      }
    } catch (e) {
      print('Erreur: $e');
    }
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/dashboard/create/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(_formData),
      );

      if (response.statusCode == 201) {
        print('Dashboard ajouté');
        _resetForm();
      } else {
        print('Échec de l\'ajout du Dashboard: ${response.reasonPhrase}');
      }
    }
  }
void _updateDashboard(int mois, int annee) async {
  if (_formKey.currentState?.validate() ?? false) {
    _formKey.currentState?.save();
    print('Form Data before update: $_formData');
    final uri = Uri.parse('http://127.0.0.1:8000/dashboard-update/');
    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(_formData),
    );

    if (response.statusCode == 200) {
      print('Dashboard mis à jour');
      print('Données mises à jour: ${response.body}');
      _loadDashboard(mois, annee);  // Recharger les données après mise à jour
    } else {
      print('Échec de la mise à jour du Dashboard: ${response.reasonPhrase}');
    }
  }
}


  void _deleteDashboard(int mois, int annee) async {
  final uri = Uri.parse('http://127.0.0.1:8000/dashboard-delete/$mois/$annee/');
  try {
    final response = await http.delete(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      _showSnackBar(context, 'Dashboard supprimé avec succès');
      _resetForm();
    } else if (response.statusCode == 404) {
      _showSnackBar(context, 'Dashboard non trouvé');
    } else {
      _showSnackBar(context, 'Échec de la suppression du Dashboard: ${response.reasonPhrase}');
    }
  } catch (e) {
    _showSnackBar(context, 'Erreur lors de la suppression du Dashboard: $e');
  }
}

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _resetForm() {
    setState(() {
      _formData['prevu_action_formation'] = '';
      _formData['prevu_effectifs'] = '';
      _formData['Plan_fromation'] = '';
      _formData['Plan_effectifs'] = 0;
      _formData['mois'] = 1;
      _formData['annee'] = DateTime.now().year;

      _prevuActionFormationController.clear();
      _prevuEffectifsController.clear();
      _planFormationController.clear();
      _planEffectifsController.clear();
      _anneeController.text = DateTime.now().year.toString();
    });
    _formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dashboard',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TextFormField(
  decoration: InputDecoration(labelText: 'Prévu Action Formation'),
  controller: _prevuActionFormationController,
  onSaved: (value) => _formData['prevu_action_formation'] = value!,
),
TextFormField(
  decoration: InputDecoration(labelText: 'Prévu Effectifs'),
  controller: _prevuEffectifsController,
  onSaved: (value) => _formData['prevu_effectifs'] = value!,
),
TextFormField(
  decoration: InputDecoration(labelText: 'Plan Formation'),
  controller: _planFormationController,
  onSaved: (value) => _formData['Plan_fromation'] = value!,
),
TextFormField(
  decoration: InputDecoration(labelText: 'Plan Effectifs'),
  keyboardType: TextInputType.number,
  controller: _planEffectifsController,
  onSaved: (value) => _formData['Plan_effectifs'] = int.parse(value!),
),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(labelText: 'Mois'),
                value: _formData['mois'],
                items: moisOptions.map((option) {
                  final month = option.keys.first;
                  final monthName = option[month]!;
                  return DropdownMenuItem<int>(
                    value: month,
                    child: Text(monthName),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _formData['mois'] = value!;
                  });
                },
                onSaved: (value) => _formData['mois'] = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Année'),
                keyboardType: TextInputType.number,
                controller: _anneeController,
                onSaved: (value) => _formData['annee'] = int.parse(value!),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final mois = _formData['mois'];
                  final anneeString = _anneeController.text; // Obtenez la valeur en tant que chaîne
                  final annee = int.tryParse(anneeString) ?? DateTime.now().year; // Convertissez en entier
                  _loadDashboard(mois, annee);
                },
                child: Text('Charger'),
              ),
              SizedBox(height: 16),
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Ajouter'),
                style: ElevatedButton.styleFrom(
            primary: Colors.blue,)
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final mois = _formData['mois'];
                  final anneeString = _anneeController.text;
                  final annee = int.tryParse(anneeString) ?? DateTime.now().year;
                  _updateDashboard(mois, annee);
                },
                child: Text('Mettre à jour'),
              
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final mois = _formData['mois'];
                  final anneeString = _anneeController.text;
                  final annee = int.tryParse(anneeString) ?? DateTime.now().year;
                  _deleteDashboard(mois, annee);
                },
                child: Text('Supprimer'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red, )//
              ),
              ]
              )
            ],
          ),
        ),
      ),
    );
  }
}
