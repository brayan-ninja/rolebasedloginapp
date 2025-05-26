

import 'package:flutter/material.dart';

// ignore: unused_import
import 'package:login_register_app/screens/admin/addlist_screen.dart';
import 'package:login_register_app/screens/admin/addmedicine_screen.dart';


class ListScreen extends StatelessWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('List'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Specialists Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Specialist",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.teal),
                  onPressed: () {
                    Navigator.pushNamed(context, '/addSpecialist');
                  },
                ),
              ],
            ),
            // Placeholder List
            Container(
              height: 100,
              color: Colors.grey.shade100,
              child: const Center(child: Text("No specialists added yet")),
            ),
            const SizedBox(height: 30),

            // Medicines Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Medicine",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.teal),
                  onPressed: () {
                    Navigator.pushNamed(context, '/addMedicine');
                  },
                ),
              ],
            ),
            Container(
              height: 100,
              color: Colors.grey.shade100,
              child: const Center(child: Text("No medicines added yet")),
            ),
          ],
        ),
      ),
    );
  }
}
