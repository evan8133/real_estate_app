import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_estate_app/router/router.gr.dart';
import 'package:real_estate_app/services/firestore_properties_methods.dart';

class AgentDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> agent;

  const AgentDetailsScreen({Key? key, required this.agent}) : super(key: key);

  @override
  _AgentDetailsScreenState createState() => _AgentDetailsScreenState();
}

class _AgentDetailsScreenState extends State<AgentDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agent Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${widget.agent['name']}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Age: ${widget.agent['age']}',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Gender: ${widget.agent['gender']}',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Phone: ${widget.agent['phone']}',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Email: ${widget.agent['email']}',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Agent Properties',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  setState(() {});
                },
                child: ListView.builder(
                  itemCount: widget.agent['listedProperties'].length,
                  itemBuilder: (context, index) {
                    final propId = widget.agent['listedProperties'][index];

                    return FutureBuilder(
                      future:
                          context.read<PropertyService>().getProperty(propId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return const Center(
                              child: Text('Something went wrong!'));
                        }
                        final property = snapshot.data;
                        if (property == null) {
                          return const Center(
                            child: Text('Property not found!'),
                          );
                        }
                        return Card(
                          child: ListTile(
                            title: Text(property.title),
                            subtitle: Text(
                                'Type: ${property.type}\nPrice: ${property.price}'),
                            trailing: ElevatedButton(
                              onPressed: () {
                                context.router.push(
                                  ViewpropertydetailsRoute(property: property),
                                );
                              },
                              child: const Text('View'),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
