import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_estate_app/model/properties_model.dart';

import '../../../services/firestore_properties_methods.dart';

class AdminMainScreen extends StatefulWidget {
  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<AdminMainScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder(
          future: context.read<PropertyService>().getProperties(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong!'));
            }
            final properties = snapshot.data as List<Property>;
            final findHouseCount = properties.where((e) => e.type == 'House');
            final findApartmentCount =
                properties.where((e) => e.type == 'Apartment');
            final findVillaCount = properties.where((e) => e.type == 'Villa');
            final findRentCount = properties.where((e) => e.forRent);
            final findSaleCount = properties.where((e) => e.forSale);
            return Column(
              children: [
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  children: [
                    StatCard(
                      stat: {
                        'title': 'Total Properties',
                        'count': properties.length,
                      },
                    ),
                    StatCard(
                      stat: {
                        'title': 'Total Houses',
                        'count': findHouseCount.length,
                      },
                    ),
                    StatCard(
                      stat: {
                        'title': 'Total Apartments',
                        'count': findApartmentCount.length,
                      },
                    ),
                    StatCard(
                      stat: {
                        'title': 'Total Villas',
                        'count': findVillaCount.length,
                      },
                    ),
                    StatCard(
                      stat: {
                        'title': 'Total Rentals',
                        'count': findRentCount.length,
                      },
                    ),
                    StatCard(
                      stat: {
                        'title': 'Total Sales',
                        'count': findSaleCount.length,
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final Map<String, dynamic> stat;

  StatCard({required this.stat});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      color: Theme.of(context)
          .colorScheme
          .secondary, // Change the color to match your admin theme
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              stat["title"],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Colors
                    .white, // Change the text color to white or a suitable color for visibility
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              stat["count"].toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
                color: Colors
                    .white, // Change the text color to white or a suitable color for visibility
              ),
            ),
          ],
        ),
      ),
    );
  }
}
