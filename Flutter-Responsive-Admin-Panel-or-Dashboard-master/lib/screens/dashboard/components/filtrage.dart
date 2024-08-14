import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../constants.dart'; // Assurez-vous d'importer votre fichier de constantes
import 'participant.dart'; // Importer la page des participants

class FilterForm extends StatefulWidget {
  @override
  _FilterFormState createState() => _FilterFormState();
}

class _FilterFormState extends State<FilterForm> {
  String? _selectedStructure;
  String? _selectedPole;
  String? _selectedMonth; // Variable pour le mois sélectionné
  List<dynamic> _results = [];

  final List<String> _structures = [
    'APPROS/ACHAT', 'CDH', 'CDS', 'COMMERCIALE', 'CRUSHING PLANT', 
    'DCH', 'DFS', 'DIRECTION EXCELLENCE OPERATIONNELLE', 'DOP', 
    'DRH', 'DSI', 'ENERGIE', 'ENGINEERING COPRS GRAS', 'ENGINEERING POLR SUCRE', 
    'HSE', 'MAINTENANCE OPERATIONNELLE', 'MARGARINERIE', 'Qualité MANAG SYSTEME', 
    'RAF DE SUCRES 3000T', 'Rafinnerie de sucre 3500T', 'Rafinnerie de huile', 
    'Rafinerie sucres speciaux', 'Sucres Speciaux', 'Supply Chain', 
    'Unite elkseur', 'Unite four a chaux', 'Unite lala khdidja', 'Unite Plasturgie'
  ];

  final List<String> _poles = [
    'Boissons', 'Corps Gras', 'Crushing Plant', 'Direction Support', 'Sucres'
  ];

  final List<String> _months = [
    'janvier', 'février', 'mars', 'avril', 'mai', 'juin', 
    'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'
  ]; // Liste des mois

  Future<void> _fetchData() async {
    if (_selectedStructure == null || _selectedPole == null || _selectedMonth == null) {
      return; // Ne rien faire si aucune sélection n'est effectuée
    }
    
    final url = 'http://127.0.0.1:8000/filter/?structure=$_selectedStructure&pole=$_selectedPole&month=$_selectedMonth';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _results = data['results'] ?? []; // Gérer les résultats nuls
      });
    } else {
      throw Exception('Échec du chargement des données');
    }
  }

  Future<List<dynamic>> _fetchParticipants(String orientationId) async {
    final url = 'http://127.0.0.1:8000/participants/$orientationId/';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'] ?? []; // Gérer les résultats nuls
    } else {
      throw Exception('Échec du chargement des participants');
    }
  }

  void _showParticipants(String orientationId) async {
    final participants = await _fetchParticipants(orientationId);
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ParticipantsPage(participants: participants);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Filtrer les Formations",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Row(
            children: [
             Flexible(
  child: DropdownButtonFormField<String>(
    value: _selectedStructure,
    isExpanded: true, // S'assure que le Dropdown prend tout l'espace disponible
    hint: Text('Sélectionner Structure'),
    items: _structures.map((structure) {
      return DropdownMenuItem<String>(
        value: structure,
        child: Text(structure),
      );
    }).toList(),
    onChanged: (value) {
      setState(() {
        _selectedStructure = value;
        _selectedPole = null; // Réinitialiser la sélection du pôle lors du changement de structure
        _selectedMonth = null; // Réinitialiser la sélection du mois lors du changement de structure
      });
    },
    decoration: InputDecoration(
      border: OutlineInputBorder(),
    ),
  ),
),
SizedBox(width: 16), // Espacement entre les dropdowns
Flexible(
  child: DropdownButtonFormField<String>(
    value: _selectedPole,
    isExpanded: true, // S'assure que le Dropdown prend tout l'espace disponible
    hint: Text('Sélectionner Pôle'),
    items: _poles.map((pole) {
      return DropdownMenuItem<String>(
        value: pole,
        child: Text(pole),
      );
    }).toList(),
    onChanged: (value) {
      setState(() {
        _selectedPole = value;
        _selectedMonth = null; // Réinitialiser la sélection du mois lors du changement de pôle
      });
    },
    decoration: InputDecoration(
      border: OutlineInputBorder(),
    ),
  ),
),
SizedBox(width: 16), // Espacement entre les dropdowns
Flexible(
  child: DropdownButtonFormField<String>(
    value: _selectedMonth,
    isExpanded: true, // S'assure que le Dropdown prend tout l'espace disponible
    hint: Text('Sélectionner Mois'),
    items: _months.map((month) {
      return DropdownMenuItem<String>(
        value: month,
        child: Text(month),
      );
    }).toList(),
    onChanged: (value) {
      setState(() {
        _selectedMonth = value;
      });
    },
    decoration: InputDecoration(
      border: OutlineInputBorder(),
    ),
  ),
),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _fetchData,
            child: Text('Filtrer'),
            style: ElevatedButton.styleFrom(
              primary: Colors.yellow.withOpacity(0.8), // Couleur d'arrière-plan jaune
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: DataTable(
              border: TableBorder.all(color: Colors.grey.withOpacity(0.5)), // Couleur de la bordure
              columnSpacing: defaultPadding,
              columns: [
                DataColumn(label: Text("Formation")),
                DataColumn(label: Text("Début")),
                DataColumn(label: Text("Fin")),
              ],
              rows: _results.map((orienter) {
                final formation = orienter['formation'];
                final dateDebut = orienter['date_debut'];
                final dateFin = orienter['date_fin'];

                return DataRow(cells: [
                  DataCell(
                    Container(
                      child: GestureDetector(
                        onTap: () {
                          // Afficher la modal bottom sheet pour ParticipantsPage
                          if (orienter != null && orienter['id'] != null) {
                            _showParticipants(orienter['id'].toString());
                          } else {
                            print('Orientation ou ID est null');
                          }
                        },
                        child: Text(formation != null ? formation['intitule'] ?? 'Formation inconnue' : 'Formation inconnue'),
                      ),
                    ),
                  ),
                  DataCell(
                    Container(
                      child: Text(dateDebut != null ? dateDebut['date'] ?? 'Date de début inconnue' : 'Date de début inconnue'),
                    ),
                  ),
                  DataCell(
                    Container(
                      child: Text(dateFin != null ? dateFin['date'] ?? 'Date de fin inconnue' : 'Date de fin inconnue'),
                    ),
                  ),
                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
