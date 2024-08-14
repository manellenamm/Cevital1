import 'package:flutter/material.dart';
import '../../../constants.dart'; // Ensure to import your constants file

class ParticipantsPage extends StatelessWidget {
  final List<dynamic> participants;

  ParticipantsPage({required this.participants});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF014F8F), // Set background color to blue
      padding: EdgeInsets.all(defaultPadding), // Add padding
      child: SingleChildScrollView( // Allows scrolling if the table is too long
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2), // Semi-transparent white background for the table
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: DataTable(
            columnSpacing: defaultPadding,
            columns: [
              DataColumn(label: Text("Nom", style: TextStyle(color: Colors.white))),
              DataColumn(label: Text("Prénom", style: TextStyle(color: Colors.white))),
              DataColumn(label: Text("Matricule", style: TextStyle(color: Colors.white))),
              DataColumn(label: Text("Date de Naissance", style: TextStyle(color: Colors.white))),
            ],
            rows: participants.map<DataRow>((participant) {
              return DataRow(cells: [
                DataCell(Text(participant['participant_nom'] ?? 'Unknown Nom', style: TextStyle(color: Colors.white))),
                DataCell(Text(participant['participant_prenom'] ?? 'Unknown Prénom', style: TextStyle(color: Colors.white))),
                DataCell(Text(participant['participant_matricule'] ?? 'Unknown Matricule', style: TextStyle(color: Colors.white))),
                DataCell(Text(participant['participant_date_de_naissance'] ?? 'Unknown Date', style: TextStyle(color: Colors.white))),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }
}
