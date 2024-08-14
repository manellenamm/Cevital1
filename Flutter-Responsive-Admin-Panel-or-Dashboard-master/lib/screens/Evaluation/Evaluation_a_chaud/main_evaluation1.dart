import 'package:admin/responsive.dart';


import 'package:flutter/material.dart';
import 'package:admin/constants.dart';

import 'components/tableau_eval.dart';
import 'components/header1.dart';




class main_evaluation1 extends StatefulWidget {
  @override
  _MainEvaluation1State createState() => _MainEvaluation1State();
}

class _MainEvaluation1State extends State<main_evaluation1> {

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
                        Header2(),
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
                        Tableau (),
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
        ),
      ),
    );
  }
}
