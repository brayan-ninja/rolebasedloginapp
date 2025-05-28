import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.teal),
                  onPressed: () {
                    Navigator.pushNamed(context, '/addSpecialist');
                  },
                ),
              ],
            ),
            SizedBox(
              height: 100,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('specialists').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                  final docs = snapshot.data!.docs;

                  if (docs.isEmpty) return const Center(child: Text("No specialists added yet"));

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final specialist = docs[index].data() as Map<String, dynamic>;
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(specialist['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text(specialist['type']),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 30),

            // Medicines Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Medicine",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.teal),
                  onPressed: () {
                    Navigator.pushNamed(context, '/addMedicine');
                  },
                ),
              ],
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('medicine').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                  final docs = snapshot.data!.docs;

                  if (docs.isEmpty) return const Center(child: Text("No medicines added yet"));

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final medicine = docs[index].data() as Map<String, dynamic>;
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text(medicine['medName']),
                          subtitle: Text('Inventory: ${medicine['inventory']}'),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
