import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FormationForm extends StatefulWidget {
  @override
  _FormationFormState createState() => _FormationFormState();
}

class _FormationFormState extends State<FormationForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'intitule': '',
    'formateur': '', // ID du formateur sélectionné
  };

  List<Map<String, dynamic>> _formateurs = [];
  String? _selectedFormateur;
  String? _formationIntitule; // Pour spécifier l'intitulé de la formation à mettre à jour ou à supprimer

  @override
  void initState() {
    super.initState();
    _fetchFormateurs();
  }

  Future<void> _fetchFormateurs() async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/formateurs/'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> formateursJson = data['results'];
      setState(() {
        _formateurs = formateursJson.map((json) => json as Map<String, dynamic>).toList();
      });
    } else {
      print('Failed to load formateurs');
    }
  }

  Future<void> _fetchFormationByIntitule(String intitule) async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/formation/$intitule/'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _formData['intitule'] = data['intitule'];
        _selectedFormateur = data['formateur'].toString();
        _formData['formateur'] = data['formateur'].toString();
      });
      print('Formation details fetched');
    } else {
      print('Failed to fetch Formation: ${response.reasonPhrase}');
    }
  }

  void _updateFormation(String intitule) async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      final response = await http.put(
        Uri.parse('http://127.0.0.1:8000/api/update-formation/$intitule/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(_formData),
      );

      if (response.statusCode == 200) {
        print('Formation updated');
        setState(() {
          _formData['intitule'] = '';
          _formData['formateur'] = '';
          _selectedFormateur = null;
        });
        _formKey.currentState?.reset();
      } else {
        print('Failed to update Formation: ${response.reasonPhrase}');
      }
    }
  }

  void _deleteFormation(String intitule) async {
    final response = await http.delete(
      Uri.parse('http://127.0.0.1:8000/api/delete-formation/$intitule/'),
    );

    if (response.statusCode == 204) { // No Content
      print('Formation deleted');
      setState(() {
        _formData['intitule'] = '';
        _formData['formateur'] = '';
        _selectedFormateur = null;
      });
      _formKey.currentState?.reset();
    } else {
      print('Failed to delete Formation: ${response.reasonPhrase}');
    }
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/formation/create/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(_formData),
      );

      if (response.statusCode == 201) {
        print('Formation added');
        setState(() {
          _formData['intitule'] = '';
          _formData['formateur'] = '';
          _selectedFormateur = null;
        });
        _formKey.currentState?.reset();
      } else {
        print('Failed to add Formation: ${response.reasonPhrase}');
      }
    }
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
              'Gestion des Formations',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(labelText: 'Intitulé de la Formation à récupérer'),
              onChanged: (value) => _formationIntitule = value,
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                if (_formationIntitule != null && _formationIntitule!.isNotEmpty) {
                  _fetchFormationByIntitule(_formationIntitule!);
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical:6),
                width: 90, // Ajustez la largeur du bouton ici
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Text(
                    'Charger',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Sélectionnez un Formateur'),
              value: _selectedFormateur,
              items: _formateurs.map((formateur) {
                return DropdownMenuItem<String>(
                  value: formateur['id'].toString(),
                  child: Text('${formateur['nom']} ${formateur['prenom']}'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedFormateur = value;
                  _formData['formateur'] = value!;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez sélectionner un formateur';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    if (_formData['intitule'] != null && _formData['intitule']!.isNotEmpty) {
                      _submitForm();
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Text(
                        'Ajouter',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (_formationIntitule != null && _formationIntitule!.isNotEmpty) {
                      _updateFormation(_formationIntitule!);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Text(
                        'Mettre à jour',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (_formationIntitule != null && _formationIntitule!.isNotEmpty) {
                      _deleteFormation(_formationIntitule!);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Text(
                        'Supprimer',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
