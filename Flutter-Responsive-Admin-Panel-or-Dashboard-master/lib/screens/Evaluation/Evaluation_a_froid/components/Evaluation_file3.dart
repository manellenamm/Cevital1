import 'package:flutter/material.dart';
import 'package:admin/constants.dart';

class EvaluationFile3 extends StatefulWidget {
  final void Function(String?) onObjectifChanged; // Callback pour gérer le changement de sélection

  const EvaluationFile3({
    Key? key,
    required this.onObjectifChanged,
  }) : super(key: key);

  @override
  _EvaluationFile3State createState() => _EvaluationFile3State();
}

class _EvaluationFile3State extends State<EvaluationFile3> {
  // Contrôleur pour gérer la saisie utilisateur
  TextEditingController objectifController = TextEditingController();

  @override
  void dispose() {
    // Nettoyer le contrôleur lorsqu'il n'est plus utilisé
    objectifController.dispose();
    super.dispose();
  }

  void _onObjectifChanged() {
    // La valeur saisie est stockée dans une variable locale
    String objectif = objectifController.text;
    // Utiliser la fonction callback pour notifier le parent
    widget.onObjectifChanged(objectif);
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
          TextField(
            controller: objectifController,
            decoration: InputDecoration(
              labelText: 'Quel est l\'objectif de cette formation pour le collaborateur',
              border: OutlineInputBorder(),
            ),
            onChanged: (text) => _onObjectifChanged(),
          ),
          SizedBox(height: defaultPadding),
        ],
      ),
    );
  }
}
