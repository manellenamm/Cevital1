import 'package:flutter/material.dart';

// Classe pour le widget Salarie
class Salarie extends StatelessWidget {
  final String dateDebut;
  final String dateFin;
  final String intitule;
  final String lieu;
  final String organisme;
  final String formateurNom;
  final String formateurPrenom;
  final int nombrePresents;
  final double tauxPresence;

  // Constructeur de la classe Salarie
  Salarie({
    required this.dateDebut,
    required this.dateFin,
    required this.intitule,
    required this.lieu,
    required this.organisme,
    required this.formateurNom,
    required this.formateurPrenom,
    required this.nombrePresents,
    required this.tauxPresence,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Color.fromARGB(255, 7, 81, 143)), // Ajout d'une bordure pour la visibilité
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: DataTable(
              columnSpacing: 20.0,
              columns: [
                DataColumn(
                  label: Container(
                    width: 200,
                    child: Text(
                      "Synthèse",
                      style: TextStyle(fontWeight: FontWeight.bold),
                      softWrap: true,
                    ),
                  ),
                ),
                DataColumn(
                  label: Container(
                    width: 200,
                    child: Text(
                      "",
                      style: TextStyle(fontWeight: FontWeight.bold),
                      softWrap: true,
                    ),
                  ),
                ),
              ],
              rows: [
                DataRow(
                  cells: [
                    DataCell(Text('Intitulé de la formation')),
                    DataCell(Text(intitule)),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('Organisme de la formation')),
                    DataCell(Text(organisme)),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('Date du début de la formation')),
                    DataCell(Text(dateDebut)),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('Date de la fin de la formation')),
                    DataCell(Text(dateFin)),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('Nombre de participants inscrits')),
                    DataCell(Text(nombrePresents.toString())),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('Taux de présence')),
                    DataCell(Text('${tauxPresence.toStringAsFixed(2)}%')),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('Lieu de la formation')),
                    DataCell(Text(lieu)),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('Nom du Formateur')),
                    DataCell(Text(formateurNom)),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('Prénom du Formateur')),
                    DataCell(Text(formateurPrenom)),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
