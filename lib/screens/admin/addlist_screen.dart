import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddSpecialistScreen extends StatefulWidget {
  @override
  _AddSpecialistScreenState createState() => _AddSpecialistScreenState();
}

class _AddSpecialistScreenState extends State<AddSpecialistScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '', type = '', description = '', imageUrl = '';

  void saveSpecialist() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance.collection('specialists').add({
        'name': name,
        'type': type,
        'description': description,
        'imageUrl': imageUrl,
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Specialist Added')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Specialist')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                onChanged: (val) => name = val,
                validator: (val) => val!.isEmpty ? 'Enter name' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Type'),
                onChanged: (val) => type = val,
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
              ElevatedButton(onPressed: saveSpecialist, child: Text('Save'))
            ],
          ),
        ),
      ),
    );
  }
}
