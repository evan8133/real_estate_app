import 'dart:developer';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../model/properties_model.dart';
import '../../../../services/firestore_properties_methods.dart';
import '../widget/property_card.dart';

class MainScreen extends StatefulWidget {
  MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<String> imageUrls = [];
  FirebaseStorage storage = FirebaseStorage.instance;
  Future<List<String>> fetchPropertyImages(String properteId) async {
    try {
      final ListResult result =
          await storage.ref('house/$properteId/images').listAll();

      final List<String> urls = [];
      for (final ref in result.items) {
        final imageUrl = await ref.getDownloadURL();
        urls.add(imageUrl);
      }
      return urls;
    } catch (e) {
      log('Failed to fetch property images: $e');
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    PropertyService properties = context.read<PropertyService>();
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: FutureBuilder<List<Property>>(
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
              addAutomaticKeepAlives: true,
              cacheExtent: 100000,
              crossAxisCount: 1,
              itemCount: properties?.length,
              itemBuilder: (BuildContext context, int index) {
                final property = properties![index];
                return FutureBuilder(
                  future: fetchPropertyImages(property.propertyId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: PropertyCard(property: property),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    property.imageUrls = snapshot.data as List<String>;
                    return PropertyCard(
                      property: property,
                    );
                  },
                );
              },
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
            ),
          );
        },
      ),
    );
  }
}
