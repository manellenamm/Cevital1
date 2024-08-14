import 'package:flutter/material.dart';
import 'package:admin/constants.dart';

class EvaluationFile2 extends StatefulWidget {
  final void Function(String?) onBesoinChanged; // Callback pour gérer le changement de sélection

  const EvaluationFile2({
    Key? key,
    required this.onBesoinChanged,
  }) : super(key: key);

  @override
  _EvaluationFile2State createState() => _EvaluationFile2State();
}

class _EvaluationFile2State extends State<EvaluationFile2> {
  String? selectedBesoin;

  final List<String> besoins = [
    'Nouvelle technologie',
    'Développement de nouveaux projets',
    'Évaluation carrière',
    'État compétences (Entretien annuel d\'évaluation)',
    'Consolider les compétences liées au poste',
    'Exigences réglementaires',
    'Exigences qualité et certification',
  ];

  void _onBesoinChanged(String? newValue) {
    if (newValue != null) {
      setState(() {
        selectedBesoin = newValue;
      });
      widget.onBesoinChanged(newValue); // Appel du callback avec la nouvelle valeur
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Sélectionnez un besoin',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              constraints: BoxConstraints(maxWidth: 1040),
            ),
            value: selectedBesoin,
            onChanged: _onBesoinChanged,
            items: besoins.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          SizedBox(height: defaultPadding),
        ],
      ),
    );
  }
}
