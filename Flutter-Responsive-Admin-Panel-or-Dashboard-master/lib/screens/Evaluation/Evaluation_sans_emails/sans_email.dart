import 'package:admin/responsive.dart';
import 'package:admin/screens/Evaluation/Evaluation_sans_emails/components/afficher.dart';
import 'package:admin/screens/Evaluation/Evaluation_sans_emails/components/evaluer.dart';
import 'package:flutter/material.dart';
import 'package:admin/constants.dart';
import 'components/header.dart';
import 'components/header3.dart';

class main_evaluation3 extends StatefulWidget {
  @override
  _MainEvaluation3State createState() => _MainEvaluation3State();
}

class _MainEvaluation3State extends State<main_evaluation3> {
  int? selectedid_participant;
  String? selectedid_orientation;

  void _handleSelection(List<Map<String, dynamic>> participantIds) {
    setState(() {
      if (participantIds.isNotEmpty) {
        selectedid_orientation = participantIds.first['orienter_id'] as String?;
        selectedid_participant = participantIds.first['participant_id'] as int?;
      } else {
        selectedid_orientation = null;
        selectedid_participant = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF014F8F),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              Header(),
              SizedBox(height: defaultPadding),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        SizedBox(height: defaultPadding),
                        Header3(),
                        if (Responsive.isMobile(context))
                          SizedBox(height: defaultPadding),
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
                        AfficherForm(
                          Sans_emailChanged: _handleSelection,
                        ),
                        if (Responsive.isMobile(context))
                          SizedBox(height: defaultPadding),
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
                        // Afficher les valeurs sélectionnées
                        evaluerForm(
                          participantId: selectedid_participant,
                          orienterId: selectedid_orientation,
                        ),
                        if (Responsive.isMobile(context))
                          SizedBox(height: defaultPadding),
                      ],
                    ),
                  ),
                  if (!Responsive.isMobile(context)) SizedBox(width: defaultPadding),
                ],
              ),
              SizedBox(height: defaultPadding),
            ],
          ),
        ),
      ),
    );
  }
}
