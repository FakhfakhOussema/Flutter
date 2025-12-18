
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'CRM Medical/modules/Doctor/doctor_screen.dart';
import 'CRM Medical/modules/Home/home_screen.dart';
import 'CRM Medical/modules/Medication/medication_screen.dart';
import 'CRM Medical/modules/Meeting/meeting_screen.dart';
import 'CRM Medical/modules/Seetings/seeting_screen.dart';
import 'CRM Medical/modules/login/login_screen.dart';
import 'CRM Medical/modules/MLKit/face_verification/face_verification_screen.dart';
import 'CRM Medical/modules/notification/notification_service.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // Définition des routes
  final Map<String, WidgetBuilder> routes = {
    '/Medication': (context) => MedicationScreen(),
    '/home': (context) => HomeScreen(),
    '/Login': (context) => LoginScreen(),
    '/doctors': (context) => DoctorScreen(),
    '/meeting': (context) => MeetingScreen(),
    '/Seetings': (context) => SettingScreen(),
    '/faceVerification': (context) => const FaceVerificationScreen(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "CRM App",
      routes: routes,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, authSnapshot) {
          // Loading screen pendant la vérification
          if (authSnapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // Si l'utilisateur est connecté
          if (authSnapshot.hasData) {
            return HomeScreen();
          } else {
            // Sinon redirection vers la vérification faciale
            return const FaceVerificationScreen();
          }
        },
      ),
    );
  }
}
