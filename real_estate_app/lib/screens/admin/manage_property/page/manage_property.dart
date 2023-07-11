import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_estate_app/model/properties_model.dart';

import '../../../../router/router.gr.dart';
import '../../../../services/firestore_properties_methods.dart';

class ManagePropertiesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final propertyService =
        Provider.of<PropertyService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Properties')),
      body: FutureBuilder<List<Property>>(
        future: propertyService.getProperties(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Property>> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) {
              var property = snapshot.data![index];
              return Card(
                child: ListTile(
                  title: Text(property.title),
                  subtitle: Text(
                      'Type: ${property.type}\nPrice: ${property.price}\nFor Sale: ${property.forSale ? 'Yes' : 'No'}\nFor Rent: ${property.forRent ? 'Yes' : 'No'}'),
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
    );
  }
}
