import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FormateurForm extends StatefulWidget {
  @override
  _FormateurFormState createState() => _FormateurFormState();
}

class _FormateurFormState extends State<FormateurForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'nom': '',
    'prenom': '',
    'matricule': '',
    'date_de_naissance': '',
  };

  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _matriculeController = TextEditingController();
  final TextEditingController _dateDeNaissanceController = TextEditingController();
  DateTime? _selectedDate;

  void _loadFormateur(String matricule) async {
    final matriculeInt = int.tryParse(matricule);

    if (matriculeInt == null) {
      print('Le matricule doit être un nombre entier valide');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/formateur/$matriculeInt/'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _formData['nom'] = data['nom'] ?? '';
          _formData['prenom'] = data['prenom'] ?? '';
          _formData['matricule'] = data['matricule']?.toString() ?? '';
          _formData['date_de_naissance'] = data['date_de_naissance'] ?? '';

          // Mettre à jour les contrôleurs avec les nouvelles données
          _nomController.text = _formData['nom'];
          _prenomController.text = _formData['prenom'];
          _matriculeController.text = _formData['matricule'];
          _dateDeNaissanceController.text = _formData['date_de_naissance'];
        });
      } else {
        print('Échec du chargement du Formateur');
      }
    } catch (e) {
      print('Erreur: $e');
    }
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/formateur/create/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(_formData),
      );

      if (response.statusCode == 201) {
        print('Formateur added');
        _resetForm();
      } else {
        print('Failed to add Formateur');
      }
    }
  }

  void _updateFormateur() async {
    final matriculeInt = int.tryParse(_formData['matricule'] ?? '');
    if (matriculeInt == null) {
      print('Le matricule doit être un nombre entier valide');
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      final response = await http.put(
        Uri.parse('http://127.0.0.1:8000/formateur/update/$matriculeInt/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(_formData),
      );

      if (response.statusCode == 200) {
        print('Formateur updated');
        _resetForm();
      } else {
        print('Failed to update Formateur');
      }
    }
  }

  void _deleteFormateur(BuildContext context) async {
    final matriculeInt = int.tryParse(_formData['matricule'] ?? '');
    if (matriculeInt == null) {
      print('Le matricule doit être un nombre entier valide');
      return;
    }

    final response = await http.delete(
      Uri.parse('http://127.0.0.1:8000/formateur/delete/$matriculeInt/'),
    );

    if (response.statusCode == 200) {
      _showSnackBar(context, 'Le formateur a été supprimé');
      _resetForm();
    } else {
      _showSnackBar(context, 'Échec de la suppression du formateur');
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _resetForm() {
    setState(() {
      _formData['nom'] = '';
      _formData['prenom'] = '';
      _formData['matricule'] = '';
      _formData['date_de_naissance'] = '';
    });
    _formKey.currentState?.reset();
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _matriculeController.dispose();
    _dateDeNaissanceController.dispose();
    super.dispose();
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
                'Formateur',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(labelText: 'Matricule'),
              controller: _matriculeController,
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
                    _loadFormateur(matricule);
                  } else {
                    print('Le matricule ne doit pas être vide');
                  }
                }
              },
              child: Text('Charger Formateur'),
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
            SizedBox(height: 16.0),
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
                  onPressed: _updateFormateur,
                  child: Text('Mettre à jour'),
                ),
                ElevatedButton(
                  onPressed: () => _deleteFormateur(context),
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
