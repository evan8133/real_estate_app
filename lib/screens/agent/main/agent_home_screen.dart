import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../model/properties_model.dart';
import '../../../router/router.gr.dart';
import '../../../services/firebase_auth_methods.dart';
import '../../../services/firestore_properties_methods.dart';

class AgentHomeScreen extends StatefulWidget {
  const AgentHomeScreen({super.key});

  @override
  State<AgentHomeScreen> createState() => _AgentHomeScreenState();
}

class _AgentHomeScreenState extends State<AgentHomeScreen> {
  late Future<List<Property>> _allPropertiesFuture;
  late Future<List<DocumentSnapshot>> _userPropertiesFuture;
  List<String> _userPropertyIds = []; // List to store user property IDs

  @override
  void initState() {
    super.initState();
    _allPropertiesFuture = context.read<PropertyService>().getProperties();
    _userPropertiesFuture = context
        .read<FirebsaeAuthMethods>()
        .getUserProperties(context.read<FirebsaeAuthMethods>().user.uid)
        .then((userProperties) {
      setState(() {
        // Extract the property IDs from the user properties
        _userPropertyIds =
            userProperties.map((property) => property.id).toList();
      });
      return userProperties;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _allPropertiesFuture =
              context.read<PropertyService>().getProperties();
          _userPropertiesFuture = context
              .read<FirebsaeAuthMethods>()
              .getUserProperties(context.read<FirebsaeAuthMethods>().user.uid)
              .then((userProperties) {
            setState(() {
              _userPropertyIds =
                  userProperties.map((property) => property.id).toList();
            });
            return userProperties;
          });
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<Property>>(
          future: _allPropertiesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Shimmer(
                loop: 3,
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                    Theme.of(context).colorScheme.surface,
                    Theme.of(context).colorScheme.tertiary,
                  ],
                ),
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        title: Container(
                          height: 16.0,
                        ),
                        subtitle: Container(
                          height: 12.0,
                        ),
                        trailing: const SizedBox(
                          width: 80.0,
                          height: 36.0,
                        ),
                      ),
                    );
                  },
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              // Property list UI
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        Property data =
                            Property.fromJson(snapshot.data![index].toJson());
                        // Check if the property ID is in the userPropertyIds list
                        bool isEditable = _userPropertyIds.contains(snapshot.data![index].propertyId);
                        return GestureDetector(
                          onTap: () {
                            context.router.push(
                              PropertydetailRoute(
                                properteId: snapshot.data![index].propertyId,isEditable:isEditable
                              ),
                            );
                          },
                          child: Card(
                            child: ListTile(
                              title: Text(data.title),
                              subtitle: Text('Price: ${data.price}'),
                              trailing: Text(
                                'Type: ${data.type}\nStatus: ${data.status}',
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