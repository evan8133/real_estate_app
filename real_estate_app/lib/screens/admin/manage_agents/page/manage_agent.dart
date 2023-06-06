import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../services/firestore_user_methods.dart';

class ManageAgentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firestoreMethodsUsers =
        Provider.of<FirestoreMethodsUsers>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text('Manage Agents')),
      body: FutureBuilder(
        future: firestoreMethodsUsers.getUsersByRole('agent'),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              var agent = snapshot.data!.docs[index];
              return Card(
                child: ListTile(
                  title: Text(agent['name']),
                  subtitle: Text('Email: ${agent['email']}\nAge: ${agent['age']}\nGender: ${agent['gender']}'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // Navigate to view agent details
                    },
                    child: Text('View'),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement floating action button function here
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
