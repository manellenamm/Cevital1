import 'package:flutter/material.dart';
import 'package:admin/constants.dart';

class EvaluationFile extends StatefulWidget {
  final void Function(String?) onRecoursChanged; // Callback pour gérer le changement de texte

  const EvaluationFile({
    Key? key,
    required this.onRecoursChanged,
  }) : super(key: key);

  @override
  _EvaluationFileState createState() => _EvaluationFileState();
}

class _EvaluationFileState extends State<EvaluationFile> {
  // Contrôleur pour gérer la saisie utilisateur
  TextEditingController raisonRecoursController = TextEditingController();

  @override
  void dispose() {
    // Nettoyer le contrôleur lorsqu'il n'est plus utilisé
    raisonRecoursController.dispose();
    super.dispose();
  }

  void _onTextChanged(String text) {
    // Utiliser la fonction callback pour notifier le parent
    widget.onRecoursChanged(text);
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
            controller: raisonRecoursController,
            decoration: InputDecoration(
              labelText: 'Raison du recours à la formation',
              border: OutlineInputBorder(),
            ),
            onChanged: _onTextChanged, // Passer la fonction de gestion du texte
          ),
          SizedBox(height: defaultPadding),
        ],
      ),
    );
  }
}

