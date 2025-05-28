import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login_register_app/screens/admin/add_delivery_boy.dart';
class DeliveryBoyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Delivery Boys")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('deliveryboys').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) {
            return Center(child: Text("No delivery boys added yet"));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              return Card(
  child: ListTile(
    leading: CircleAvatar(
      backgroundImage: data['imageUrl'] != null
          ? NetworkImage(data['imageUrl'])
          : null,
      child: data['imageUrl'] == null ? Icon(Icons.person) : null,
    ),
    title: Text(data['name'] ?? 'No name'),
    subtitle: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Phone: ${data['phone'] ?? 'N/A'}"),
        Text("Status: ${data['status'] == true ? 'Active' : 'Inactive'}"),
        Row(
          children: [
            Text("Availability: "),
            GestureDetector(
              onTap: () {
                // Toggle the availability in Firestore
                FirebaseFirestore.instance
                    .collection('deliveryboys')
                    .doc(docs[index].id)
                    .update({'available': !(data['available'] ?? true)});
              },
              child: Icon(
                Icons.circle,
                color: data['available'] == true ? Colors.green : Colors.red,
                size: 16,
              ),
            ),
            SizedBox(width: 6),
            Text(
              data['available'] == true ? "Available" : "Busy",
              style: TextStyle(
                color: data['available'] == true ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ],
    ),
    trailing: Switch(
      value: data['status'] ?? false,
      onChanged: (val) {
        FirebaseFirestore.instance
            .collection('deliveryboys')
            .doc(docs[index].id)
            .update({'status': val});
      },
    ),
  ),
);

            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddDeliveryBoyScreen()),
    );
  },
  child: Icon(Icons.add),
),

    );
  }
}
