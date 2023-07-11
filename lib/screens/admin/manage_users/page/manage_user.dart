import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../services/firestore_user_methods.dart';

class ManageUsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firestoreMethodsUsers =
        Provider.of<FirestoreMethodsUsers>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Users')),
      body: FutureBuilder(
        future: firestoreMethodsUsers.getUsersByRole('user'),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          print('manage users');
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          print(snapshot.data!.docs);
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              var user = snapshot.data!.docs[index];
              return Card(
                child: ListTile(
                  title: Text(user['name']),
                  subtitle: Text(
                      'Email: ${user['email']}\nAge: ${user['age']}\nGender: ${user['gender']}'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // Navigate to view user details
                    },
                    child: const Text('View'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
