import 'package:admin/responsive.dart';
import 'package:admin/screens/Evaluation/Evaluation_a_froid/components/haut1.dart';
import 'package:admin/screens/Evaluation/Evaluation_a_froid/components/haut2.dart';
import 'package:admin/screens/Evaluation/Evaluation_a_froid/components/haut3.dart';
import 'package:admin/screens/Evaluation/Evaluation_a_froid/components/haut5.dart';
import 'components/Evaluation_file1.dart';
import 'components/Evaluation_file3.dart';
import 'components/Evaluation_file2.dart';
import 'components/Evaluation_file4.dart';
import 'components/Evaluation_file.dart';
import 'components/headerevaluation.dart';
import 'package:flutter/material.dart';
import 'package:admin/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Responsable {
  final String nom;
  final String prenom;
  final String matricule;

  Responsable({
    required this.nom,
    required this.prenom,
    required this.matricule,
  });

  factory Responsable.fromJson(Map<String, dynamic> json) {
    return Responsable(
      nom: json['nom'],
      prenom: json['prenom'],
      matricule: json['matricule'],
    );
  }
}

class OrientationDetails {
  final String nom;
  final String prenom;
  final String structure;
  final String service;
  final String matricule;

  OrientationDetails({
    required this.nom,
    required this.prenom,
    required this.structure,
    required this.service,
    required this.matricule,
  });

  factory OrientationDetails.fromJson(Map<String, dynamic> json) {
    return OrientationDetails(
      nom: json['nom'],
      prenom: json['prenom'],
      structure: json['structure'],
      service: json['service'],
      matricule: json['matricule'],
    );
  }

  @override
  String toString() {
    return 'Nom: $nom, Prénom: $prenom, Structure: $structure, Service: $service, Matricule: $matricule';
  }
}

class main_evaluation extends StatefulWidget {
  final String? id;

  const main_evaluation({Key? key, this.id}) : super(key: key);

  @override
  _MainEvaluationState createState() => _MainEvaluationState();
}

class _MainEvaluationState extends State<main_evaluation> {
  bool _evaluationCompleted = false;
  String structure = '';
  String service = '';
  String intituleFormation = '';
  String dateFormation = '';
  String categorieFormation = '';

  Responsable responsable = Responsable(nom: '', prenom: '', matricule: '');

  List<OrientationDetails> participants = [];
  int currentParticipantIndex = 0;
  String? selectedBesoin;
  String? selectedPrecision;
  String? selectedrecours;
  String? selectedObjectif;
  String? selectedDate;
  String ?taux_satisfaction ;
  Map<String, String>? selectedRatesMap;

  Future<int?> _getParticipantId(String nom, String prenom, String matricule) async {
  final response = await http.get(
    Uri.parse('http://127.0.0.1:8000/get_participant_id?nom=$nom&prenom=$prenom&matricule=$matricule'),
  );
  print('Réponse JSON: ${response.body}');
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    // Assurez-vous que le participant_id est bien un entier
    return data['participant_id'] != null ? int.tryParse(data['participant_id'].toString()) : null;
  } else {
    print('Erreur lors de la récupération de l\'ID du participant: ${response.statusCode}');
    return null;
  }
}

  void fetchsend() async {
   final response = await http.get(Uri.parse('http://127.0.0.1:8000/envoyer-evaluations/'));
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Emails envoyés avec succès !')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Échec de l\'envoi des emails')));
    }
  }

  
  Future<void> _submitEvaluation() async {
    if (selectedRatesMap == null) {
      print("selectedRatesMap is null");
      return;
    }

   final participantDetails = participants[currentParticipantIndex];

// Obtenir l'ID du participant
final participantId = await _getParticipantId(
  participantDetails.nom,
  participantDetails.prenom,
  participantDetails.matricule,
);

print(participantId);

if (participantId == null) {
  print("Impossible de récupérer l'ID du participant");
  return;
}

// Ici, participantId est de type int? (int ou null)
print('L\'ID du participant est : $participantId');

    print('Clés disponibles dans selectedRatesMap: ${selectedRatesMap!.keys}');

    final rateBesoin = selectedRatesMap!['La formation choisie semblait-elle répondre à son besoin ?'];
    final rateObjectif = selectedRatesMap!['Pensez-vous que votre collaborateur a atteint les objectifs de la formation ? '];
    final rateConnaissance = selectedRatesMap!['Votre collaboratur a pu mettre en pratique les connaissances acquises ?'];
    final rateReductionRisque = selectedRatesMap!["La formation a-elle permis a votre collaborateur de réduire les requises de NC ou d'accidents ?"];
    final rateMaitriseMetier = selectedRatesMap!['La formation a-elle permis a votre collaborateur une meuilleure métrise du métier/des régles QHSE'];

    final Map<String, dynamic> evaluationData = {
      'orienter': widget.id, // ID de l'orientation
      'participant': participantId, // ID du participant
      'evaluateur': {
        'nom': responsable.nom,
        'prenom': responsable.prenom,
        'matricule': responsable.matricule,
      },
      'date': selectedDate,
      'recours': selectedrecours,
      'besoin': selectedBesoin,
      'precision': selectedPrecision,
      'objectif': selectedObjectif,
      'rate_besoin': rateBesoin,
      'rate_objectif': rateObjectif,
      'rate_connaissance': rateConnaissance,
      'rate_reduction_risque': rateReductionRisque,
      'rate_maitrise_metier': rateMaitriseMetier,
      'taux_satisfaction': taux_satisfaction,
    };

    print('Évaluation Data: $evaluationData');

   try {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/evaluerfroid/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(evaluationData),
    );

    print('Réponse JSON: ${response.body}');
    if (response.statusCode == 201) {
      print("Évaluation envoyée avec succès");
    } else {
      print("Échec de l'envoi de l'évaluation: ${response.statusCode}");
    }
  } catch (e) {
    print('Erreur lors de l\'envoi de la requête: $e');
  }
}

@override
  void initState() {
    super.initState();
    _fetchOrientationDetails(widget.id);
 
}

  Future<void> _fetchOrientationDetails(String? id) async {
    if (id == null) return;

    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/orientations/$id'),
    );
    print('response= ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        intituleFormation = data['intituleFormation'] ?? '';
        dateFormation = data['dateFormation'] ?? '';
        categorieFormation = data['categorieFormation'] ?? '';
        participants = (data['participants'] as List)
            .map((participant) => OrientationDetails.fromJson(participant))
            .toList();

        final responsableData = data['responsable'];
        if (responsableData != null) {
          responsable = Responsable.fromJson(responsableData);
        }

        print(participants.map((p) => p.toString()).toList());
      });
    } else {
      // Handle error
    }
  }

void _evaluateCurrentParticipant() {
  if (currentParticipantIndex < participants.length - 1) {
    setState(() {
      currentParticipantIndex++;
    });
  } else {
    // Tous les participants ont été évalués
    print("Tous les participants ont été évalués");
    // Mettre à jour l'état pour indiquer que l'évaluation est terminée
    setState(() {
      _evaluationCompleted = true;
    });
  }
}

  void _handleBesoinSelection(String? besoin) {
    setState(() {
      selectedBesoin = besoin;
    });
  }
  
  void _handletauxSelection(double? selectedtaux) {
  setState(() {
    taux_satisfaction = selectedtaux?.toString(); // Convert the double to a string
  });
}

   

  void _handleratesmapSelection(Map<String, String> ratesMap) {
    setState(() {
      selectedRatesMap = ratesMap;
    });
  }

  void _handlePrecisionSelection(String? precision) {
    setState(() {
      selectedPrecision = precision;
    });
  }

  void _handleRecoursSelection(String? recours) {
    setState(() {
      selectedrecours = recours;
    });
  }

  void _handleObjectifSelection(String? objectif) {
    setState(() {
      selectedObjectif = objectif;
    });
  }

  void _handledatefroidSelection(String? date) {
    setState(() {
      selectedDate = date;
    });
  }

  void _showCompletionDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Évaluation terminée'),
        content: Text('Toutes les évaluations ont été complétées!'),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop(); // Ferme le dialogue
            },
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    OrientationDetails? currentParticipant = participants.isNotEmpty ? participants[currentParticipantIndex] : null;

    return Scaffold(
      backgroundColor: Color(0xFF014F8F),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              SizedBox(height: defaultPadding),
               Row(
  children: [
    Text(
  'Envoyer les emails au responsable pour l\'évaluation à froid  dont les formations se sont terminées il y a 6 mois', // Texte fixe
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
              SizedBox(height: defaultPadding),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        SizedBox(height: defaultPadding),
                        Header1(),
                        if (Responsive.isMobile(context)) SizedBox(height: defaultPadding),
                      ],
                    ),
                  ),
                  if (!Responsive.isMobile(context)) SizedBox(width: defaultPadding),
                ],
              ),
              SizedBox(height: defaultPadding),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        SizedBox(height: defaultPadding),
                        Information(
                          ondateChanged: _handledatefroidSelection,
                          intituleFormation: intituleFormation,
                          dateFormation: dateFormation,
                          categorieFormation: categorieFormation,
                        ),
                        if (Responsive.isMobile(context)) SizedBox(height: defaultPadding),
                      ],
                    ),
                  ),
                  if (!Responsive.isMobile(context)) SizedBox(width: defaultPadding),
                ],
              ),
              SizedBox(height: defaultPadding),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        SizedBox(height: defaultPadding),
                      
                          Participant(
                            nom: currentParticipant?.nom ?? '',
                            prenom: currentParticipant?.prenom ?? '',
                            matricule: currentParticipant?.matricule ?? '',
                          ),
                        if (Responsive.isMobile(context)) SizedBox(height: defaultPadding),
                      ],
                    ),
                  ),
                  if (!Responsive.isMobile(context)) SizedBox(width: defaultPadding),
                ],
              ),
              SizedBox(height: defaultPadding),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        SizedBox(height: defaultPadding),
                        Affectation(
                          service: currentParticipant?.service ?? '',
                          structure: currentParticipant?.structure ?? '',
                        ),
                        if (Responsive.isMobile(context)) SizedBox(height: defaultPadding),
                      ],
                    ),
                  ),
                  if (!Responsive.isMobile(context)) SizedBox(width: defaultPadding),
                ],
              ),
              SizedBox(height: defaultPadding),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        SizedBox(height: defaultPadding),
                        ResponsableCard(
                          nom: responsable.nom,
                          prenom: responsable.prenom,
                          matricule: responsable.matricule,
                        ),
                        if (Responsive.isMobile(context)) SizedBox(height: defaultPadding),
                      ],
                    ),
                  ),
                  if (!Responsive.isMobile(context)) SizedBox(width: defaultPadding),
                ],
              ),
              SizedBox(height: defaultPadding),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        SizedBox(height: defaultPadding),
                        EvaluationFile(onRecoursChanged: _handleRecoursSelection),
                        if (Responsive.isMobile(context)) SizedBox(height: defaultPadding),
                      ],
                    ),
                  ),
                  if (!Responsive.isMobile(context)) SizedBox(width: defaultPadding),
                ],
              ),
              SizedBox(height: defaultPadding),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        SizedBox(height: defaultPadding),
                        EvaluationFile2(onBesoinChanged: _handleBesoinSelection),
                        if (Responsive.isMobile(context)) SizedBox(height: defaultPadding),
                      ],
                    ),
                  ),
                  if (!Responsive.isMobile(context)) SizedBox(width: defaultPadding),
                ],
              ),
              SizedBox(height: defaultPadding),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        SizedBox(height: defaultPadding),
                        EvaluationFile4(onPrecisionChanged: _handlePrecisionSelection),
                        if (Responsive.isMobile(context)) SizedBox(height: defaultPadding),
                      ],
                    ),
                  ),
                  if (!Responsive.isMobile(context)) SizedBox(width: defaultPadding),
                ],
              ),
              SizedBox(height: defaultPadding),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        SizedBox(height: defaultPadding),
                        EvaluationFile3(onObjectifChanged: _handleObjectifSelection),
                        if (Responsive.isMobile(context)) SizedBox(height: defaultPadding),
                      ],
                    ),
                  ),
                  if (!Responsive.isMobile(context)) SizedBox(width: defaultPadding),
                ],
              ),
              SizedBox(height: defaultPadding),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        SizedBox(height: defaultPadding),
                        EvaluationFiles(onRatesMapChanged: _handleratesmapSelection,
                        handleSelection: _handletauxSelection,
                        ),
                        if (Responsive.isMobile(context)) SizedBox(height: defaultPadding),
                        
                      ],
                    ),
                  ),
                  if (!Responsive.isMobile(context)) SizedBox(width: defaultPadding),
                ],
              ),
             
                SizedBox(height: defaultPadding),
              ElevatedButton(
                onPressed: () async {
                  await _submitEvaluation();
                  _evaluateCurrentParticipant();
                  if (_evaluationCompleted) {
                    _showCompletionDialog(context);
                  }
                },
                child: Text('Soumettre l\'évaluation'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
      
  
