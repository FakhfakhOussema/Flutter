import 'package:app_examen/CRM%20Medical/modules/Doctor/doctor_screen.dart';
import 'package:app_examen/CRM%20Medical/modules/Home/home_screen.dart';
import 'package:app_examen/CRM%20Medical/modules/medication/medication_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'CRM Medical/modules/login/login_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

  final routes={
    '/medication':(context) => MedicationScreen(),
    '/home':(context) => HomeScreen(),
    '/login':(context) => LoginScreen(),
    '/doctors':(context) => DoctorScreen(),
  };
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: routes,
      title: "CRM App",
      home: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          // Firebase est en cours d'initialisation
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // Si erreur lors de l'initialisation
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text(
                  'Erreur lors de l\'initialisation de Firebase',
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
              ),
            );
          }

          // Firebase initialisé, vérifier l'état de l'utilisateur
          return StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, authSnapshot) {
              if (authSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (authSnapshot.hasData) {
                return HomeScreen();
              } else {
                return LoginScreen();
              }
            },
          );
        },
      ),
    );
  }
}
