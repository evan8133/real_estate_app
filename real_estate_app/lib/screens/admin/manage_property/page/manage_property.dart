import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_estate_app/model/properties_model.dart';

import '../../../../services/firestore_properties_methods.dart';

class ManagePropertiesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final propertyService =
        Provider.of<PropertyService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text('Manage Properties')),
      body: FutureBuilder<List<Property>>(
        future: propertyService.getProperties(),
        builder: (BuildContext context, AsyncSnapshot<List<Property>> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
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
                      // Navigate to view property details
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