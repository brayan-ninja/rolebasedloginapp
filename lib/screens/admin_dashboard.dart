import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Add in pubspec.yaml
import 'package:firebase_auth/firebase_auth.dart';




class PharmaGoDashboard extends StatefulWidget {
  @override
  _PharmaGoDashboardState createState() => _PharmaGoDashboardState();
}

class _PharmaGoDashboardState extends State<PharmaGoDashboard>{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

final Map<String, String> drawerRoutes = {
  'List': '/list',
  'Orders': '/orders',
  'Delivery': '/delivery',
  'Medical Store': '/medicalstore',
  'Settings': '/settings',
  'Notifications': '/notifications',
};



  final Map<String, String> stats = {
    "Medicine Store": "120",
    "Delivery Boys": "15",
    "Active Orders": "35",
    "Pending Orders": "8",
    "Medicine": "230"
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: Drawer(
  backgroundColor: Colors.black,
  child: Column(
    children: [
      const DrawerHeader(
        decoration: BoxDecoration(color: Colors.black),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage("assets/images/logo.jpg"),
              radius: 30,
            ),
            SizedBox(height: 10),
            Text(
              'PharmaGo Menu',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
      Expanded(
        child: ListView(
          padding: EdgeInsets.zero,
          children: drawerRoutes.entries.map((entry) {
            return ListTile(
              title: Text(entry.key, style: const TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context); // close drawer
                Navigator.pushNamed(context, entry.value); // navigate
              },
            );
          }).toList(),
        ),
      ),
      const Divider(color: Colors.white),
      ListTile(
        leading: const Icon(Icons.logout, color: Colors.greenAccent),
        title: const Text('Logout', style: TextStyle(color: Color.fromARGB(255, 255, 243, 243))),
        onTap: () async {
  await FirebaseAuth.instance.signOut();
  Navigator.pushReplacementNamed(context, '/login'); // Or your login screen
},
      ),
      const SizedBox(height: 10),
    ],
  ),
),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: Row(
          children: [
            Image.asset("assets/images/logo.jpg", height: 30), // logo
            const SizedBox(width: 10),
            const Text('PharmaGo',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Boxes
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: stats.entries.map((entry) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.all(16),
                  width: MediaQuery.of(context).size.width / 2 - 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Colors.amber, width: 3),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: const Offset(0, 5),
                      )
                    ],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(entry.key,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(entry.value,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green)),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            // Bar Graph Title
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Order Stats",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            // Bar Graph
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(show: true, bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, _) {
                        final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                        return Text(days[value.toInt()]);
                      },
                    ),
                  )),
                  barGroups: List.generate(7, (index) {
                    return BarChartGroupData(x: index, barRods: [
                      BarChartRodData(
                        toY: (10 + index * 5).toDouble(),
                        color: Colors.greenAccent,
                        width: 15,
                        borderRadius: BorderRadius.circular(6),
                      )
                    ]);
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
