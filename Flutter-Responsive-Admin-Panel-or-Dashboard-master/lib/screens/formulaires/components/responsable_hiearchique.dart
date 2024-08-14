import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ResponsableForm extends StatefulWidget {
  @override
  _ResponsableFormState createState() => _ResponsableFormState();
}

class _ResponsableFormState extends State<ResponsableForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _matriculeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  DateTime? _selectedDate;

  // Fonction pour soumettre le formulaire
  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final Map<String, dynamic> formData = {
        'nom': _nomController.text,
        'prenom': _prenomController.text,
        'matricule': _matriculeController.text,
        'email': _emailController.text,
        'date_de_naissance': _selectedDate != null
            ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
            : null,
      };

      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/responsable/create/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(formData),
      );

      if (response.statusCode == 201) {
        print('Responsable added');
        _resetForm();
      } else {
        print('Failed to add Responsable');
      }
    }
  }

  // Fonction pour charger les informations du Responsable
  void _loadResponsable(String matricule) async {
    final matriculeInt = int.tryParse(matricule);

    if (matriculeInt == null) {
      print('Le matricule doit être un nombre entier valide');
      return;
    }

    print('Envoi de la requête pour le matricule: $matriculeInt');

    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/responsable/$matriculeInt/'),
      );

      print('Code de statut de la réponse: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _nomController.text = data['nom'] ?? '';
          _prenomController.text = data['prenom'] ?? '';
          _matriculeController.text = data['matricule']?.toString() ?? '';
          _emailController.text = data['email'] ?? '';
          _selectedDate = data['date_de_naissance'] != null
              ? DateTime.parse(data['date_de_naissance'])
              : null;
        });

        print('Données mises à jour dans le formulaire: ${data}');
      } else {
        print('Échec du chargement du Responsable');
        print('Corps de la réponse en cas d\'erreur: ${response.body}');
      }
    } catch (e) {
      print('Erreur: $e');
    }
  }

  // Fonction pour mettre à jour les informations du Responsable
  void _updateResponsable() async {
    final matriculeInt = int.tryParse(_matriculeController.text);
    if (matriculeInt == null) {
      print('Le matricule doit être un nombre entier valide');
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      final Map<String, dynamic> formData = {
        'nom': _nomController.text,
        'prenom': _prenomController.text,
        'matricule': _matriculeController.text,
        'email': _emailController.text,
        'date_de_naissance': _selectedDate != null
            ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
            : null,
      };

      final response = await http.put(
        Uri.parse('http://127.0.0.1:8000/responsable/update/$matriculeInt/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(formData),
      );

      if (response.statusCode == 200) {
        print('Responsable updated');
        _resetForm();
      } else {
        print('Failed to update Responsable');
      }
    }
  }

  // Fonction pour supprimer un Responsable
  void _deleteResponsable(BuildContext context) async {
    final matriculeInt = int.tryParse(_matriculeController.text);
    if (matriculeInt == null) {
      print('Le matricule doit être un nombre entier valide');
      return;
    }

    final response = await http.delete(
      Uri.parse('http://127.0.0.1:8000/responsable/delete/$matriculeInt/'),
    );

    if (response.statusCode == 200) {
      _showSnackBar(context, 'Ce responsable a été supprimé');
      _resetForm();
    } else {
      _showSnackBar(context, 'Échec de la suppression du responsable');
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Fonction pour réinitialiser le formulaire
  void _resetForm() {
    setState(() {
      _nomController.clear();
      _prenomController.clear();
      _matriculeController.clear();
      _emailController.clear();
      _selectedDate = null;
    });
    _formKey.currentState?.reset();
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _matriculeController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // Sélectionner la date de naissance
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
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
                'Responsable Hiéarchique ',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
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
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  final matricule = _matriculeController.text;
                  if (matricule.isNotEmpty) {
                    _loadResponsable(matricule);
                  } else {
                    print('Le matricule ne doit pas être vide');
                  }
                }
              },
              child: Text('Charger '),
                 style: ElevatedButton.styleFrom(
            primary: Colors.green) 
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Nom'),
              controller: _nomController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un nom';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Prénom'),
              controller: _prenomController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un prénom';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Email'),
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un email';
                }
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Veuillez entrer un email valide';
                }
                return null;
              },
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Text(
                  _selectedDate == null
                      ? 'Sélectionner Date de Naissance'
                      : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ],
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
                  onPressed: _updateResponsable,
                  child: Text('Mettre à jour '),
                ),
                ElevatedButton(
                  onPressed: () => _deleteResponsable(context),
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
