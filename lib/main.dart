import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_register_app/firebase_options.dart';
import 'package:login_register_app/screens/front_screen.dart';
import 'package:login_register_app/screens/login_screen.dart';
import 'package:login_register_app/screens/admin_dashboard.dart';
import 'package:login_register_app/screens/user_dasboard.dart';
import 'package:login_register_app/screens/reset_password.dart';
import 'package:login_register_app/screens/admin/list_screen.dart';
import 'package:login_register_app/screens/admin/addmedicine_screen.dart';
import 'package:login_register_app/screens/admin/addlist_screen.dart';
import 'package:login_register_app/screens/admin/medicine_screen.dart';
import 'package:login_register_app/screens/admin/addstore_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'pharmaGo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute:
          FirebaseAuth.instance.currentUser == null ? '/login' : '/user',
      routes: {
        '/login': (context) => LoginScreen(),
        '/admin': (context) => PharmaGoDashboard(),
        '/user': (context) => UserHome(),
        '/frontscreen': (context) => FrontScreen(),
        '/reset-password': (context) => ResetPasswordScreen(),
        '/list': (context) => ListScreen(),
        '/addMedicine' : (context) => AddMedicineScreen (),
        '/addSpecialist': (context) => AddSpecialistScreen (),
        '/medicalstore' : (context) => MedicalStoreScreen (),
        '/addstore' : (context) => AddMedicalStoreForm (),
      },
      
      home: LoginScreen(),
    );
  }
}
