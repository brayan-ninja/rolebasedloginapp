import 'package:flutter/material.dart';
import 'package:login_register_app/screens/admin_dashboard.dart';
import 'package:login_register_app/screens/register_screen.dart';
import 'package:login_register_app/screens/reset_password.dart';
import 'package:login_register_app/screens/user_dasboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();

  LoginScreen({super.key});

  Future<void> login(BuildContext context) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Sign in with email and password
      final userCred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailCtrl.text.trim(),
        password: passCtrl.text.trim(),
      );

      // Check if email is verified
      if (userCred.user != null && !userCred.user!.emailVerified) {
        // Close loading indicator
        Navigator.pop(context);
        
        // Show verification warning
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Email Not Verified'),
            content: const Text('Please verify your email before logging in. Check your inbox for the verification email.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
              TextButton(
                onPressed: () async {
                  await userCred.user!.sendEmailVerification();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Verification email resent!')),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Resend Email'),
              ),
            ],
          ),
        );
        return;
      }

      // Get user role from Firestore
      final roleDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCred.user!.uid)
          .get();

      final role = roleDoc.data()?['role'];

      // Close loading indicator
      Navigator.pop(context);

      // Navigate to appropriate dashboard
      if (role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminHome()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const UserHome()),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Close loading indicator
      Navigator.pop(context);
      
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found with this email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Incorrect password.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is invalid.';
      } else {
        errorMessage = 'Login failed: ${e.message}';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      // Close loading indicator
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: passCtrl,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => login(context),
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                );
              },
              child: const Text('No account? Register'),
            ),
            const SizedBox(height: 7),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ResetPasswordScreen()),
                );
              },
              child: const Text('Forgot Password?'),
            ),
          ],
        ),
      ),
    );
  }
}