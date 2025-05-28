import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login_register_app/screens/admin/addstore_screen.dart';
class MedicalStoreScreen extends StatefulWidget {
  @override
  _MedicalStoreScreenState createState() => _MedicalStoreScreenState();
}

class _MedicalStoreScreenState extends State<MedicalStoreScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAddStoreForm() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddMedicalStoreForm()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Stores'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Approved'),
            Tab(text: 'Unapproved'),
          ],
        ),
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton(
              onPressed: _showAddStoreForm,
              child: const Icon(Icons.add),
            )
          : null,
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildStoreList(true),
          _buildStoreList(false),
        ],
      ),
    );
  }

  Widget _buildStoreList(bool isApproved) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('medicalstores')
          .where('status', isEqualTo: isApproved)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final stores = snapshot.data!.docs;

        return ListView.builder(
          itemCount: stores.length,
          itemBuilder: (context, index) {
            final store = stores[index];
            return Card(
              margin: const EdgeInsets.all(10),
              child: ListTile(
                title: Text(store['storeName']),
                subtitle: Text('${store['address']}\nEmail: ${store['email']}\nDelivery: ${store['deliveryCommission']}%'),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.edit), onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AddMedicalStoreForm(storeDoc: store)),
                      );
                    }),
                    IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () {
                      store.reference.delete();
                    }),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
