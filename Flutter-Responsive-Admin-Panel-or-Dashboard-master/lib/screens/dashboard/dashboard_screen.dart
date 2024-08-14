import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import 'components/filtrage.dart';
import 'components/storage_detailscatégorie.dart';
import 'components/storage_detailscsp.dart';
import 'components/dashboard_tab.dart';
import 'components/effectifs.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int? selectedMonth;
  int? selectedYear;

  @override
  void initState() {
    super.initState();
    // Initialize with current month and year if they are not set
    final now = DateTime.now();
    selectedMonth ??= now.month;
    selectedYear ??= now.year;
  }

  void _handleMonthYearSelection(int? month, int? year) {
    setState(() {
      selectedMonth = month;
      selectedYear = year;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Ensure default values are set if null
    final currentMonth = selectedMonth ?? DateTime.now().month;
    final currentYear = selectedYear ?? DateTime.now().year;

    return Scaffold(
      backgroundColor: Color(0xFF014F8F),
      body: SafeArea(
        child: SingleChildScrollView(
          primary: false,
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
                        FilterForm(),
                        if (Responsive.isMobile(context))
                          SizedBox(height: defaultPadding),
                      ],
                    ),
                  ),
                  if (!Responsive.isMobile(context))
                    SizedBox(width: defaultPadding),
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
                        SampleTablePage(
                          Onmonth_yearChanged: _handleMonthYearSelection,
                        ), // Assurez-vous que SampleTablePage accepte onMonthYearChanged
                        if (Responsive.isMobile(context))
                          SizedBox(height: defaultPadding),
                      ],
                    ),
                  ),
                  if (!Responsive.isMobile(context))
                    SizedBox(width: defaultPadding),
                ],
              ),
              SizedBox(height: defaultPadding),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: SizedBox(
                      height:260, // Hauteur fixe pour éviter les problèmes de taille infinie
                      child: EffectifTablePage(
                        selectedMonth: currentMonth,
                        selectedYear: currentYear,
                      ), // Assurez-vous que EffectifTablePage accepte selectedMonth et selectedYear
                    ),
                  ),
                  if (!Responsive.isMobile(context))
                    SizedBox(width: defaultPadding),
                ],
              ),
         
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SizedBox(
                      width: 537,
                      height: 610, // Hauteur fixe
                      child: StorageDetails(
                        selectedMonth: currentMonth,
                        selectedYear: currentYear,


                      ),
                    ),
                  ),
                  SizedBox(width: defaultPadding),
                  Expanded(
                    child: SizedBox(
                      width: 537,
                      height: 610, // Hauteur fixe
                      child: StorageDetailss(

                        selectedMonth: currentMonth,
                        selectedYear: currentYear,

                      ),
                    ),
                  ),
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
