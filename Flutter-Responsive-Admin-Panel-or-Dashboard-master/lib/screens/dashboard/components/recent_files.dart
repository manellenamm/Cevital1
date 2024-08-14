import 'package:flutter/material.dart';
import '../../../constants.dart';
import 'package:admin/models/RecentFile.dart';

class RecentFiles extends StatelessWidget {
  const RecentFiles({
    Key? key,
  }) : super(key: key);

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
          SizedBox(
            width: double.infinity,
            child: DataTable(
              columnSpacing: defaultPadding,
              columns: [
                DataColumn(
                  label: Text("Formateur"),
                ),
                DataColumn(
                  label: Text("Début"),
                ),
                DataColumn(
                  label: Text("Fin"),
                ),
                DataColumn(
                  label: Text("Formation"),
                ),
                DataColumn(
                  label: Text("Actions"),
                ),
              ],
              rows: List.generate(
                demoRecentFiles.length,
                (index) => recentFileDataRow(context, demoRecentFiles[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

DataRow recentFileDataRow(BuildContext context, RecentFile fileInfo) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(fileInfo.title!),
            ),
          ],
        ),
      ),
      DataCell(Text(fileInfo.date!)),
      DataCell(Text(fileInfo.size!)),
      DataCell(Text(fileInfo.formateurs!)),
      DataCell(
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.add, color: Colors.yellow),
              onPressed: () {
                _showAddFormDialog(context);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Color(0xFF014F8F),),
              onPressed: () {
                // Action à exécuter lors du clic sur le bouton "Supprimer"
              },
            ),
          ],
        ),
      ),
    ],
  );
}

void _showAddFormDialog(BuildContext context) {
  TextEditingController _dateController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Ajouter une nouvelle formation"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Nouvelle Formation"),
                    TextFormField(
                      decoration: InputDecoration(labelText: "Nom"),
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: "Description"),
                    ),
                    SizedBox(height: 20),
                    Text("Formateur"),
                    TextFormField(
                      decoration: InputDecoration(labelText: "Nom"),
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: "Prénom"),
                    ),
                    TextFormField(
                      controller: _dateController,
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
                          _dateController.text = formattedDate;
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () {
              // Action à exécuter lors du clic sur le bouton "Ajouter"
              Navigator.of(context).pop();
            },
            child: Text("Ajouter"),
          ),
        ],
      );
    },
  );
}