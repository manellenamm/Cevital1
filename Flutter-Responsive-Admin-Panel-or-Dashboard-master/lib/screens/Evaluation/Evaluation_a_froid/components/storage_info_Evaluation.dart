import 'package:flutter/material.dart';
import 'package:admin/constants.dart';

class StorageEvaluation extends StatelessWidget {
  const  StorageEvaluation({
    Key? key,
    required this.title,
    required this.color, // Ajout du paramètre color
  }) : super(key: key);

  final String title;
  final Color color; // Ajout du paramètre color

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: defaultPadding),
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: primaryColor.withOpacity(0.15)),
        borderRadius: const BorderRadius.all(
          Radius.circular(defaultPadding),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            color: color, // Utilisation de la couleur spécifiée
          ),
          SizedBox(width: 10), // Espacement entre le carré et le texte
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                 
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}