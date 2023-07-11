import 'package:flutter/material.dart';

class UserDetialsScreen extends StatefulWidget {
  final Map<String, dynamic> user;

  const UserDetialsScreen({Key? key, required this.user}) : super(key: key);

  @override
  _UserDetialsScreenState createState() => _UserDetialsScreenState();
}

class _UserDetialsScreenState extends State<UserDetialsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          children: [
            _buildInfoCard(
              label: 'Name',
              value: widget.user['name'],
            ),
            _buildInfoCard(
              label: 'Age',
              value: widget.user['age'].toString(),
            ),
            _buildInfoCard(
              label: 'Gender',
              value: widget.user['gender'],
            ),
            _buildInfoCard(
              label: 'Phone',
              value: widget.user['phone'],
            ),
            _buildInfoCard(
              label: 'Email',
              value: widget.user['email'],
            ),
            _buildInfoCard(
              label: 'Role',
              value: widget.user['role'],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({required String label, required String value}) {
    return Card(
      elevation: 2.0,
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 8.0),
            FittedBox(
              child: Text(
                value,
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
