import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddMedicineScreen extends StatefulWidget {
  @override
  _AddMedicineScreenState createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '', description = '', imageUrl = '';
  int inventory = 0;
  String? selectedSpecialistId;

  void saveMedicine() async {
    if (_formKey.currentState!.validate() && selectedSpecialistId != null) {
      await FirebaseFirestore.instance.collection('medicines').add({
        'name': name,
        'inventory': inventory,
        'description': description,
        'imageUrl': imageUrl,
        'specialistId': FirebaseFirestore.instance.doc('specialists/$selectedSpecialistId'),
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Medicine Added')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Medicine')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance.collection('specialists').get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  return DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Select Specialist'),
                    value: selectedSpecialistId,
                    items: snapshot.data!.docs.map((doc) {
                      return DropdownMenuItem(
                        value: doc.id,
                        child: Text(doc['name']),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => selectedSpecialistId = val),
                    validator: (val) => val == null ? 'Please select a specialist' : null,
                  );
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Medicine Name'),
                onChanged: (val) => name = val,
                validator: (val) => val!.isEmpty ? 'Enter name' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Inventory'),
                keyboardType: TextInputType.number,
                onChanged: (val) => inventory = int.tryParse(val) ?? 0,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                onChanged: (val) => description = val,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Image URL'),
                onChanged: (val) => imageUrl = val,
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: saveMedicine, child: Text('Save'))
            ],
          ),
        ),
      ),
    );
  }
}
