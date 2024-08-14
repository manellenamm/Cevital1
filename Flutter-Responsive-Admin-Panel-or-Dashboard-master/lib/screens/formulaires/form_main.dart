import 'package:admin/responsive.dart';


import 'package:flutter/material.dart';
import 'package:admin/constants.dart';
import 'components/effectifs.dart';
import 'components/header3.dart';
import 'components/formation.dart';
import 'components/formateur.dart';
import 'components/sousgroupe.dart';
import 'components/orienter.dart';
import 'components/participantform.dart';
import 'components/dashboard.dart';
import 'components/dashboardbudjet.dart';
import 'components/responsable_hiearchique.dart';





class main_evaluation8 extends StatefulWidget {
  @override
  _MainEvaluation1State createState() => _MainEvaluation1State();
}

class _MainEvaluation1State extends State<main_evaluation8> {

 String intituleFormation = '';
 String dateFormation= '';
 String categorieFormation= '';

  
List<String?> satisfactionObjectifList =[];


  void updateFormationDetails(String newIntitule, String newdate_formation , String newcategorie) {
    setState(() {
      intituleFormation = newIntitule;
      dateFormation =  newdate_formation;
      categorieFormation=  newcategorie ;

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
                         EffectifForm (),
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
                         FormationForm (),
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
                        FormateurForm() ,
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
                        SousGroupeForm() ,
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
                        OrienterForm() ,
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
                       ParticipantFormationForm() ,
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
                          DashboardBudjetsForm() ,
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
                      DashboardForm() ,
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
                          ResponsableForm() ,
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
