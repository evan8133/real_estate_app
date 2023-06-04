import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

import '../../../../model/properties_model.dart';
import '../../../../services/firestore_properties_methods.dart';
import '../widget/property_card.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    PropertyService properties = Provider.of<PropertyService>(context);
    return FutureBuilder<List<Property>>(
      future: properties.getProperties(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final properties = snapshot.data;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: MasonryGridView.count(
            crossAxisCount: 1,
            itemCount: properties?.length,
            itemBuilder: (BuildContext context, int index) {
              final property = properties![index];
              return PropertyCard(property: property);
            },
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
          ),
        );
      },
    );
  }
}
