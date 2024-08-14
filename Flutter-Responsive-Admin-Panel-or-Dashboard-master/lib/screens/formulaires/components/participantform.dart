import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ParticipantFormationForm extends StatefulWidget {
  @override
  _ParticipantFormationFormState createState() =>
      _ParticipantFormationFormState();
}

class _ParticipantFormationFormState extends State<ParticipantFormationForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'participant': '',
    'orientation': '',
    'presence': false,
    'etat': '',
  };

  List<String> etatOptions = ['réalisée', 'reportée', 'annulée'];
  List<Map<String, dynamic>> _orientations = [];
  List<Map<String, dynamic>> _participants = [];
  List<Map<String, dynamic>> _filteredResults = [];
  String? _selectedOrientation;

  @override
  void initState() {
    super.initState();
    _fetchOrientations();
  }

  Future<void> _fetchOrientations() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/api/orienter/list/'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      setState(() {
        _orientations = data.cast<Map<String, dynamic>>();
        if (_orientations.isNotEmpty) {
          _selectedOrientation = _orientations[0]['id'].toString();
          _fetchParticipants(_selectedOrientation!);
        }
      });
    } else {
      print('Failed to load orientations');
    }
  }

  Future<void> _fetchParticipants(String orientationId) async {
    final response = await http.get(Uri.parse(
        'http://127.0.0.1:8000/api/orientation/$orientationId/participants/'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['participants'];
      setState(() {
        _participants = data.cast<Map<String, dynamic>>();
      });
    } else {
      print('Failed to load participants');
    }
  }
  
 void _updateParticipantFormation() async {
    final participantId = _formData['participant'];
    final orientationId = _formData['orientation'];

    if (participantId == null || orientationId == null) {
      print('Les identifiants participant ou orientation sont manquants');
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      final Map<String, dynamic> updateData = {
        'participant_id': participantId,
        'orientation_id': orientationId,
        'presence': _formData['presence'],
        'etat': _formData['etat'],
      };

      final response = await http.put(
        Uri.parse('http://127.0.0.1:8000/api/update-participant-formation/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updateData),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('ParticipantFormation updated');
        print('Updated data: ${responseData['updated_data']}');
        _resetForm();
      } else {
        print('Failed to update ParticipantFormation');
        print(response.body);
      }
    }
  }

void _deleteParticipantFormation(BuildContext context) async {
  final participantId = _formData['participant'];
  final orientationId = _formData['orientation'];

  if (participantId == null || orientationId == null) {
    print('Les identifiants participant ou orientation sont manquants');
    return;
  }

  final response = await http.delete(
    Uri.parse(
        'http://127.0.0.1:8000/api/delete-participant-formation/$participantId/$orientationId/'),
  );

  if (response.statusCode == 204) { // Vérifiez que le code de statut est 204 No Content
    _showSnackBar(context, 'Ce participant a été supprimé');
    _resetForm();
  } else {
    _showSnackBar(context, 'Échec de la suppression du participant');
    print(response.body);
  }
}

void _showSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

 void _filterParticipantFormation(String orientationId, String participantId) async {
  final uri = Uri.parse(
      'http://127.0.0.1:8000/api/filter-participant-formation/?orientation_id=$orientationId&participant_id=$participantId');
  try {
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['resultats'];
      setState(() {
        _filteredResults = data.cast<Map<String, dynamic>>();
        if (_filteredResults.isNotEmpty) {
          _formData['presence'] = _filteredResults[0]['presence'];
          _formData['etat'] = _filteredResults[0]['etat'];
        } else {
          // Affiche un message lorsque le participant n'existe pas
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ce participant n\'existe pas.'),
              backgroundColor: Colors.red,
            ),
          );
          // Réinitialiser les valeurs du formulaire si nécessaire
          _formData['presence'] = false;
          _formData['etat'] = '';
        }
      });
      print(_formData['presence']);
      print(_formData['etat']);
    } else {
      print('Échec du chargement des résultats');
    }
  } catch (e) {
    print('Erreur: $e');
  }
}

  
  void _resetForm() {
  setState(() {
    _formData['participant'] = '';
    _formData['orientation'] = _orientations.isNotEmpty
        ? _orientations[0]['id'].toString()
        : '';
    _formData['presence'] = false;
    _formData['etat'] = '';

    _selectedOrientation = _orientations.isNotEmpty
        ? _orientations[0]['id'].toString()
        : null;

    _participants = [];
    _filteredResults = [];
  });

  _formKey.currentState?.reset();
}

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      try {
        print('Form data: $_formData');

        final String? participantId = _formData['participant'];
        final String? orientationId = _formData['orientation'];

        if (participantId == null || orientationId == null) {
          print('Invalid participant or orientation ID');
          throw Exception("Invalid participant or orientation ID");
        }

        final Map<String, dynamic> postData = {
          'participant': participantId,
          'orientation': orientationId,
          'presence': _formData['presence'],
          'etat': _formData['etat'],
        };

        print('Sending data: $postData');

        final response = await http.post(
          Uri.parse('http://127.0.0.1:8000/api/participant_formation/create/'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(postData),
        );

        if (response.statusCode == 201) {
          print('ParticipantFormation added');
          _resetForm(); // Réinitialiser le formulaire après l'ajout réussi
        } else {
          print('Failed to add ParticipantFormation');
          print(response.body); // Affiche les détails de l'erreur
        }
      } catch (e) {
        print('Error submitting form: $e');
      }
    }
  }

  void _onChargerButtonPressed() {
    // Ajoutez ici la logique à exécuter lorsque le bouton "Charger" est pressé
    // Par exemple, vous pouvez recharger les données ou effectuer d'autres actions.
    if (_formData['participant'].isNotEmpty && _formData['orientation'].isNotEmpty) {
      _filterParticipantFormation(
        _formData['orientation']!,
        _formData['participant']!,
      );
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Présence des participants',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Orientation ID'),
                value: _selectedOrientation,
                items: _orientations.map((orientation) {
                  return DropdownMenuItem<String>(
                    value: orientation['id'].toString(),
                    child: Text(
                      '${orientation['formation']['intitule']} - ${orientation['date_debut']['date']} - ${orientation['date_fin']['date']}',
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedOrientation = value;
                    _formData['orientation'] = value!;
                    _fetchParticipants(_selectedOrientation!);
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez sélectionner une orientation';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Participant'),
                value: _formData['participant'].isNotEmpty
                    ? _formData['participant']
                    : null,
                items: _participants.map((participant) {
                  return DropdownMenuItem<String>(
                    value: participant['id'].toString(),
                    child:
                        Text('${participant['nom']} ${participant['prenom']}'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _formData['participant'] = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez sélectionner un participant';
                  }
                  return null;
                },
              ),
             Row(
  children: [
    Text('Présence'),
    Checkbox(
      value: _formData['presence'] as bool, // Assurez-vous que c'est bien un bool
      onChanged: (bool? value) {
        setState(() {
          _formData['presence'] = value!;
        });
      },
    ),
  ],
),
             DropdownButtonFormField<String>(
  decoration: InputDecoration(labelText: 'État de la Formation'),
  value: _formData['etat'].isNotEmpty ? _formData['etat'] : null,
  items: etatOptions.map((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }).toList(),
  onChanged: (String? value) {
    setState(() {
      _formData['etat'] = value!;
    });
  },
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez sélectionner un état';
    }
    return null;
  },
),
              SizedBox(height: 20),
              Row(
                children: [
                  GestureDetector(
                    onTap: _onChargerButtonPressed,
                    child: Container(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    width : 90 ,
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
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Ajouter'),
                  ),
                   SizedBox(width: 16),
                  ElevatedButton(
                  onPressed:  _updateParticipantFormation,
                  child: Text('Mettre à jour '),
                ),
                 SizedBox(width: 16),
                   ElevatedButton(
                    onPressed: () => _deleteParticipantFormation(context),
                    child: Text('Supprimer'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                    ),
                   )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
