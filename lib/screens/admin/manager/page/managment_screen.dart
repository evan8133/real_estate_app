import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:real_estate_app/router/router.gr.dart';

class ManagmentScreen extends StatefulWidget {
  const ManagmentScreen({super.key});

  @override
  _ManagmentScreenState createState() => _ManagmentScreenState();
}

class _ManagmentScreenState extends State<ManagmentScreen> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 1,
      childAspectRatio: 3 / 2,
      padding: const EdgeInsets.all(10.0),
      mainAxisSpacing: 10.0,
      crossAxisSpacing: 5.0,
      children: <Widget>[
        _buildMenuItem(
          "Manage Users",
          Icons.people,
          () {
            context.router.push(const ManageUsersRoute());
          },
        ),
        _buildMenuItem(
          "Manage Agents",
          Icons.account_box,
          () {
            context.router.push(const ManageAgentsRoute());
          },
        ),
        _buildMenuItem(
          "Manage Properties",
          Icons.home_work,
          () {
            context.router.push(const ManagePropertiesRoute());
          },
        ),
      ],
    );
  }

  Card _buildMenuItem(String title, IconData iconData, Function onTap) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              iconData,
              size: 80.0,
              color: Colors.blue,
            ),
            const SizedBox(height: 5.0),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
