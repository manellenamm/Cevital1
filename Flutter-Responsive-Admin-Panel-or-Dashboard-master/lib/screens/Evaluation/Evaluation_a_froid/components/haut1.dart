import 'package:flutter/material.dart';
import 'package:admin/constants.dart';

class Information extends StatefulWidget {
  final void Function(String?) ondateChanged;
  final String intituleFormation;
  final String dateFormation;
  final String categorieFormation;

  const Information({
    Key? key,
    required this.intituleFormation,
    required this.dateFormation,
    required this.categorieFormation,
    required this.ondateChanged,
  }) : super(key: key);

  @override
  _InformationState createState() => _InformationState();
}

class _InformationState extends State<Information> {
  // Contrôleur pour gérer la saisie utilisateur
  TextEditingController evaluationFroidController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Écouter les changements dans le champ de texte
    evaluationFroidController.addListener(() {
      widget.ondateChanged(evaluationFroidController.text);
    });
  }

  @override
  void dispose() {
    // Nettoyer le contrôleur lorsqu'il n'est plus utilisé
    evaluationFroidController.dispose();
    super.dispose();
  }

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
                      "Informations sur la formation",
                      style: TextStyle(fontWeight: FontWeight.bold),
                      softWrap: true,
                    ),
                  ),
                ),
                DataColumn(
                  label: Container(
                    width: 200,
                  ),
                ),
              ],
              rows: [
                DataRow(
                  cells: [
                    DataCell(Text('Intitulé de la formation')),
                    DataCell(Text(widget.intituleFormation)),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('Date de la réalisation de la formation')),
                    DataCell(Text(widget.dateFormation)),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('Catégorie de la formation')),
                    DataCell(Text(widget.categorieFormation)),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('Date de l\'évaluation à froid')),
                    DataCell(
                      TextFormField(
                        controller: evaluationFroidController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'Entrez la date',
                        ),
                      ),
                    ),
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
