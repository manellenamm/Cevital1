import 'package:flutter/material.dart';
import 'package:admin/constants.dart';
import 'package:http/http.dart' as http;
import 'package:admin/screens/Evaluation/Evaluation_sans_emails/main/main_screen.dart' ;
import 'dart:convert';

class evaluerForm extends StatefulWidget {
  final int ?participantId;
  final String ? orienterId;
  evaluerForm({required this.participantId, required this.orienterId});

  @override
  _EvaluerFormState createState() => _EvaluerFormState();
}

class _EvaluerFormState extends State<evaluerForm> {
  String? objectifs1;
  String? contenu1 ;
   String? equilibre3;
  String? documentation4 ;
   String? methodes5;
  String? communication6 ;
   String? adaptation7;
  String? participation8 ;
   String? interet9;
  String? duree10 ;
   String? local11;
  String? moyens12 ;
  String? comprehension13;
  String? applicables14 ;
   String? satisfaction15;
  String? recommendation15 ;

  final List<String> evaluationOptions = [
    'tres_satisfait',
    'satisfait',
    'peu_satisfait',
    'insatisfait'
  ];

  // Valeurs initiales pour les dropdowns
  Map<String, String> evaluationValues = {
    'Les objectifs de la formation étaient clairs et précis': 'tres_satisfait',
    'Le contenu répondait bien à mes besoins': 'tres_satisfait',
    'Il y avait un bon équilibre entre la théorie et la pratique': 'tres_satisfait',
    'La documentation est de qualité et me sera utile': 'tres_satisfait',
    'Les méthodes et les techniques utilisées ont facilité mon apprentissage': 'tres_satisfait',
    'Communiquait de façon claire': 'tres_satisfait',
    'A été attentif et a su s’adapter au groupe': 'tres_satisfait',
    'A favorisé les échanges et la participation du groupe': 'tres_satisfait',
    'A suscité mon intérêt à la session de la formation': 'tres_satisfait',
    'La durée de la formation était suffisante': 'tres_satisfait',
    'Le local pédagogique était approprié': 'tres_satisfait',
    'Les moyens pédagogiques utilisés étaient de qualité': 'satisfait',
    'J’ai compris et intégré la majorité du contenu de la session': 'satisfait',
    'Les connaissances acquises peuvent être directement appliquées dans mon travail': 'satisfait',
    'De façon générale, je suis satisfait(e) de la formation reçue': 'tres_satisfait',
    'Je recommanderais à d’autres de suivre cette formation': 'tres_satisfait',
  };
   
  
Future<void> submitForm() async {
  final url = Uri.parse('http://127.0.0.1:8000/submitformsansemail/');

  final body = {
    'orienter_id': widget.orienterId.toString(),
    'participant_id': widget.participantId,
    'objectifs1': objectifs1.toString(),
    'contenu1': contenu1.toString(),
    'equilibre3': equilibre3.toString(),
    'documentation4': documentation4.toString(),
    'methodes5': methodes5.toString(),
    'communication6': communication6.toString(),
    'adaptation7': adaptation7.toString(),
    'participation8': participation8.toString(),
    'interet9': interet9.toString(),
    'duree10': duree10.toString(),
    'local11': local11.toString(),
    'moyens12': moyens12.toString(),
    'comprehension13': comprehension13.toString(),
    'applicables14': applicables14.toString(),
    'satisfaction15': satisfaction15.toString(),
    'recommendation15': recommendation15.toString(),
  };

  print('Request Body: ${jsonEncode(body)}');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      print('Form submitted successfully');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Form submitted successfully')),
      );

      // Rediriger vers la même page pour forcer le rafraîchissement
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Main5()), // Remplacez MyPage par le nom de votre page actuelle
      );
    } else {
      print('Failed to submit form: ${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit form')),
      );
    }
  } catch (e) {
    print('Error occurred: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error occurred: $e')),
    );
  }
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
          // Première DataTable
          SizedBox(
            width: double.infinity,
            child: DataTable(
              columnSpacing: defaultPadding,
              columns: [
                DataColumn(
                  label: Container(
                    width: 400,
                    
                  
                    child: Text(
                      "Objectifs, contenu et méthodologie",
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
    DataCell(Text('Les objectifs de la formation étaient clairs et précis')),
    DataCell(
      DropdownButton<String>(
        value: objectifs1,
        items: evaluationOptions
            .map((option) => DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            objectifs1 = value;
            
          });
        },
      ),
    ),
  ],
),
                DataRow(
                  cells: [
                    DataCell(Text('Le contenu répondait bien à mes besoins')),
                    DataCell(
                     DropdownButton<String>(
        value: contenu1,
        items: evaluationOptions
            .map((option) => DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            contenu1 = value;
           
          });
        },
      ),
                    ),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('Il y avait un bon équilibre entre la théorie et la pratique')),
                    DataCell(
                     DropdownButton<String>(
        value: equilibre3,
        items: evaluationOptions
            .map((option) => DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            equilibre3 = value;
          });
        },
      ),
                    ),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('La documentation est de qualité et me sera utile')),
                    DataCell(
                     DropdownButton<String>(
        value: documentation4,
        items: evaluationOptions
            .map((option) => DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            documentation4 = value;
          });
        },
      ),
                    ),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('Les méthodes et les techniques utilisées ont facilité mon apprentissage')),
                    DataCell(
                     DropdownButton<String>(
        value: methodes5,
        items: evaluationOptions
            .map((option) => DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            methodes5 = value;
          });
        },
      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: defaultPadding),
            SizedBox(
            width: double.infinity,
            child: DataTable(
              columnSpacing: defaultPadding,
              columns: [
                DataColumn(
                  label: Container(
                    width: 200,
                    child: Text(
                      "Le formateur",
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
                    DataCell(Text('Communiquait de façon claire')),
                    DataCell(
                      DropdownButton<String>(
        value:communication6,
        items: evaluationOptions
            .map((option) => DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            communication6 = value;
          });
        },
      ),
                    ),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('A été attentif et a su s’adapter au groupe')),
                    DataCell(
                     DropdownButton<String>(
        value: adaptation7,
        items: evaluationOptions
            .map((option) => DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            adaptation7 = value;
          });
        },
      ),
                    ),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('A favorisé les échanges et la participation du groupe')),
                    DataCell(
                     DropdownButton<String>(
        value: participation8,
        items: evaluationOptions
            .map((option) => DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            participation8 = value;
          });
        },
      ),
                    ),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('A suscité mon intérêt à la session de la formation')),
                    DataCell(
                    DropdownButton<String>(
        value: interet9,
        items: evaluationOptions
            .map((option) => DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            interet9 = value;
          });
        },
      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: defaultPadding),
            SizedBox(
            width: double.infinity,
            child: DataTable(
              columnSpacing: defaultPadding,
              columns: [
                DataColumn(
                  label: Container(
                    width: 200,
                    child: Text(
                      "Organisation",
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
                    DataCell(Text('La durée de la formation était suffisante')),
                    DataCell(
                     DropdownButton<String>(
        value: duree10,
        items: evaluationOptions
            .map((option) => DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
           duree10 = value;
          });
        },
      ),
                    ),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('Le local pédagogique était approprié')),
                    DataCell(
                     DropdownButton<String>(
        value: local11,
        items: evaluationOptions
            .map((option) => DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            local11 = value;
          });
        },
      ),
                    ),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('Les moyens pédagogiques utilisés étaient de qualité')),
                    DataCell(
                     DropdownButton<String>(
        value: moyens12,
        items: evaluationOptions
            .map((option) => DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            moyens12 = value;
          });
        },
      ),
                    ),
                  ],
                ),
                
              ],
            ),
          ),
          SizedBox(height: defaultPadding),
            SizedBox(
            width: double.infinity,
            child: DataTable(
              columnSpacing: defaultPadding,
              columns: [
                DataColumn(
                  label: Container(
                    width: 400,
                    child: Text(
                      "Acquis et transfert des apprentissages",
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
                    DataCell(Text('J’ai compris et intégré la majorité du contenu de la session')),
                    DataCell(
                      DropdownButton<String>(
        value: comprehension13,
        items: evaluationOptions
            .map((option) => DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            comprehension13 = value;
          });
        },
      ),
                    ),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('Les connaissances acquises peuvent être directement appliquées dans mon travail')),
                    DataCell(
                    DropdownButton<String>(
        value: applicables14,
        items: evaluationOptions
            .map((option) => DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            applicables14 = value;
          });
        },
      ),
                    ),
                  ],
                ),
               
              ],
            ),
          ),
          SizedBox(height: defaultPadding),
            SizedBox(
            width: double.infinity,
            child: DataTable(
              columnSpacing: defaultPadding,
              columns: [
                DataColumn(
                  label: Container(
                    width: 200,
                    child: Text(
                      "Appréciation générale",
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
                    DataCell(Text('De façon générale, je suis satisfait(e) de la formation reçue')),
                    DataCell(
                     DropdownButton<String>(
        value: satisfaction15,
        items: evaluationOptions
            .map((option) => DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            satisfaction15 = value;
          });
        },
      ),
                    ),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('Je recommanderais à d’autres de suivre cette formation')),
                    DataCell(
                     DropdownButton<String>(
        value: recommendation15,
        items: evaluationOptions
            .map((option) => DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            recommendation15 = value;
          });
        },
      ),
                    ),
                  ],
                ),
                
               
              ],
            ),
          ),
          SizedBox(height: defaultPadding),
           
          // Submit Button
          Center(
            child: ElevatedButton(
              onPressed: submitForm,
              child: Text('Submit'),
            ),
          ),
        SizedBox(height: defaultPadding),
        ],
      ),
    );
  }
}
