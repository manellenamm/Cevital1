import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:admin/screens/login/routes.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        width: 100 ,
        color: Color(0xFF014F8F), // Couleur de fond du Drawer
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // logo Cevital
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF014F8F),
                border: Border.all(
                  color: Color(0xFF014F8F), // Couleur de la bordure
                  width: 1, // Largeur de la bordure (1 pixel)
                ),
              ),
              child: Image.asset("assets/images/rectangle_8.png"),
            ),
            DrawerListTile(
              title: "Dashboard",
              svgSrc: "assets/icons/menu_dashbord.svg",
              press: () {
                // Navigation vers le Dashboard
                Navigator.pushNamed(context, Routes.dashboard); // Mettez à jour cette ligne selon vos routes
              },
            ),
           
            DrawerListTile(
              title: "Évaluation à chaud",
              svgSrc: "assets/icons/menu_setting.svg",
               press: () {
                // Navigation vers le Dashboard
                Navigator.pushNamed(context, Routes.evaluation); // Mettez à jour cette ligne selon vos routes
              },
            ),
             DrawerListTile(
              title: "Évaluation à froid",
              svgSrc: "assets/icons/menu_setting.svg",
               press: () {
                // Navigation vers le Dashboard
                Navigator.pushNamed(context, Routes.Evaluation); // Mettez à jour cette ligne selon vos routes
              },
            ),
             DrawerListTile(
              title: "Tableau de suivi",
              svgSrc: "assets/icons/menu_setting.svg",
               press: () {
                // Navigation vers le Dashboard
                Navigator.pushNamed(context, Routes.Suivi); // Mettez à jour cette ligne selon vos routes
              },
            ),
            DrawerListTile(
              title: "Evaluer les non cadreurs ",
              svgSrc: "assets/icons/menu_setting.svg",
               press: () {
                // Navigation vers le Dashboard
                Navigator.pushNamed(context, Routes.evaluer); // Mettez à jour cette ligne selon vos routes
              },
            ),
              DrawerListTile(
              title: "Formulaire",
              svgSrc: "assets/icons/menu_setting.svg",
               press: () {
                // Navigation vers le Dashboard
                Navigator.pushNamed(context, Routes.form); // Mettez à jour cette ligne selon vos routes
              },
            ),
            
            DrawerListTile(
              title: "Logout",
              svgSrc: "assets/icons/menu_profile.svg",
             press: () {
                // Navigation vers le Dashboard
                Navigator.pushNamed(context, Routes.login); // Mettez à jour cette ligne selon vos routes
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF014F8F),
      child: ListTile(
        onTap: press,
        horizontalTitleGap: 0.0,
        leading: SvgPicture.asset(
          svgSrc,
          color: Colors.black,
          height: 16,
        ),
        title: Text(
          title,
          style: TextStyle(color: Colors.black), // Couleur du texte
        ),
      ),
    );
  }
}
