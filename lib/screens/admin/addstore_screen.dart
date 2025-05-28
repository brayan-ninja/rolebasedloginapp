import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddMedicalStoreForm extends StatefulWidget {
  final DocumentSnapshot? storeDoc;

  AddMedicalStoreForm({this.storeDoc});

  @override
  _AddMedicalStoreFormState createState() => _AddMedicalStoreFormState();
}

class _AddMedicalStoreFormState extends State<AddMedicalStoreForm> {
  final _formKey = GlobalKey<FormState>();
  String storeName = '', address = '', email = '',phone = '', deliveryCommission = '';
  bool status = true;
  String? selectedSpecialistId;

  @override
  void initState() {
    super.initState();
    if (widget.storeDoc != null) {
      final data = widget.storeDoc!.data() as Map;
      storeName = data['storeName'];
      address = data['address'];
      email = data['email'];
      phone = data['phone'];
      deliveryCommission = data['deliveryCommission'].toString();
      status = data['status'];
      selectedSpecialistId = (data['specialistId'] as DocumentReference).id;
      
    }
  }

  Future<void> _saveStore() async {
    if (!_formKey.currentState!.validate() || selectedSpecialistId == null) return;
    final data = {
      'storeName': storeName,
      'address': address,
      'email': email,
      'phone': phone,
      'deliveryCommission': double.tryParse(deliveryCommission) ?? 0.0,
      'status': status,
      'specialistId': FirebaseFirestore.instance.doc('specialists/$selectedSpecialistId'),
      
      
    };

    if (widget.storeDoc != null) {
      await widget.storeDoc!.reference.update(data);
    } else {
      await FirebaseFirestore.instance.collection('medicalstores').add(data);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.storeDoc != null ? 'Edit Store' : 'Add Store')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: storeName,
                decoration: const InputDecoration(labelText: 'Store Name'),
                onChanged: (val) => storeName = val,
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                initialValue: address,
                decoration: const InputDecoration(labelText: 'Address'),
                onChanged: (val) => address = val,
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                initialValue: email,
                decoration: const InputDecoration(labelText: 'Email'),
                onChanged: (val) => email = val,
                validator: (val) => val!.contains('@') ? null : 'Invalid email',
              ),
              TextFormField(
                initialValue: phone,
                decoration: const InputDecoration(labelText: 'Phone'),
                onChanged: (val) => phone = val,
              ),
              TextFormField(
                initialValue: deliveryCommission,
                decoration: const InputDecoration(labelText: 'Delivery Commission (%)'),
                keyboardType: TextInputType.number,
                onChanged: (val) => deliveryCommission = val,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text("Status:"),
                  Switch(value: status, onChanged: (val) => setState(() => status = val)),
                ],
              ),
              const SizedBox(height: 10),
              FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance.collection('specialists').get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const CircularProgressIndicator();
                  final docs = snapshot.data!.docs;
                  return DropdownButtonFormField<String>(
                    value: selectedSpecialistId,
                    decoration: const InputDecoration(labelText: 'Specialist'),
                    items: docs.map((doc) {
                      return DropdownMenuItem(
                        value: doc.id,
                        child: Text(doc['name']),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => selectedSpecialistId = val),
                    validator: (val) => val == null ? 'Select a specialist' : null,
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Save Store'),
                onPressed: _saveStore,
              )
            ],
          ),
        ),
      ),
    );
  }
}
