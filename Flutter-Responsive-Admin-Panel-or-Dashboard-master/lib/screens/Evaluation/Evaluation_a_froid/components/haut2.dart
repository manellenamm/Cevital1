
import 'package:flutter/material.dart';
import 'package:admin/constants.dart';

class Participant extends StatelessWidget {
  final String matricule;
  final String nom;
  final String prenom;

  const Participant({
    Key? key,
    required this.matricule,
    required this.nom,
    required this.prenom,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: DataTable(
              columnSpacing: defaultPadding,
              columns: [
                DataColumn(
                  label: Container(
                    width: 200,
                    child: Text(
                      "Participant",
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
                    DataCell(Text('Matricule')),
                    DataCell(Text(matricule)),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('Nom')),
                    DataCell(Text(nom)),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('Prénom')),
                    DataCell(Text(prenom)),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: defaultPadding),
    
        ],
      ),
    );
  }
}
