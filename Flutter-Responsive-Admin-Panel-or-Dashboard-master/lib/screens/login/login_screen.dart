import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:admin/screens/login/routes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'anmition/fadeanimation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


enum Gender{
  Email,
  password,
}

class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Color enabled = const Color(0xFF827F8A);
  Color enabledtxt = Colors.white;
  Color deaible = Colors.grey;
  Color backgroundColor = const Color(0xFF1F1A30);
  bool ispasswordev = true;
  Gender? selected;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

void authenticateUser(BuildContext context, String email, String password) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:8000/api/login/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    print('Login successful: $data');
    Navigator.pushReplacementNamed(context, Routes.dashboard);
  } else {
    var responseData = jsonDecode(response.body);
    if (responseData.containsKey('non_field_errors') && responseData['non_field_errors'].contains('Invalid email or password.')) {
      // Show alert dialog for invalid credentials
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erreur de connexion'),
            content: Text('Email ou mot de passe invalide. Vous ne disposez pas d\'un compte, veuillez vous inscrire.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      print('Login failed: ${response.body}');
    }
  }
}
  @override
  Widget build(BuildContext context) {
    var we = MediaQuery.of(context).size.width;
    var he = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xFF014F8F),
      body: SingleChildScrollView(
        child: SizedBox(
          width: we,
          height: he,
          child: Column(
            children: <Widget>[
              FadeAnimation(
  delay: 0.8,
  child: Image.asset(
    "assets/images/rectangle_8.png",
    width: we * 0.9,
    height: he * 0.4,
  ),
),
              FadeAnimation(
                delay: 1,
                child: Container(
                  margin: const EdgeInsets.only(right: 230.0),
                ),
              ),
              SizedBox(
                height: he * 0.01,
              ),
              SizedBox(
                height: he * 0.04,
              ),
              FadeAnimation(
                delay: 1,
                child: Container(
                  width: we * 0.9,
                  height: he * 0.071,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: selected == Gender.Email ? Colors.white : backgroundColor,
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: emailController,
                    onTap: () {
                      setState(() {
                        selected = Gender.Email;
                      });
                    },
                    decoration: InputDecoration(
                      enabledBorder: InputBorder.none,
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: selected == Gender.Email ? Colors.black : deaible,
                      ),
                      hintText: 'Email',
                      hintStyle: TextStyle(
                        color: selected == Gender.Email ? Colors.black : deaible,
                      ),
                    ),
                    style: TextStyle(
                      color: selected == Gender.Email ? Colors.black : deaible,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: he * 0.02,
              ),
              FadeAnimation(
                delay: 1,
                child: Container(
                  width: we * 0.9,
                  height: he * 0.071,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: selected == Gender.password ? Colors.white : backgroundColor,
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: passwordController,
                    onTap: () {
                      setState(() {
                        selected = Gender.password;
                      });
                    },
                    decoration: InputDecoration(
                      enabledBorder: InputBorder.none,
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.lock_open_outlined,
                        color: selected == Gender.password ? Colors.black : deaible,
                      ),
                      suffixIcon: IconButton(
                        icon: ispasswordev
                            ? Icon(
                                Icons.visibility_off,
                                color: selected == Gender.password ? Colors.black : deaible,
                              )
                            : Icon(
                                Icons.visibility,
                                color: selected == Gender.password ? enabledtxt : deaible,
                              ),
                        onPressed: () => setState(() => ispasswordev = !ispasswordev),
                      ),
                      hintText: 'Password',
                      hintStyle: TextStyle(
                        color: selected == Gender.password ? Colors.black : deaible,
                      ),
                    ),
                    obscureText: ispasswordev,
                    style: TextStyle(
                      color: selected == Gender.password ? Colors.black : deaible,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: he * 0.07,
              ),
              FadeAnimation(
                delay: 1,
                child: TextButton(
                  onPressed: () {
                    authenticateUser (context ,emailController.text, passwordController.text);
                  },
                  child: Text(
                    "Login",
                    style: GoogleFonts.heebo(
                      color: Colors.black,
                      letterSpacing: 0.5,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Color(0xFFF4CF20),
                    padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 80),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: he * 0.01,
              ),
              FadeAnimation(
                delay: 1.2,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.Inscription);
                  },
                  child: Text(
                    "T'as pas de compte? Inscription",
                    style: GoogleFonts.heebo(
                      color: Colors.white,
                      letterSpacing: 0.5,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: he * 0.01,
              ),
              SizedBox(
                height: he * 0.12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}