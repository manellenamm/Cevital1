import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class OrienterForm extends StatefulWidget {
  @override
  _OrienterFormState createState() => _OrienterFormState();
}

class _OrienterFormState extends State<OrienterForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'sous_groupe': '',
    'formation': '',
    'date_debut': '',
    'date_fin': '',
    'organisme_formation': '',
    'code_tiers': '',
    'lieu_formation': '',
    'type_formation': '',
    'categorie_formation': '',
    'responsable_hiearchique': '',
    'cout_total': '',
    'NumBc': '',
    'Facture_Pédagogique': '',
    'NuméroFacture_Pédagogique': '',
    'Organisme_logistque': '',
    'Facture_Hotel': '',
    'cout_logistique': '',
    'Enjeu': '',
  };

  List<String> categorieOptions = ['Métier', 'Ordre légal', 'Qualité', 'Transverse'];
  List<String> Organisme_formationOptions = [
    'BI ENGINEERING TECH',
    'BM & GI',
    'BOOST TRAINING CENTER',
    'Centre National des Technologies de Production Plus Propre (CNTPP)',
    'Centre PROFESSIONEL LES HAMADITS',
    'IDLM INSTITUT DU DEVELOPPEMENT DU LEAN MANAGEMENT',
    'INPED',
    'INSTIUT DES EXPERTS EN MANAGEMENT INEM',
    'INSTTUT DES TECHNIQUES DE LINDUSTRIE ET MANAGEMENT ITM',
    'Interne',
    'IT TALANTS SCHOOL',
    'KAIZEN Academy Algérie',
    'PERFERMANCE AND EXCELLENCY',
    'SARL BI ENGINEERING TECH',
    'SIGA SCHOOL',
    'SYKEN COLLEGE',
    'TOP EXCELLENCE',
    'TOUAHRI CHERIF -ETM'
  ];
  List<String> Organisme_logistqueOptions = [
    'AZ HOTEL',
    'HOTEL ATLANTIS',
    'HOTEL CHERA ',
    'HOTEL CRISTAL 2',
    'HOTEL DU NORD',
    'HOTEL RAYA ',
    'HOTEL LE ZEPHIR',
    'HOTEL BRAHMI',
  ];
  List<dynamic> sousGroupeOptions = [];
  List<dynamic> formationOptions = [];
  List<dynamic> responsableOptions = [];
  String? selectedSousGroupe;
  String? selectedFormation;
  String? selectedResponsable;
  String? newOrganismeLogistique;
  String? newFomrationLogistique;

  @override
  void initState() {
    super.initState();
    _fetchSousGroupes();
    _fetchFormations();
    _fetchResponsable();
  }

  final _dateDebutController = TextEditingController();
  final _dateFinController = TextEditingController();
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd'); // Format de date

  Future<void> _selectDate(BuildContext context, TextEditingController controller, String key) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      final String formattedDate = _dateFormat.format(selectedDate);
      setState(() {
        controller.text = formattedDate;
        _formData[key] = formattedDate;  // Mettre à jour les données du formulaire
      });
    }
  }



  Future<void> _fetchSousGroupes() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/groupe/'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        sousGroupeOptions = data['results'];
      });
    } else {
      print('Failed to load sous-groupes');
    }
  }

  Future<void> _fetchFormations() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/formation/'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        formationOptions = data['results'];
      });
    } else {
      print('Failed to load formations');
    }
  }

  Future<void> _fetchResponsable() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/responsable/'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        responsableOptions = data['results'];
      });
    } else {
      print('Failed to load responsables');
    }
  }

  void _addOrganismeLogistique() {
    if (newOrganismeLogistique != null && newOrganismeLogistique!.isNotEmpty) {
      setState(() {
        Organisme_logistqueOptions.add(newOrganismeLogistique!);
        _formData['Organisme_logistque'] = newOrganismeLogistique!;
        newOrganismeLogistique = null;
      });
    }
  }

  void _addFormationLogistique() {
    if (newFomrationLogistique != null && newFomrationLogistique!.isNotEmpty) {
      setState(() {
        Organisme_formationOptions.add(newFomrationLogistique!);
        _formData['Organisme_formation'] = newFomrationLogistique!;
        newFomrationLogistique = null;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/orienter/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(_formData),
      );

      if (response.statusCode == 201) {
        print('Orienter added');
      } else {
        print('Failed to add Orienter');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ajouter une Orientation',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Sous Groupe'),
                items: sousGroupeOptions.map((dynamic sousGroupe) {
                  return DropdownMenuItem<String>(
                    value: sousGroupe['id'].toString(),
                    child: Text(sousGroupe['nom']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedSousGroupe = value;
                    _formData['sous_groupe'] = value!;
                  });
                },
                onSaved: (value) => _formData['sous_groupe'] = value!,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Formation ID'),
                items: formationOptions.map((dynamic formation) {
                  return DropdownMenuItem<String>(
                    value: formation['id_formation'].toString(),
                    child: Text(formation['intitule']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedFormation = value;
                    _formData['formation'] = value!;
                  });
                },
                onSaved: (value) => _formData['formation'] = value!,
              ),
              TextFormField(
                controller: _dateDebutController,
                decoration: InputDecoration(labelText: 'Date Début'),
                onTap: () => _selectDate(context, _dateDebutController, 'date_debut'),
                readOnly: true,
              ),
              TextFormField(
                controller: _dateFinController,
                decoration: InputDecoration(labelText: 'Date Fin'),
                onTap: () => _selectDate(context, _dateFinController, 'date_fin'),
                readOnly: true,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Organisme de Formation'),
                items: Organisme_formationOptions.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _formData['Organisme_formation'] = value!;
                  });
                },
                onSaved: (value) => _formData['Organisme_formation'] = value!,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Organisme Logistique'),
                items: Organisme_logistqueOptions.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _formData['Organisme_logistque'] = value!;
                  });
                },
                onSaved: (value) => _formData['Organisme_logistque'] = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Code Tiers'),
                onSaved: (value) => _formData['code_tiers'] = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Lieu de Formation'),
                onSaved: (value) => _formData['lieu_formation'] = value!,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Type de Formation'),
                items: ['interne', 'externe'].map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _formData['type_formation'] = value!;
                  });
                },
                onSaved: (value) => _formData['type_formation'] = value!,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Catégorie de Formation'),
                items: categorieOptions.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _formData['categorie_formation'] = value!;
                  });
                },
                onSaved: (value) => _formData['categorie_formation'] = value!,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Responsable Hiérarchique'),
                items: responsableOptions.map((dynamic responsable) {
                  return DropdownMenuItem<String>(
                    value: responsable['id'].toString(),
                    child: Text(responsable['nom']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedResponsable = value;
                    _formData['responsable_hiearchique'] = value!;
                  });
                },
                onSaved: (value) => _formData['responsable_hiearchique'] = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Coût Total'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _formData['cout_total'] = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Numéro BC'),
                onSaved: (value) => _formData['NumBc'] = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Facture Pédagogique'),
                onSaved: (value) => _formData['Facture_Pédagogique'] = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Numéro Facture Pédagogique'),
                onSaved: (value) => _formData['NuméroFacture_Pédagogique'] = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Facture Hôtel'),
                onSaved: (value) => _formData['Facture_Hotel'] = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Coût Logistique'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _formData['cout_logistique'] = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Enjeu'),
                onSaved: (value) => _formData['Enjeu'] = value!,
              ),
              TextFormField(
  decoration: InputDecoration(
    labelText: 'Organisme Logistique',
  ),
  onChanged: (value) {
    setState(() {
      newOrganismeLogistique = value;
    });
  },
),
ElevatedButton(
  onPressed: _addOrganismeLogistique,
  child: Text('Ajouter '),
),
SizedBox(height: 16.0),
TextFormField(
  decoration: InputDecoration(
    labelText: 'Organizme de formation',
  ),
  onChanged: (value) {
    setState(() {
      newFomrationLogistique = value;
    });
  },
),
ElevatedButton(
  onPressed: _addFormationLogistique,
  child: Text('Ajouter'),
),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Ajouter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
