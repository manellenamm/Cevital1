import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EffectifForm extends StatefulWidget {
  @override
  _EffectifFormState createState() => _EffectifFormState();
}

class _EffectifFormState extends State<EffectifForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'nom': '',
    'prenom': '',
    'date_de_naissance': '',
    'matricule': '',
    'structure': '',
    'service': '',
    'email': '',
    'fonction': '',
    'pole': '',
    'csp': '',
  };

  List<Map<String, String>> cspOptions = [
    {'value': 'cadre', 'label': 'Cadre'},
    {'value': 'maitrise', 'label': 'Maitrise'},
    {'value': 'execution', 'label': 'Exécution'},
  ];

  void _loadEffectif(String matricule) async {
    final matriculeInt = int.tryParse(matricule);

    if (matriculeInt == null) {
      print('Le matricule doit être un nombre entier valide');
      return;
    }

    print('Envoi de la requête pour le matricule: $matriculeInt');

    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/effectif/$matriculeInt/'),
      );

      print('Code de statut de la réponse: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _formData['nom'] = data['nom'] ?? '';
          _formData['prenom'] = data['prenom'] ?? '';
          _formData['date_de_naissance'] = data['date_de_naissance'] ?? '';
          _formData['matricule'] = data['matricule']?.toString() ?? '';
          _formData['structure'] = data['structure'] ?? '';
          _formData['service'] = data['service'] ?? '';
          _formData['email'] = data['email'] ?? '';
          _formData['fonction'] = data['fonction'] ?? '';
          _formData['pole'] = data['pole'] ?? '';
          _formData['csp'] = data['csp'] ?? ''; // Assurez-vous que cette valeur est bien reçue

          // Mettre à jour les contrôleurs avec les nouvelles données
          _nomController.text = _formData['nom'];
          _prenomController.text = _formData['prenom'];
          _dateDeNaissanceController.text = _formData['date_de_naissance'];
          _structureController.text = _formData['structure'];
          _serviceController.text = _formData['service'];
          _emailController.text = _formData['email'];
          _fonctionController.text = _formData['fonction'];
          _poleController.text = _formData['pole'];
        });

        print('Données mises à jour dans le formulaire: $_formData');
      } else {
        print('Échec du chargement de l\'Effectif');
        print('Corps de la réponse en cas d\'erreur: ${response.body}');
      }
    } catch (e) {
      print('Erreur: $e');
    }
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _dateDeNaissanceController.dispose();
    _structureController.dispose();
    _serviceController.dispose();
    _emailController.dispose();
    _fonctionController.dispose();
    _poleController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/effectif/create/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(_formData),
      );

      if (response.statusCode == 201) {
        print('Effectif added');
        _resetForm(); 
      } else {
        print('Failed to add Effectif');
      }
    }
  }

  void _updateEffectif() async {
    final matriculeInt = int.tryParse(_formData['matricule'] ?? '');
    if (matriculeInt == null) {
      print('Le matricule doit être un nombre entier valide');
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
     final response = await http.put(
  Uri.parse('http://127.0.0.1:8000/api/effectif/update/$matriculeInt/'),
  headers: {'Content-Type': 'application/json'},
  body: json.encode(_formData),
);

      if (response.statusCode == 200) {
        print('Effectif updated');
        _resetForm(); 
      } else {
        print('Failed to update Effectif');
      }
    }
  }

  void _deleteEffectif(BuildContext context) async {
  final matriculeInt = int.tryParse(_formData['matricule'] ?? '');
  if (matriculeInt == null) {
    print('Le matricule doit être un nombre entier valide');
    return;
  }

  final response = await http.delete(
    Uri.parse('http://127.0.0.1:8000/api/effectif/delete/$matriculeInt/'),
  );

  if (response.statusCode == 200) {
    _showSnackBar(context, 'Ce participant a été supprimé');
    _resetForm();
  } else {
    _showSnackBar(context, 'Échec de la suppression du participant');
  }
}

void _showSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
  // Création des contrôleurs pour chaque champ
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _dateDeNaissanceController = TextEditingController();
  final _structureController = TextEditingController();
  final _serviceController = TextEditingController();
  final _emailController = TextEditingController();
  final _fonctionController = TextEditingController();
  final _poleController = TextEditingController();

  void _resetForm() {
    setState(() {
      _formData['nom'] = '';
      _formData['prenom'] = '';
      _formData['date_de_naissance'] = '';
      _formData['matricule'] = '';
      _formData['structure'] = '';
      _formData['service'] = '';
      _formData['email'] = '';
      _formData['fonction'] = '';
      _formData['pole'] = '';
      _formData['csp'] = '';
    });
    _formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Effectif',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(labelText: 'Matricule'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un matricule';
                }
                if (int.tryParse(value) == null) {
                  return 'Le matricule doit être un nombre entier';
                }
                return null;
              },
              onSaved: (value) => _formData['matricule'] = value ?? '',
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  _formKey.currentState?.save();

                  final matricule = _formData['matricule'] ?? '';
                  if (matricule.isNotEmpty) {
                    _loadEffectif(matricule);
                  } else {
                    print('Le matricule ne doit pas être vide');
                  }
                }
              },
              child: Text('Charger Effectif'),
               style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                    ),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Nom'),
              controller: _nomController,
              onSaved: (value) => _formData['nom'] = value ?? '',
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Prénom'),
              controller: _prenomController,
              onSaved: (value) => _formData['prenom'] = value ?? '',
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Date de Naissance'),
              controller: _dateDeNaissanceController,
              keyboardType: TextInputType.datetime,
              onSaved: (value) => _formData['date_de_naissance'] = value ?? '',
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Structure'),
              controller: _structureController,
              onSaved: (value) => _formData['structure'] = value ?? '',
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Service'),
              controller: _serviceController,
              onSaved: (value) => _formData['service'] = value ?? '',
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Email'),
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              onSaved: (value) => _formData['email'] = value ?? '',
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Fonction'),
              controller: _fonctionController,
              onSaved: (value) => _formData['fonction'] = value ?? '',
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Pôle'),
              controller: _poleController,
              onSaved: (value) => _formData['pole'] = value ?? '',
            ),
             DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'CSP'),
              value: _formData['csp']?.isEmpty ?? true
                  ? null
                  : _formData['csp'],
              items: cspOptions
                  .map((option) => DropdownMenuItem<String>(
                        value: option['value'],
                        child: Text(option['label']!),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _formData['csp'] = value ?? '';
                });
              },
              onSaved: (value) => _formData['csp'] = value ?? '',
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Ajouter '),
                      style: ElevatedButton.styleFrom(
            primary: Colors.blue) 
                ),
                ElevatedButton(
                  onPressed: _updateEffectif,
                  child: Text('Mettre à jour'),
                ),
                ElevatedButton(
  onPressed: () => _deleteEffectif(context),
  child: Text('Supprimer'),
      style: ElevatedButton.styleFrom(
            primary: Colors.red) 
),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
