
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';


// ... imports remain unchanged
class AddDeliveryBoyScreen extends StatefulWidget {
  @override
  _AddDeliveryBoyScreenState createState() => _AddDeliveryBoyScreenState();
}

class _AddDeliveryBoyScreenState extends State<AddDeliveryBoyScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '', phone = '', idNumber = '', email = '', occupation = '', licenseNumber = '';
  String accessType = 'all';
  String? selectedStoreId;
  bool _isAvailable = true;
  File? _image;
  bool status = true;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _image = File(picked.path));
  }

  Future<String> uploadImageToStorage(File imageFile) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('deliveryboys/${DateTime.now().millisecondsSinceEpoch}.jpg');
    final uploadTask = await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }

  Future<void> _saveDeliveryBoy() async {
    if (!_formKey.currentState!.validate()) return;

    String imageUrl = '';
    if (_image != null) {
      imageUrl = await uploadImageToStorage(_image!);
    }

    final data = {
      'name': name,
      'phone': phone,
      'idNumber': idNumber,
      'email': email,
      'occupation': occupation,
      'licenseNumber': licenseNumber,
      'imageUrl': imageUrl,
      'accessType': accessType,
      'storeRef': accessType == 'specific'
          ? FirebaseFirestore.instance.collection('medicalstores').doc(selectedStoreId)
          : null,
      'status': status,
      'available': _isAvailable,
    };

    await FirebaseFirestore.instance.collection('deliveryboys').add(data);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Delivery boy added successfully!')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Delivery Boy")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                  child: _image == null ? const Icon(Icons.camera_alt, size: 40) : null,
                ),
              ),
              const SizedBox(height: 10),
              _buildTextField('Name', (val) => name = val),
              _buildTextField('Phone', (val) => phone = val),
              _buildTextField('ID Number', (val) => idNumber = val),
              _buildTextField('Email', (val) => email = val),
              _buildTextField('Occupation', (val) => occupation = val),
              _buildTextField('License Number', (val) => licenseNumber = val),
              const SizedBox(height: 10),
              const Text("Access Type"),
              DropdownButtonFormField<String>(
                value: accessType,
                items: ['all', 'specific'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => accessType = val!),
              ),
              if (accessType == 'specific')
                FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance.collection('medicalstores').get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const CircularProgressIndicator();
                    return DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Select Store'),
                      items: snapshot.data!.docs.map((doc) {
                        return DropdownMenuItem(
                          value: doc.id,
                          child: Text(doc['storeName']),
                        );
                      }).toList(),
                      onChanged: (val) => setState(() => selectedStoreId = val),
                      validator: (val) =>
                          accessType == 'specific' && val == null ? 'Store required' : null,
                    );
                  },
                ),
              SwitchListTile(
                title: const Text("Active Status"),
                value: status,
                onChanged: (val) => setState(() => status = val),
              ),
              SwitchListTile(
                title: const Text("Availability"),
                value: _isAvailable,
                onChanged: (val) => setState(() => _isAvailable = val),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _saveDeliveryBoy,
                icon: const Icon(Icons.save),
                label: const Text("Save"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, Function(String) onChanged) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      validator: (val) => val == null || val.isEmpty ? 'Required' : null,
      onChanged: onChanged,
    );
  }
}

