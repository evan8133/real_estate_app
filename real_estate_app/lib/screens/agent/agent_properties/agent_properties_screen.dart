import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_estate_app/router/router.gr.dart';
import 'package:real_estate_app/services/firebase_auth_methods.dart';

class AgentPropertiesScreen extends StatefulWidget {
  const AgentPropertiesScreen({Key? key}) : super(key: key);

  @override
  State<AgentPropertiesScreen> createState() => _AgentPropertiesScreenState();
}

class _AgentPropertiesScreenState extends State<AgentPropertiesScreen> {
  late Future<List<DocumentSnapshot>> _propertiesFuture;

  @override
  void initState() {
    super.initState();
    _propertiesFuture = context.read<FirebsaeAuthMethods>().getUserProperties(
          context.read<FirebsaeAuthMethods>().user.uid,
        );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _propertiesFuture = context
              .read<FirebsaeAuthMethods>()
              .getUserProperties(context.read<FirebsaeAuthMethods>().user.uid);
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<DocumentSnapshot>>(
          future: _propertiesFuture,
          builder: (BuildContext context,
              AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context.router.push(
                          const AddpropertyRoute(),
                        );
                      },
                      child: const Text('Add Property'),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        Map<String, dynamic> data = snapshot.data![index].data()
                            as Map<String, dynamic>;
                        return GestureDetector(
                          onTap: () {
                            context.router.push(
                              PropertydetailRoute(
                                properteId: snapshot.data![index].id,
                              ),
                            );
                          },
                          child: Card(
                            child: ListTile(
                              title: Text(data['title']),
                              subtitle: Text('Price: ${data['price']}'),
                              trailing: Text(
                                'Type: ${data['type'] ?? 'N/A'}\nStatus: ${data['status']}',
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
