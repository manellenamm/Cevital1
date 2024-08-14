import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:admin/constants.dart';
import 'components/headerevaluation3.dart';
import 'components/affichage.dart';



class main_evaluation2 extends StatefulWidget {
  @override
  _MainEvaluation2State createState() => _MainEvaluation2State();
}

class _MainEvaluation2State extends State<main_evaluation2> {
 

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
                        Header1(),
                        if (Responsive.isMobile(context))
                          SizedBox(height: defaultPadding),
                      ],
                    ),
                  ),
                  if (!Responsive.isMobile(context)) SizedBox(width: defaultPadding),
                ],
              ),
              SizedBox(height: defaultPadding),
              SizedBox(height: defaultPadding),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        SizedBox(height: defaultPadding),
                        AffichageFiles(),
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
