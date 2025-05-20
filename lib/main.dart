import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login_register_app/firebase_options.dart';
import 'package:login_register_app/screens/front_screen.dart';
import 'package:login_register_app/screens/login_screen.dart';
import 'package:login_register_app/screens/admin_dashboard.dart';
import 'package:login_register_app/screens/user_dasboard.dart';
import 'package:login_register_app/screens/reset_password.dart';

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
      title: 'Genz App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute:
          FirebaseAuth.instance.currentUser == null ? '/login' : '/user',
      routes: {
        '/login': (context) => LoginScreen(),
        '/admin': (context) => AdminHome(),
        '/user': (context) => UserHome(),
        '/frontscreen': (context) => FrontScreen(),
        '/reset-password': (context) => ResetPasswordScreen(),
      },
      home: LoginScreen(),
    );
  }
}
