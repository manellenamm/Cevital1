import 'package:flutter/material.dart';
import '../../../constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Participant {
  final String id, nom, prenom, matricule, structure, email, etat , fonction, pole, csp;
  final bool presence;
  final List<EvaluationChaude> evaluationsChaudes;
  final List<EvaluationFroide> evaluationsFroides;

  Participant({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.matricule,
    required this.structure,
    required this.email,
    required this.presence,
    required this.etat,
    required this.evaluationsChaudes,
    required this.evaluationsFroides,
     required this.fonction,
      required this.csp,
       required this.pole,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    var evaluations = (json['evaluations_chaud'] as List<dynamic>)
        .map((e) => EvaluationChaude.fromJson(e))
        .toList();
    var evaluationF = (json['evaluations_froid'] as List<dynamic>)
        .map((e) => EvaluationFroide.fromJson(e))
        .toList();

    return Participant(
      id: json['id'].toString(),
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      matricule: json['matricule'] ?? '',
      structure: json['structure'] ?? '',
      email: json['email'] ?? '',
      presence: json['presence'] ?? false,
      etat: json['etat'] ?? '',
      fonction: json['fonction'] ?? '',
      pole: json['pole'] ?? '',
      csp: json['csp'] ?? '', 

      evaluationsChaudes: evaluations,
      evaluationsFroides: evaluationF,
    );
  }
}

class EvaluationFroide {
  final String date;
  final String recours;
  final String besoin;
  final String precision;
  final String objectif;
  final String taux_satisfaction ;
  final int rateBesoin;
  final int rateObjectif;
  final int rateConnaissance;
  final int rateReductionRisque;
  final int rateMaitriseMetier;

  EvaluationFroide({
    required this.date,
    required this.recours,
    required this.besoin,
    required this.precision,
    required this.objectif,
    required this.rateBesoin,
    required this.rateObjectif,
    required this.rateConnaissance,
    required this.rateReductionRisque,
    required this.rateMaitriseMetier,
    required this.taux_satisfaction,
  });

  factory EvaluationFroide.fromJson(Map<String, dynamic> json) {
    return EvaluationFroide(
      date: json['date'] ?? '',
      recours: json['recours'] ?? '',
      besoin: json['besoin'] ?? '',
      precision: json['precision'] ?? '',
      objectif: json['objectif'] ?? '',
      rateBesoin: json['rate_besoin'] ?? 0,
      rateObjectif: json['rate_objectif'] ?? 0,
      rateConnaissance: json['rate_connaissance'] ?? 0,
      rateReductionRisque: json['rate_reduction_risque'] ?? 0,
      rateMaitriseMetier: json['rate_maitrise_metier'] ?? 0,
      taux_satisfaction: json['taux_satisfaction'] ?? '',
    );
  }
}


class EvaluationChaude {
  final String dateEvaluation, objectifs, contenu, equilibre, documentation,
      methodes, communication, adaptation, participation, interet, duree, local,
      moyens, comprehension, applicables, satisfaction, recommendation;
  final double tauxEvaluation;

  EvaluationChaude({
    required this.dateEvaluation,
    required this.objectifs,
    required this.contenu,
    required this.equilibre,
    required this.documentation,
    required this.methodes,
    required this.communication,
    required this.adaptation,
    required this.participation,
    required this.interet,
    required this.duree,
    required this.local,
    required this.moyens,
    required this.comprehension,
    required this.applicables,
    required this.satisfaction,
    required this.recommendation,
    required this.tauxEvaluation,
  });

  factory EvaluationChaude.fromJson(Map<String, dynamic> json) {
    return EvaluationChaude(
      dateEvaluation: json['date_evaluation'] ?? '',
      objectifs: json['objectifs'] ?? '',
      contenu: json['contenu'] ?? '',
      equilibre: json['equilibre'] ?? '',
      documentation: json['documentation'] ?? '',
      methodes: json['methodes'] ?? '',
      communication: json['communication'] ?? '',
      adaptation: json['adaptation'] ?? '',
      participation: json['participation'] ?? '',
      interet: json['interet'] ?? '',
      duree: json['duree'] ?? '',
      local: json['local'] ?? '',
      moyens: json['moyens'] ?? '',
      comprehension: json['comprehension'] ?? '',
      applicables: json['applicables'] ?? '',
      satisfaction: json['satisfaction'] ?? '',
      recommendation: json['recommendation'] ?? '',
      tauxEvaluation: (json['taux_evaluation'] ?? 0).toDouble(), // Assurez-vous que c'est un double
    );
  }
  

}

 
class AffichageFile {
  final String intitule, categorie, type,  date_debut,
      date_fin, organisme, code_tiers, cout_total, bc, facturepedagogique,
      numero_facture, organisme_logistique, facture_hotel, cout_logistique, enjeu, responsable;

  final List<Participant> participants;

  AffichageFile({
    required this.intitule,
    required this.categorie,
    required this.type,
    required this.date_debut,
    required this.date_fin,
    required this.organisme,
    required this.code_tiers,
    required this.cout_total,
    required this.bc,
    required this.facturepedagogique,
    required this.numero_facture,
    required this.organisme_logistique,
    required this.facture_hotel,
    required this.cout_logistique,
    required this.enjeu,
    required this.responsable,
    required this.participants,
  
  });

  factory AffichageFile.fromJson(Map<String, dynamic> json) {
    var participants = (json['participants'] as Map<String, dynamic>)
        .values
        .map((e) => Participant.fromJson(e))
        .toList();

    return AffichageFile(
      intitule: json['formation'] ?? '',
      categorie: json['categorie_formation'] ?? '',
      type: json['type_formation'] ?? '',
      date_debut: json['date_debut'].toString(),
      date_fin: json['date_fin'].toString(),
      organisme: json['organisme_formation'] ?? '',
      code_tiers: json['code_tiers'] ?? '',
      cout_total: json['cout_total'] ?? '',
      bc: json['NumBc'] ?? '',
      facturepedagogique: json['Facture_Pédagogique'] ?? '',
      numero_facture: json['NuméroFacture_Pédagogique'] ?? '',
      organisme_logistique: json['Organisme_logistque'] ?? '',
      facture_hotel: json['Facture_Hotel'] ?? '',
      cout_logistique: json['cout_logistique'] ?? '',
      enjeu: json['Enjeu'] ?? '',
      responsable: json['responsable_hiearchique'] ?? '',
      participants: participants,
    );
  }


  // Méthode pour calculer le coût par personne
  double get coutParPersonne {
    int nombrePresences = participants.where((p) => p.presence).length;
    if (nombrePresences == 0) return 0.0;
    double totalCout = double.tryParse(cout_total) ?? 0.0;
    return totalCout / nombrePresences;
  }
}

// Fonction pour récupérer les données JSON
Future<List<AffichageFile>> fetchAffichageFiles() async {
  final response = await http.get(Uri.parse('http://127.0.0.1:8000/all-data/'));
  print('Réponse JSON: ${response.body}');

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    List<dynamic> filesJson = jsonResponse['orienters'];

    return filesJson.map((data) => AffichageFile.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load data');
  }
}


String getAppreciation(double tauxEvaluation) {
  if (tauxEvaluation >= 0 && tauxEvaluation < 30) {
    return 'Insatisfait';
  } else if (tauxEvaluation >= 30 && tauxEvaluation < 60) {
    return 'Peu satisfait';
  } else if (tauxEvaluation >= 60 && tauxEvaluation < 90) {
    return 'Satisfait';
  } else if (tauxEvaluation >= 90 && tauxEvaluation <= 100) {
    return 'Très satisfait';
  } else {
    return '';
  }
}
class AffichageFiles extends StatelessWidget {
  const AffichageFiles({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AffichageFile>>(
      future: fetchAffichageFiles(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<AffichageFile>? files = snapshot.data;
          return Container(
            padding: EdgeInsets.all(defaultPadding),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: defaultPadding,
                columns: [
                  DataColumn(label: Text("Intitulé formation")),
                  DataColumn(label: Text("Catégorie")),
                  DataColumn(label: Text("Type")),
                  DataColumn(label: Text("Matricule")),
                  DataColumn(label: Text("Nom")),
                  DataColumn(label: Text("Prénom")),
                  DataColumn(label: Text("Fonction")),
                  DataColumn(label: Text("CSP")),
                  DataColumn(label: Text("Structure")),
                  DataColumn(label: Text("Pôle")),
                  DataColumn(label: Text("Début réel")),
                  DataColumn(label: Text("Fin réel")),
                  DataColumn(label: Text("Absentéisme")),
                  DataColumn(label: Text("État")), 
                  DataColumn(label: Text("Durée jours")),
                  DataColumn(label: Text("Durée heures")),
                  DataColumn(label: Text("Organisme")),
                  DataColumn(label: Text("Code tiers")),
                  DataColumn(label: Text("Coût par personne")),
                  DataColumn(label: Text("Coût total")),
                  DataColumn(label: Text("N° BC")),
                  DataColumn(label: Text("Date Facture pédagogique")),
                  DataColumn(label: Text("N° facture pédagogique")),
                  DataColumn(label: Text("Organisme logistique")),
                  DataColumn(label: Text("Facture hôtel")),
                  DataColumn(label: Text("Coût logistique")),
                  DataColumn(label: Text("Appreciation Chaude")),
                  DataColumn(label: Text("Résultat Evaluation Chaude")),
                  DataColumn(label: Text("Date Evaluation Froide")),
                 DataColumn(label: Text("Résultat Evaluation Froide")),
                  DataColumn(label: Text("Enjeu")),
                  DataColumn(label: Text("Responsable")),
                ],
                rows: files!.expand((fileInfo) {
                  return fileInfo.participants.map((participant) {
                    var evaluation = participant.evaluationsChaudes.isNotEmpty ? participant.evaluationsChaudes.first : null;
                    var evaluationsF = participant.evaluationsFroides.isNotEmpty ? participant.evaluationsFroides.first : null;
                    
                    return DataRow(
                      cells: [
                        DataCell(Text(fileInfo.intitule)),
                        DataCell(Text(fileInfo.categorie)),
                        DataCell(Text(fileInfo.type)),
                        DataCell(Text(participant.matricule)),
                        DataCell(Text(participant.nom)),
                        DataCell(Text(participant.prenom)),
                        DataCell(Text(participant.fonction)),
                        DataCell(Text(participant.csp)),
                        DataCell(Text(participant.structure)),
                        DataCell(Text(participant.pole)),
                        DataCell(Text(fileInfo.date_debut)),
                        DataCell(Text(fileInfo.date_fin)),
                        DataCell(Text(participant.presence ? "Présent" : "Absent")),
                        DataCell(Text(participant.etat)), 
                        DataCell(Text(evaluation?.duree ?? 'N/A')),
                        DataCell(Text(evaluation?.duree ?? 'N/A')),
                        DataCell(Text(fileInfo.organisme)),
                        DataCell(Text(fileInfo.code_tiers)),
                        DataCell(Text(fileInfo.coutParPersonne.toStringAsFixed(2))),
                        DataCell(Text(fileInfo.cout_total)),
                        DataCell(Text(fileInfo.bc)),
                        DataCell(Text(fileInfo.facturepedagogique)),
                        DataCell(Text(fileInfo.numero_facture)),
                        DataCell(Text(fileInfo.organisme_logistique)),
                        DataCell(Text(fileInfo.facture_hotel)),
                        DataCell(Text(fileInfo.cout_logistique)),
                        DataCell(Text(evaluation != null ? getAppreciation(evaluation.tauxEvaluation) : 'N/A')),
                        DataCell(Text(evaluation?.tauxEvaluation.toString() ?? 'N/A')),
                        DataCell(Text(evaluationsF?.date ?? '')),
                        DataCell(Text(evaluationsF?.taux_satisfaction ?? '')),
                        DataCell(Text(fileInfo.enjeu)),
                        DataCell(Text(fileInfo.responsable)),
                      ],
                    );
                  }).toList();
                }).toList(),
              ),
            ),
          );
        }
      },
    );
  }
}
