import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SousGroupeForm extends StatefulWidget {
  @override
  _SousGroupeFormState createState() => _SousGroupeFormState();
}

class _SousGroupeFormState extends State<SousGroupeForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomController = TextEditingController();
  List<String> _selectedParticipants = []; // Liste des participants sélectionnés
  List<Map<String, dynamic>> _participants = []; // Liste des effectifs récupérés

  @override
  void initState() {
    super.initState();
    _fetchParticipants();
  }

  Future<void> fetchParticipantgroupe(String nomGroupe) async {
    final String url = 'http://127.0.0.1:8000/api/sous-groupe/$nomGroupe/';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List participants = data['participants'];

        // Affichage des participants dans un pop-up
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Participants de $nomGroupe'),
              content: Container(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: participants.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('${participants[index]['nom']} ${participants[index]['prenom']}'),
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Fermer'),
                ),
              ],
            );
          },
        );
      } else {
        print('Erreur lors de la récupération des participants: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur: $e');
    }
  }

  Future<void> _fetchParticipants() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/effectif/'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _participants = List<Map<String, dynamic>>.from(data['results']);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du chargement des participants')),
      );
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/groupe/create/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nom': _nomController.text,
          'participants': _selectedParticipants.map((id) => int.parse(id)).toList(),
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sous-groupe créé avec succès')),
        );
        setState(() {
          _nomController.clear();
          _selectedParticipants.clear();
        });
        _formKey.currentState?.reset();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la création du sous-groupe')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Créer un Sous-Groupe',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _nomController,
              decoration: InputDecoration(labelText: 'Nom du Sous-Groupe'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un nom pour le sous-groupe';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                if (_nomController.text.isNotEmpty) {
                  fetchParticipantgroupe(_nomController.text);
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 6),
                width: 90,
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
            Text(
              'Sélectionner des Participants',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            _participants.isEmpty
                ? CircularProgressIndicator()
                : Wrap(
                    spacing: 8.0,
                    children: _participants.map((participant) {
                      return ChoiceChip(
                        label: Text('${participant['nom']} ${participant['prenom']}'),
                        selected: _selectedParticipants.contains(participant['id'].toString()),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedParticipants.add(participant['id'].toString());
                            } else {
                              _selectedParticipants.remove(participant['id'].toString());
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
            SizedBox(height: 20.0),
            GestureDetector(
              onTap: _submitForm,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 6),
                width: 90,
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
          ],
        ),
      ),
    );
  }
}
