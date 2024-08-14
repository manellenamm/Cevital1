import 'package:admin/models/MyFiles.dart';
import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';
import 'file_info_card.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MyFiles extends StatefulWidget {
  const MyFiles({Key? key}) : super(key: key);

  @override
  _MyFilesState createState() => _MyFilesState();
}

class _MyFilesState extends State<MyFiles> {
  
  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController dateDeNaissanceController = TextEditingController();

  @override
  void dispose() {
    nomController.dispose();
    prenomController.dispose();
    dateDeNaissanceController.dispose();
    super.dispose();
  }

  void effectif(String Nom, String Prenom, String dateDeNaissance) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/effectif/create/'), 
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'nom_effectif': Nom,
        'prenom_effectif': Prenom,
        'date_de_naissance ': dateDeNaissance,
      }),
    );
   
    print(dateDeNaissance) ;

    if (response.statusCode == 200) {
      print('Création réussie');
    } else {
      print('La création a échoué ');
    }
  }

  void _showAddNewFormPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: 400,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Nouvel employé"),
                  SizedBox(height: 8),
                  _buildFormationForm(),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Annuler"),
            ),
            ElevatedButton(
              onPressed: () {
                // Soumettre le formulaire ici
                String nom = nomController.text;
                String prenom = prenomController.text;
                String dateDeNaissance = dateDeNaissanceController.text;
                effectif(nom, prenom, dateDeNaissance);
                Navigator.of(context).pop();
              },
              child: Text("Enregistrer"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFormationForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: nomController,
          decoration: InputDecoration(labelText: "Nom"),
        ),
        SizedBox(height: 12),
        TextFormField(
          controller: prenomController,
          decoration: InputDecoration(labelText: "Prénom"),
        ),
        SizedBox(height: 12),
        TextFormField(
                      controller: dateDeNaissanceController,
                      decoration: InputDecoration(labelText: "Date de naissance"),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          String formattedDate = "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                          dateDeNaissanceController.text = formattedDate;
                        }
                      },
                    ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
     final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  primary: Colors.yellow,
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                ),
                onPressed: () {
                  _showAddNewFormPopup(context);
                },
                icon: Icon(
                  Icons.add,
                  color: Colors.black,
                ),
                label: Text(
                  "Ajouter",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Responsive(
        mobile: FileInfoCardGridView(
          crossAxisCount: _size.width < 650 ? 2 : 4,
          childAspectRatio: _size.width < 650 && _size.width > 350 ? 1.3 : 1,
        ),
        tablet: FileInfoCardGridView(),
        desktop: FileInfoCardGridView(
          childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
        ),
      ),
        // Ajoutez ici votre grille de fichiers
      ],
    );
  }
}




class FileInfoCardGridView extends StatelessWidget {
  const FileInfoCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: demoMyFiles.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: childAspectRatio,
        
      ),
      itemBuilder: (context, index) => FileInfoCard(info: demoMyFiles[index]),
    );
  }
}










