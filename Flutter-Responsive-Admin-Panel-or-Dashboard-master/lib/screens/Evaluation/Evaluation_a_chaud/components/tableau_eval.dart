import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:admin/responsive.dart';
import 'package:admin/constants.dart';
import 'salarie.dart';
import 'package:flutter/services.dart';



class Tableau extends StatefulWidget {
  const Tableau({Key? key}) : super(key: key);

  @override
  _TableauState createState() => _TableauState();
}

class _TableauState extends State<Tableau> {
  List<String> personnes = [];
  Map<String, List<String>> donneesBackend = {};
  double pourcentageObjectifs = 0.0;
  double pourcentageFormateur = 0.0;
  double pourcentageOrganization = 0.0;
  double pourcentageAcquis = 0.0;
  double pourcentageAppreciation = 0.0;
  String dateDebut = "";
  String dateFin = "";
  String intitule = "";
  String lieu = "";
  String organisme = "";
  String formateurNom = "";
  String formateurPrenom = "";
  int nombrePresents = 0;
  double tauxPresence = 0.0;

  final TextEditingController intituleController = TextEditingController();
  final TextEditingController moisController = TextEditingController();

  void clearFields() {
    intituleController.clear();
    moisController.clear();
  }

  void onFetchData() {
    String moisDebut = moisController.text;
    String intituleFormation = intituleController.text;

    if (moisDebut.isEmpty && intituleFormation.isEmpty) {
      clearFields();
      donneesBackend.clear();
      setState(() {});
    } else {
      fetchData(moisDebut, intituleFormation);
      clearFields();
    }
  }

  Future<void> fetchsend() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/send-form-email/'));
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Emails envoyés avec succès !')));
      } else {
        throw Exception('Échec de l\'envoi des emails');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Échec de l\'envoi des emails')));
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchData(String moisDebut, String intituleFormation) async {
    try {
      final response = await http.get(Uri.parse(
          'http://127.0.0.1:8000/tableau_data/?mois_debut=$moisDebut&intitule_formation=$intituleFormation'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          personnes = List<String>.from(data['evaluateurs'].map((id) => id.toString()));
          donneesBackend = processJsonResponse(data['evaluations']);

          if (data['evaluateurs'].isNotEmpty) {
            final firstEvaluateurId = data['evaluateurs'][0].toString();
            extractDetails(data, firstEvaluateurId);
          } else {
            initializeDefaultValues();
          }
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void initializeDefaultValues() {
    dateDebut = '';
    dateFin = '';
    intitule = '';
    lieu = '';
    organisme = '';
    formateurNom = '';
    formateurPrenom = '';
    nombrePresents = 0;
    tauxPresence = 0;
  }

 void extractDetails(Map<String, dynamic> data, String evaluateurId) {
  try {
    final orienterDetails = data['orienter_details'][evaluateurId];

    initializeDefaultValues();

    if (orienterDetails != null && orienterDetails.isNotEmpty) {
      final details = orienterDetails.values.first;

      dateDebut = details['date_debut'] ?? dateDebut;
      dateFin = details['date_fin'] ?? dateFin;
      intitule = details['formation']?['intitule'] ?? intitule;
      lieu = details['lieu_formation'] ?? lieu;
      organisme = details['organisme_formation'] ?? organisme;
      formateurNom = details['formation']?['formateur_nom'] ?? formateurNom;
      formateurPrenom = details['formation']?['formateur_prenom'] ?? formateurPrenom;
      nombrePresents = details['participants_presents'] ?? nombrePresents;
      tauxPresence = details['taux_presence'] ?? tauxPresence;

      print('Date de début: $dateDebut');
      print('Date de fin: $dateFin');
      print('Intitulé: $intitule');
      print('Lieu: $lieu');
      print('Organisme: $organisme');
      print('Formateur Nom: $formateurNom');
      print('Formateur Prénom: $formateurPrenom');
      print('Participants Présents: $nombrePresents');
      print('Taux de Présence: $tauxPresence');
    } else {
      print('Aucun détail trouvé pour l\'ID $evaluateurId');
    }
  } catch (e) {
    print('Error extracting details: $e');
  }
}
  Map<String, List<String>> processJsonResponse(Map<String, dynamic> evaluations) {
    List<String> sections = [
      'Objectifs, contenu et méthodologie',
      'Les objectifs de la formation étaient clairs et précis',
      'Le contenu répondait bien à mes besoins',
      'Il y avait un bon équilibre entre la théorie et la pratique',
      'La documentation est de qualité et me sera utile',
      'Les méthodes et les techniques utilisées ont facilité mon apprentissage',
      'Le formateur',
      'Communiquait de façon claire',
      'A été attentif et a su s’adapter au groupe',
      'A favorisé les échanges et la participation du groupe',
      'A suscité mon intérêt à la session de la formation',
      'Organization',
      'La durée de la formation était suffisante',
      'Le local pédagogique était approprié',
      'Les moyens pédagogiques utilisés étaient de qualité',
      'Acquis et transfert des apprentissages',
      'J’ai compris et intégré la majorité du contenu de la session',
      'Les connaissances acquises peuvent être directement appliquées dans mon travail',
      'Appréciation générale',
      'De façon générale, je suis satisfait(e) de la formation reçue',
      'Je recommanderais à d’autres de suivre cette formation',
    ];

    Map<String, List<String>> donnees = {};

    sections.forEach((section) {
      donnees[section] = List<String>.filled(personnes.length, '', growable: true);
    });

    evaluations.forEach((id, evaluationList) {
      var index = personnes.indexOf(id.toString());
      if (index != -1) {
        final evaluation = evaluationList[0]['data'];
        donnees['Objectifs, contenu et méthodologie']![index] = '';
        donnees['Les objectifs de la formation étaient clairs et précis']![index] = (evaluation['objectifs'] as String?) ?? '0';
        donnees['Le contenu répondait bien à mes besoins']![index] = (evaluation['contenu'] as String?) ?? '0';
        donnees['Il y avait un bon équilibre entre la théorie et la pratique']![index] = (evaluation['equilibre'] as String?) ?? '0';
        donnees['La documentation est de qualité et me sera utile']![index] = (evaluation['documentation'] as String?) ?? '0';
        donnees['Les méthodes et les techniques utilisées ont facilité mon apprentissage']![index] = (evaluation['methodes'] as String?) ?? '0';
        donnees['Le formateur']![index] = '';
        donnees['Communiquait de façon claire']![index] = (evaluation['communication'] as String?) ?? '0';
        donnees['A été attentif et a su s’adapter au groupe']![index] = (evaluation['adaptation'] as String?) ?? '0';
        donnees['A favorisé les échanges et la participation du groupe']![index] = (evaluation['participation'] as String?) ?? '0';
        donnees['A suscité mon intérêt à la session de la formation']![index] = (evaluation['interet'] as String?) ?? '0';
        donnees['Organization']![index] = '';
        donnees['La durée de la formation était suffisante']![index] = (evaluation['duree'] as String?) ?? '0';
        donnees['Le local pédagogique était approprié']![index] = (evaluation['local'] as String?) ?? '0';
        donnees['Les moyens pédagogiques utilisés étaient de qualité']![index] = (evaluation['moyens'] as String?) ?? '0';
        donnees['Acquis et transfert des apprentissages']![index] = '';
        donnees['J’ai compris et intégré la majorité du contenu de la session']![index] = (evaluation['comprehension'] as String?) ?? '0';
        donnees['Les connaissances acquises peuvent être directement appliquées dans mon travail']![index] = (evaluation['application'] as String?) ?? '0';
        donnees['Appréciation générale']![index] = '';
        donnees['De façon générale, je suis satisfait(e) de la formation reçue']![index] = (evaluation['satisfaction'] as String?) ?? '0';
        donnees['Je recommanderais à d’autres de suivre cette formation']![index] = (evaluation['recommandation'] as String?) ?? '0';
      }
    });

    return donnees;
  }

  List<DataColumn> getColumns() {
    List<DataColumn> columns = [];

    // Ajouter la première colonne fixe
    columns.add(DataColumn(label: Text(' ')));

    // Ajouter les colonnes dynamiquement en fonction des personnes
    personnes.forEach((personne) {
      columns.add(DataColumn(label: Text(personne)));
    });

    // Ajouter la colonne pour la moyenne
    columns.add(DataColumn(label: Text('Moyenne')));

    // Ajouter la colonne pour le pourcentage
    columns.add(DataColumn(label: Text('%')));

    return columns;
  }

  double calculateAverage(List<String> values) {
    int count = 0;
    double sum = 0.0;

    for (var value in values) {
      double? number = double.tryParse(value);
      if (number != null) {
        sum += number;
        count++;
      }
    }

    return count > 0 ? sum / count : 0.0;
  }

  double calculatePercentage(double average) {
    return (average / 4.0) * 100.0; // Conversion en pourcentage basé sur une note maximale de 4
  }

  double calculateSectionPercentage(String section) {
  List<String> sections = [];

  if (section == 'Objectifs, contenu et méthodologie') {
    sections = [
      'Les objectifs de la formation étaient clairs et précis',
      'Le contenu répondait bien à mes besoins',
      'Il y avait un bon équilibre entre la théorie et la pratique',
      'La documentation est de qualité et me sera utile',
      'Les méthodes et les techniques utilisées ont facilité mon apprentissage',
    ];
  } else if (section == 'Le formateur') {
    sections = [
      'Communiquait de façon claire',
      'A été attentif et a su s’adapter au groupe',
      'A favorisé les échanges et la participation du groupe',
      'A suscité mon intérêt à la session de la formation',
    ];
  } else if (section == 'Organization') {
    sections = [
      'La durée de la formation était suffisante',
      'Le local pédagogique était approprié',
      'Les moyens pédagogiques utilisés étaient de qualité',
    ];
  } else if (section == 'Acquis et transfert des apprentissages') {
    sections = [
      'J’ai compris et intégré la majorité du contenu de la session',
      'Les connaissances acquises peuvent être directement appliquées dans mon travail',
    ];
  } else if (section == 'Appréciation générale') {
    sections = [
      'De façon générale, je suis satisfait(e) de la formation reçue',
      'Je recommanderais à d’autres de suivre cette formation',
    ];
  }

  double sumPercentage = 0.0;
  int count = 0;

  for (var sec in sections) {
    if (donneesBackend.containsKey(sec)) {
      List<String> values = donneesBackend[sec]!;
      double average = calculateAverage(values);
      double percentage = calculatePercentage(average);
      sumPercentage += percentage;
      count++;
    }
  }

  return count > 0 ? sumPercentage / count : 0.0;
}


  List<DataRow> getRows() {
  List<DataRow> rows = [];
  List<String> sections = [
    'Objectifs, contenu et méthodologie',
    'Les objectifs de la formation étaient clairs et précis',
    'Le contenu répondait bien à mes besoins',
    'Il y avait un bon équilibre entre la théorie et la pratique',
    'La documentation est de qualité et me sera utile',
    'Les méthodes et les techniques utilisées ont facilité mon apprentissage',
    'Le formateur',
    'Communiquait de façon claire',
    'A été attentif et a su s’adapter au groupe',
    'A favorisé les échanges et la participation du groupe',
    'A suscité mon intérêt à la session de la formation',
    'Organization',
    'La durée de la formation était suffisante',
    'Le local pédagogique était approprié',
    'Les moyens pédagogiques utilisés étaient de qualité',
    'Acquis et transfert des apprentissages',
    'J’ai compris et intégré la majorité du contenu de la session',
    'Les connaissances acquises peuvent être directement appliquées dans mon travail',
    'Appréciation générale',
    'De façon générale, je suis satisfait(e) de la formation reçue',
    'Je recommanderais à d’autres de suivre cette formation',
  ];

  double sumAverages = 0.0;
  int countAverages = 0;
  double sumBluePercentages = 0.0;
  int countBluePercentages = 0;

  sections.forEach((section) {
    List<DataCell> cells = [];
    final backgroundColor = getColorForDataRow(section).resolve({});

    cells.add(DataCell(Text(
      section,
      style: TextStyle(color: getTextColor(backgroundColor)),
    )));

    List<String> values = [];

    donneesBackend[section]?.forEach((donnee) {
      cells.add(DataCell(Text(
        donnee,
        style: TextStyle(color: getTextColor(backgroundColor)),
      )));
      if (backgroundColor == Colors.transparent) {
        values.add(donnee);
      }
    });

    // Ajouter la cellule pour la moyenne et le pourcentage uniquement si la section n'est pas colorée en bleu
    if (backgroundColor == Colors.transparent) {
      double average = calculateAverage(values);
      double percentage = calculatePercentage(average);
      cells.add(DataCell(Text(
        average.toStringAsFixed(2), // Afficher la moyenne avec 2 décimales
        style: TextStyle(color: getTextColor(backgroundColor)),
      )));
      cells.add(DataCell(Text(
        '${percentage.toStringAsFixed(2)}%', // Afficher le pourcentage avec 2 décimales
        style: TextStyle(color: getTextColor(backgroundColor)),
      )));
      // Accumuler les moyennes
      sumAverages += average;
      countAverages++;
    } else {
      // Calculer le pourcentage pour les sections en bleu
      double sectionPercentage = calculateSectionPercentage(section);
      cells.add(DataCell(Text(
        '', // La cellule de moyenne pour les lignes en bleu
        style: TextStyle(color: getTextColor(backgroundColor)),
      )));
      cells.add(DataCell(Text(
        '${sectionPercentage.toStringAsFixed(2)}%', // Afficher le pourcentage avec 2 décimales
        style: TextStyle(color: getTextColor(backgroundColor)),
      )));
      // Assigner les pourcentages aux variables
      if (section == 'Objectifs, contenu et méthodologie') {
        pourcentageObjectifs = sectionPercentage;
        print(pourcentageObjectifs) ;
      } else if (section == 'Le formateur') {
        pourcentageFormateur = sectionPercentage;
        print(pourcentageFormateur) ;
      } else if (section == 'Organization') {
        pourcentageOrganization = sectionPercentage;
         print(pourcentageOrganization) ;
      } else if (section == 'Acquis et transfert des apprentissages') {
        pourcentageAcquis = sectionPercentage;
        print(pourcentageAcquis) ;
      } else if (section == 'Appréciation générale') {
        pourcentageAppreciation = sectionPercentage;
        print(pourcentageAppreciation) ;
      }
      // Accumuler les pourcentages des lignes bleues
      sumBluePercentages += sectionPercentage;
      countBluePercentages++;
    }

    rows.add(DataRow(
      cells: cells,
      color: MaterialStateProperty.all(backgroundColor),
    ));
  });

  // Ajouter la ligne vide colorée en bleu pour la moyenne des moyennes
  rows.add(DataRow(
    cells: [
      DataCell(Text(
        'Moyenne des moyennes',
        style: TextStyle(color: Colors.white),
      )),
      ...List.generate(personnes.length, (index) => DataCell(Text(''))),
      DataCell(Text(
        countAverages > 0 ? (sumAverages / countAverages).toStringAsFixed(2) : '',
        style: TextStyle(color: Colors.white),
      )),
      DataCell(Text(
        countBluePercentages > 0 ? '${(sumBluePercentages / countBluePercentages).toStringAsFixed(2)}%' : '',
        style: TextStyle(color: Colors.white),
      )),
    ],
    color: MaterialStateProperty.all(Color.fromARGB(255, 12, 33, 94)),
  ));

  return rows;
}



  MaterialStateProperty<Color> getColorForDataRow(String section) {
    if (section.contains('Objectifs') ||
        section.contains('Le formateur') ||
        section.contains('Organization') ||
        section.contains('Acquis et transfert des apprentissages') ||
        section.contains('Appréciation générale')) {
      return MaterialStateProperty.all(Color.fromARGB(255, 12, 33, 94));
    } else {
      return MaterialStateProperty.all(Colors.transparent);
    }
  }

  Color getTextColor(Color backgroundColor) {
    return backgroundColor == Colors.transparent ? Colors.black : Colors.white;
  }



 @override
Widget build(BuildContext context) {
  return Container(
    padding: EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.2),
      borderRadius: const BorderRadius.all(Radius.circular(10)),
    ),
    child: Column(
  children: [
    // Row for input fields and button
    Row(
  children: [
    Text(
      'Envoyer les emails aux personnes dont leurs formations se sont terminées  aujourd\'hui', // Texte fixe
      style: TextStyle(fontSize: 16), // Tu peux ajuster la taille du texte ici
    ),
    SizedBox(width: 10), // Ajoute un espace entre le texte et le bouton
    ElevatedButton(
      onPressed: fetchsend,
      style: ElevatedButton.styleFrom(
        primary: Color.fromARGB(255, 12, 33, 94),  // Couleur de fond du bouton
      ),
      child: const Text('Envoyer'),
    ),
  ],
),
  SizedBox(height: 40),
   Row(
  children: [
    Expanded(
      child: TextField(
        controller: moisController,
        decoration: InputDecoration(
          labelText: '(YYYY-MM)', // Example format
        ),
        inputFormatters: [
          // Allow only digits and dash
          FilteringTextInputFormatter.allow(RegExp(r'^\d{0,4}(-\d{0,2})?$')),
        ],
      ),
    ),
    SizedBox(width: 10), // Add some space between the fields
    Expanded(
      child: TextField(
        controller: intituleController,
        decoration: InputDecoration(labelText: 'Intitulé de la formation'),
      ),
    ),
    SizedBox(width: 10), // Add some space between the fields and button
    ElevatedButton(
      onPressed: onFetchData,
      style: ElevatedButton.styleFrom(
        primary: Color.fromARGB(255, 12, 33, 94),  // Set the background color
      ),
      child: const Text('Rechercher'),
    ),
  ],
),

   SizedBox(height: 30),

         // DataTable and other widgets
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: DataTable(
                columnSpacing: 5.0,
                columns: getColumns(),
                rows: getRows(),
              ),
            ),
            SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      SizedBox(height: 200),
                      Container(
                        height: 300, // Set a fixed height for the BarChart
                        child: BarChartSample(
                          pourcentageObjectifs: pourcentageObjectifs,
                          pourcentageFormateur: pourcentageFormateur,
                          pourcentageOrganization: pourcentageOrganization,
                          pourcentageAcquis: pourcentageAcquis,
                          pourcentageAppreciation: pourcentageAppreciation,
                        ),
                      ),
                      if (Responsive.isMobile(context))
                        SizedBox(height: defaultPadding),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context)) SizedBox(width: defaultPadding),
              ],
            ),
            SizedBox(height: 100),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      SizedBox(height: defaultPadding),
                      Salarie(
                        dateDebut: dateDebut  ,
                        dateFin: dateFin  ,
                        intitule: intitule  ,
                        lieu: lieu ,
                        organisme: organisme  ,
                        formateurNom: formateurNom  ,
                        formateurPrenom: formateurPrenom  ,
                        nombrePresents: nombrePresents  ,
                        tauxPresence: tauxPresence  ,
                      ),
                      if (Responsive.isMobile(context))
                        SizedBox(height: defaultPadding),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context)) SizedBox(width: defaultPadding),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

}


class BarChartSample extends StatelessWidget {
 final double pourcentageObjectifs;
  final double pourcentageFormateur;
  final double pourcentageOrganization;
  final double pourcentageAcquis;
  final double pourcentageAppreciation;

  BarChartSample({
    required this.pourcentageObjectifs,
    required this.pourcentageFormateur,
    required this.pourcentageOrganization,
    required this.pourcentageAcquis,
    required this.pourcentageAppreciation,
  });
  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 100,
        barGroups: [
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(y: pourcentageObjectifs , colors: [Colors.yellow], width: 60, borderRadius: BorderRadius.zero), // Barre rouge sans coins arrondis
            ],
            showingTooltipIndicators: [0],
          ),
          BarChartGroupData(
            x: 2,
            barRods: [
              BarChartRodData(y: pourcentageFormateur , colors: [Colors.yellow], width: 60, borderRadius: BorderRadius.zero), // Barre verte sans coins arrondis
            ],
            showingTooltipIndicators: [0],
          ),
          BarChartGroupData(
            x: 3,
            barRods: [
              BarChartRodData(y:pourcentageOrganization,  colors: [Colors.yellow], width: 60, borderRadius: BorderRadius.zero), // Barre bleue sans coins arrondis
            ],
            showingTooltipIndicators: [0],
          ),
          BarChartGroupData(
            x: 4,
            barRods: [
              BarChartRodData(y:pourcentageAppreciation, colors: [Colors.yellow], width: 60, borderRadius: BorderRadius.zero), // Barre orange sans coins arrondis
            ],
            showingTooltipIndicators: [0],
          ),
           BarChartGroupData(
            x: 5,
            barRods: [
              BarChartRodData(y:pourcentageAcquis, colors: [Colors.yellow], width: 60, borderRadius: BorderRadius.zero), // Barre orange sans coins arrondis
            ],
            showingTooltipIndicators: [0],
          ),
        ],
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: SideTitles(
            showTitles: true,
            getTextStyles: (context, value) => const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            margin: 16,
            getTitles: (double value) {
              switch (value.toInt()) {
                case 1:
                  return 'Objectifs , contenu et méthodologie ';
                case 2:
                  return 'Le formateur ';
                case 3:
                  return 'Organization';
                case 4:
                  return 'Appréciations générales';
                case 5 :
                  return 'Acquis ';
                default:
                  return '';
              }
            },
          ),
          leftTitles: SideTitles(
            showTitles: true,
            getTextStyles: (context, value) => const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            margin: 16,
            interval: 10,
            reservedSize: 28, // Espace réservé pour les titres à gauche
            getTitles: (double value) {
              return '${value.toInt()}%';
            },
          ),
          rightTitles: SideTitles(
            showTitles: true,
            getTextStyles: (context, value) => const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            margin: 16,
            interval: 10,
            reservedSize: 28, // Espace réservé pour les titres à droite
            getTitles: (double value) {
              return '${value.toInt()}';
            },
          ),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Color.fromARGB(255, 114, 114, 0),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                rod.y.round().toString(),
                TextStyle(color: Colors.yellow),
              );
            },
          ),
        ),
      ),
    );
  }
} 


