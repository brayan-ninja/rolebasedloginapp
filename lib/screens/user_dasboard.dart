import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_register_app/screens/front_screen.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> with SingleTickerProviderStateMixin {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    // Delay to let the image fade in
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("PharmaGO"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              // ignore: use_build_context_synchronously
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          AnimatedOpacity(
  duration: const Duration(seconds: 2),
  opacity: _opacity,
  child: SizedBox(
    height: screenHeight * 0.8,
    width: double.infinity,
    child: ClipRRect(
      borderRadius: BorderRadius.zero, // Optional, for rounded corners
      child: Image.asset(
        "assets/images/home2.jpg",
        fit: BoxFit.cover, // Ensures the image covers the whole box
        width: double.infinity,
        height: double.infinity,
      ),
    ),
  ),
),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/frontscreen'); // Replace with your target route
            },
            child: const Text("Get Started"),
          ),
        ],
      ),
    );
  }
}
