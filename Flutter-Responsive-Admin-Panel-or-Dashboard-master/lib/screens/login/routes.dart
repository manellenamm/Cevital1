import 'package:flutter/material.dart';
import 'package:admin/screens/dashboard/main/main_screen.dart';
import 'package:admin/screens/Evaluation/Evaluation_a_froid/main/main_screen.dart';
import 'package:admin/screens/Evaluation/Evaluation_a_chaud/main/main_screen.dart';
import 'package:admin/screens/Evaluation/Evaluation_sans_emails/main/main_screen.dart';
import 'package:admin/screens/Suivi/main/main_screen.dart';
import 'package:admin/screens/Inscription/inscription.dart';
import 'package:admin/screens/formulaires/main/main_screen.dart';
import 'login_screen.dart';

class Routes {
  Routes._();

  // Static variables

  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String Evaluation = '/evaluationfroid';
  static const String evaluation = '/evaluationchaud';
  static const String Suivi = '/suivi';
  static const String Inscription = '/inscription';
  static const String evaluer = '/evaluer';
  static const String form = '/form';

  static final routes = <String, WidgetBuilder>{
    login: (BuildContext context) => MyHomePage(),
    dashboard: (BuildContext context) => MainScreen(),
    Evaluation: (BuildContext context) => Main(id: null),
    evaluation: (BuildContext context) => Main2(),
    Suivi: (BuildContext context) => Main3(),
    Inscription: (BuildContext context) => MyHomePage1(),
    evaluer: (BuildContext context) => Main5(),
  };
}

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  Uri uri = Uri.parse(settings.name ?? '');
  String? path = uri.path;

  switch (path) {
    case Routes.dashboard:
      return MaterialPageRoute(builder: (BuildContext context) {
        return MainScreen();
      });

    case Routes.Evaluation:
      var id = uri.queryParameters['id'];
      return MaterialPageRoute(builder: (BuildContext context) => Main(id: id));
    case Routes.evaluation:
      return MaterialPageRoute(builder: (BuildContext context) {
        return Main2();
      });
    case Routes.Suivi:
      return MaterialPageRoute(builder: (BuildContext context) {
        return Main3();
      });
    case Routes.Inscription:
      return MaterialPageRoute(builder: (BuildContext context) {
        return MyHomePage1();
      });

     case Routes.form:
      return MaterialPageRoute(builder: (BuildContext context) {
        return Main8();
      });

      case Routes.evaluer:
      return MaterialPageRoute(builder: (BuildContext context) {
        return Main5();
      });

    default:
      return MaterialPageRoute(builder: (BuildContext context) {
        return MyHomePage();
      });
  }
}
