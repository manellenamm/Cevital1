import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AfficherForm extends StatefulWidget {
  final void Function(List<Map<String, dynamic>>) Sans_emailChanged;

  const AfficherForm({
    Key? key,
    required this.Sans_emailChanged,
  }) : super(key: key);

  @override
  _AfficherFormState createState() => _AfficherFormState();
}

class _AfficherFormState extends State<AfficherForm> {
  late Future<List<dynamic>> _participantsFuture;

  @override
  void initState() {
    super.initState();
    _participantsFuture = _fetchParticipants();
  }

  Future<List<dynamic>> _fetchParticipants() async {
    final url = 'http://127.0.0.1:8000/participants-with-default-email/';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final participants = data['participants'] ?? [];

      // Stocker les IDs pour tous les participants
      final List<Map<String, dynamic>> participantIds = [];

      if (participants.isNotEmpty) {
        for (var participant in participants) {
          final orienterId = participant['orienter_id'] as String?;
          final participantId = participant['participant_id'] as int?;

          // Ajouter les informations des participants à la liste
          participantIds.add({
            'orienter_id': orienterId,
            'participant_id': participantId,
          });

          // Log des informations des participants
          print('Participant ID: $participantId, Orienter ID: $orienterId');
        }

        // Notifier le parent avec la liste des participants
        widget.Sans_emailChanged(participantIds);
      }

      return participants;
    } else {
      throw Exception('Failed to load participants');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder<List<dynamic>>(
        future: _participantsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucun participant trouvé'));
          }

          final participants = snapshot.data!;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              border: TableBorder.all(color: Colors.grey.withOpacity(0.5)),
              columns: [
                DataColumn(label: Text("Nom")),
                DataColumn(label: Text("Prénom")),
                DataColumn(label: Text("Date de naissance")),
                DataColumn(label: Text("Formation")),
                DataColumn(label: Text("Date début")),
                DataColumn(label: Text("Date fin")),
              ],
              rows: participants.map((participant) {
                final nom = participant['participant_nom'];
                final prenom = participant['participant_prenom'];
                final dateNaissance = participant['date_de_naissance'];
                final formation = participant['formation'];
                final dateDebut = participant['date_debut'];
                final dateFin = participant['date_fin'];

                return DataRow(cells: [
                  DataCell(Text(nom ?? 'Inconnu')),
                  DataCell(Text(prenom ?? 'Inconnu')),
                  DataCell(Text(dateNaissance ?? 'Inconnue')),
                  DataCell(Text(formation ?? 'Inconnue')),
                  DataCell(Text(dateDebut ?? 'Inconnue')),
                  DataCell(Text(dateFin ?? 'Inconnue')),
                ]);
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
