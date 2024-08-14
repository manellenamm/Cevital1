import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:admin/constants.dart';

class Evaluateur extends StatefulWidget {
  
  const Evaluateur({
    Key? key,
 
  }) : super(key: key);

  @override
  _EvaluateurtState createState() => _EvaluateurtState();
}

class _EvaluateurtState extends State<Evaluateur> {
  TextEditingController matriculeController = TextEditingController();
  String nom = '';
  String prenom = '';
  
  TextEditingController evaluationFroidController = TextEditingController();

  Future<void> fetchParticipant() async {
    final String matricule = matriculeController.text;
    final String apiUrl = 'http://127.0.0.1:8000/evaluateur/$matricule/';

    try {
      var response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        setState(() {
          nom = jsonData['nom'];
          prenom = jsonData['prenom'];
        });
        
      } else {
        setState(() {
          nom = 'Evaluateur non trouvé';
          prenom = '';
         
        });
        
        
      }
    } catch (error) {
      print('Erreur lors de la récupération des données: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
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
                      "Evaluateur ",
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
                    DataCell(
                      TextFormField(
                        controller: matriculeController,
                        keyboardType: TextInputType.text,
                      ),
                    ),
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
          ElevatedButton(
            onPressed: fetchParticipant,
            child: Text('Chercher  evaluateur '),
          ),
          SizedBox(height: defaultPadding),
        ],
      ),
    );
  }
}