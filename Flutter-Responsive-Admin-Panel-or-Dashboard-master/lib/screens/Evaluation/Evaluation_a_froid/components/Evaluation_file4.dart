import 'package:flutter/material.dart';
import 'package:admin/constants.dart'; // Assurez-vous que ce chemin est correct

class EvaluationFile4 extends StatefulWidget {
  final void Function(String?) onPrecisionChanged;

  const EvaluationFile4({
    Key? key,
    required this.onPrecisionChanged,
  }) : super(key: key);

  @override
  _EvaluationFile4State createState() => _EvaluationFile4State();
}

class _EvaluationFile4State extends State<EvaluationFile4> {
  // Contrôleur pour gérer la saisie utilisateur
  TextEditingController precisionController = TextEditingController();

  @override
  void dispose() {
    // Nettoyer le contrôleur lorsqu'il n'est plus utilisé
    precisionController.dispose();
    super.dispose();
  }

  void _onPrecisionChanged() {
    // La valeur saisie est stockée dans une variable locale
    String precision = precisionController.text;
    // Utiliser la fonction callback pour notifier le parent
    widget.onPrecisionChanged(precision);
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
            controller: precisionController,
            decoration: InputDecoration(
              labelText: 'Précisez',
              border: OutlineInputBorder(),
            ),
            onChanged: (text) => _onPrecisionChanged(),
          ),
          SizedBox(height: defaultPadding),
        ],
      ),
    );
  }
}
