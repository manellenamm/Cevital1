import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DashboardBudjetsForm extends StatefulWidget {
  @override
  _DashboardBudjetsFormState createState() => _DashboardBudjetsFormState();
}

class _DashboardBudjetsFormState extends State<DashboardBudjetsForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'realise': '',
    'Prevu': '',
    'Plan': '',
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

  final _realiseController = TextEditingController();
  final _prevuController = TextEditingController();
  final _planController = TextEditingController();
  final _anneeController = TextEditingController(text: DateTime.now().year.toString());

  @override
  void dispose() {
    _realiseController.dispose();
    _prevuController.dispose();
    _planController.dispose();
    _anneeController.dispose();
    super.dispose();
  }



  void _loadDashboard(int mois, int annee) async {
  print('Chargement du dashboard pour mois: $mois et année: $annee');
  final uri = Uri.parse(
      'http://127.0.0.1:8000/api/filter-budjets/?mois=$mois&annee=$annee');
  try {
    final response = await http.get(uri);
    print('Code de statut: ${response.statusCode}');
    print('Réponse du serveur: ${response.body}');
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['resultats'] as List;
      if (data.isNotEmpty) {
        final dashboardData = data.first;
        setState(() {
          _formData['realise'] = dashboardData['realise'];
          _formData['Prevu'] = dashboardData['Prevu'];
          _formData['Plan'] = dashboardData['Plan'];
          _formData['mois'] = dashboardData['mois'];
          _formData['annee'] = dashboardData['annee'];

          _realiseController.text = _formData['realise'];
          _prevuController.text = _formData['Prevu'];
          _planController.text = _formData['Plan'];
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
      Uri.parse('http://127.0.0.1:8000/api/dashboardbudjet/create/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(_formData),
    );

    if (response.statusCode == 201) {
      print('Dashboard ajouté');
      _resetForm(); // Réinitialiser les champs après ajout
    } else {
      print('Échec de l\'ajout du Dashboard: ${response.reasonPhrase}');
    }
  }
}

void _updateDashboard(int mois, int annee) async {
  if (_formKey.currentState?.validate() ?? false) {
    _formKey.currentState?.save();
    print('Form Data before update: $_formData');
    final uri = Uri.parse('http://127.0.0.1:8000/dashboardBudjet-update/');
    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(_formData),
    );

    if (response.statusCode == 200) {
      print('Dashboard mis à jour');
      print('Données mises à jour: ${response.body}');
      _loadDashboard(mois, annee);  // Recharger les données après mise à jour
       _resetForm(); // Réinitialiser les champs après mise à jour
    } else {
      print('Échec de la mise à jour du Dashboard: ${response.reasonPhrase}');
    }
 
  }
}

void _deleteDashboard(int mois, int annee) async {
  final uri = Uri.parse('http://127.0.0.1:8000/dashboardbudjet-delete/$mois/$annee/');
  try {
    final response = await http.delete(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      _showSnackBar(context, 'Dashboard supprimé avec succès');
        _resetForm(); // Réinitialiser les champs après mise à jour
      
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
    _formData['realise'] = '';
    _formData['Prevu'] = '';
    _formData['Plan'] = '';
    _formData['mois'] = 1;
    _formData['annee'] = DateTime.now().year;

    _realiseController.clear();
    _prevuController.clear();
    _planController.clear();
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
                'Dashboard Budjet',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Réalisé'),
                controller: _realiseController,
                onSaved: (value) => _formData['realise'] = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Prévu'),
                controller: _prevuController,
                onSaved: (value) => _formData['Prevu'] = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Plan'),
                controller: _planController,
                onSaved: (value) => _formData['Plan'] = value!,
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
              ElevatedButton(
                onPressed: () {
                  final mois = _formData['mois'];
                  final anneeString = _anneeController.text; // Obtenez la valeur en tant que chaîne
                  final annee = int.tryParse(anneeString) ?? DateTime.now().year; // Convertissez en entier
                  _loadDashboard(mois, annee);
                  
                },
                child: Text('Charger'),
                    style: ElevatedButton.styleFrom(
            primary: Colors.green) 
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Ajouter'),
                    style: ElevatedButton.styleFrom(
            primary: Colors.blue) 
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final mois = _formData['mois'];
                       final anneeString = _anneeController.text;
                  final annee = int.tryParse(anneeString) ?? DateTime.now().year;
                  _updateDashboard(mois, annee);
                    },
                    child: Text('Mettre à jour'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final mois = _formData['mois'];
                       final anneeString = _anneeController.text;
                  final annee = int.tryParse(anneeString) ?? DateTime.now().year;
                  _deleteDashboard(mois, annee);
                    },
                    child: Text('Supprimer'),
                        style: ElevatedButton.styleFrom(
            primary: Colors.red) 
                  ),
                ],
              ),
              SizedBox(height: 16),
              
            ],
          ),
        ),
      ),
    );
  }
}
