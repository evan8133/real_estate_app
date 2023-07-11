import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../router/router.gr.dart';
import '../../../../services/firestore_user_methods.dart';

class ManageAgentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firestoreMethodsUsers =
        Provider.of<FirestoreMethodsUsers>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Agents')),
      body: FutureBuilder(
        future: firestoreMethodsUsers.getUsersByRole('agent'),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              var agent = snapshot.data!.docs[index];
              var data = agent.data() as Map<String, dynamic>;
              return Card(
                child: ListTile(
                  title: Text(agent['name']),
                  subtitle: Text(
                      'Email: ${agent['email']}\nAge: ${agent['age']}\nGender: ${agent['gender']}'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      context.router.push(AgentdetailsRoute(agent: data));
                    },
                    child: const Text('View'),
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
        child: const Icon(Icons.add),
      ),
    );
  }
}
