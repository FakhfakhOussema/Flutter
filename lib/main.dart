import 'package:app_examen/CRM%20Medical/modules/Doctor/doctor_screen.dart';
import 'package:app_examen/CRM%20Medical/modules/Home/home_screen.dart';
import 'package:app_examen/CRM%20Medical/modules/Meeting/meeting_screen.dart';
import 'package:app_examen/CRM%20Medical/modules/medication/medication_screen.dart';
import 'package:app_examen/CRM%20Medical/modules/seetings/seeting_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'CRM Medical/modules/login/login_screen.dart';
import 'CRM Medical/modules/MLKit/face_verification/face_verification_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final routes = {
    '/Medication': (context) => MedicationScreen(),
    '/home': (context) => HomeScreen(),
    '/Login': (context) => LoginScreen(),
    '/doctors': (context) => DoctorScreen(),
    '/meeting': (context) => MeetingScreen(),
    '/Seetings': (context) => SeetingScreen(),
    '/faceVerification': (context) => const FaceVerificationScreen(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "CRM App",
      routes: routes,
      home: HomeScreen(),
      /*/home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, authSnapshot) {
          if (authSnapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (authSnapshot.hasData) {
            return HomeScreen(); // Déjà connecté
          } else {
            return const FaceVerificationScreen(); // Doit prouver qu'il est humain
          }
        },
      ),*/
    );
  }
}
