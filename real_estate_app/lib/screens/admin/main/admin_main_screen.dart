import 'package:flutter/material.dart';

class AdminMainScreen extends StatefulWidget {
  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<AdminMainScreen> {
  final List<Map<String, dynamic>> statsData = [
    {"title": "Properties for Sale", "count": 250},
    {"title": "Properties for Rent", "count": 150},
    {"title": "Users", "count": 1200},
    {"title": "Agents", "count": 50},
    {"title": "Admins", "count": 5},
    {"title": "Houses", "count": 300},
    {"title": "Apartments", "count": 100},
    {"title": "Villas", "count": 50},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              children: List.generate(statsData.length,
                  (index) => StatCard(stat: statsData[index])),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final Map<String, dynamic> stat;

  StatCard({required this.stat});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            stat["title"],
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          ),
          Text(
            stat["count"].toString(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
          ),
        ],
      ),
    );
  }
}
