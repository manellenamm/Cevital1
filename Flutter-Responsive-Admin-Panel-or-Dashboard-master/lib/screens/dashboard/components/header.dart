import 'package:admin/controllers/MenuAppController.dart';
import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          if (!Responsive.isDesktop(context))
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: context.read<MenuAppController>().controlMenu,
            ),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: SearchField(), // Ajouter le widget SearchField ici
            ),
          ),
          if (!Responsive.isMobile(context))
            Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
        ],
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF014F8F),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search",
          fillColor: Colors.white
              .withOpacity(0.2), // Couleur de remplissage du TextField
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.white, // Couleur de la bordure
              width: 1.0, // Largeur de la bordure
            ),
          ),
      
          suffixIcon: InkWell(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: SvgPicture.asset(
                "assets/icons/Search.svg",
                height: 20,
                color: Colors.white
                    .withOpacity(0.2), // Couleur de l'icône de recherche
              ),
            ),
          ),
        ),
      ),
    );
  }
}
