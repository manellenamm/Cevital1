import 'package:flutter/material.dart';
import 'package:admin/constants.dart';


class Affectation extends StatelessWidget {
  final String structure;
  final String service;

  const Affectation({
    Key? key,
    required this.structure,
    required this.service,
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
                  label: Container(
                    width: 200, // Limite la largeur à 200 pixels
                    child: Text(
                      "Affectation",
                      style: TextStyle(fontWeight: FontWeight.bold),
                      softWrap: true,
                    ),
                  ),
                ),
                DataColumn(
                  label: Container(
                    width: 200, // Limite la largeur à 200 pixels
                  ),
                ),
              ],
              rows: [
                DataRow(
                  cells: [
                    DataCell(Text('Structure')),
                    DataCell(Text(structure)),
                  ],
                ),
                DataRow(
                  cells: [
                    DataCell(Text('Service')),
                    DataCell(Text(service)),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: defaultPadding),
        ],
      ),
    );
  }
}
