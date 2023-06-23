import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:real_estate_app/model/properties_model.dart';

import '../../../services/firestore_properties_methods.dart';

class AgentProperteDetailScreen extends StatefulWidget {
  final String properteId;

  const AgentProperteDetailScreen({Key? key, required this.properteId})
      : super(key: key);

  @override
  _AgentPropertyDetailScreenState createState() =>
      _AgentPropertyDetailScreenState();
}

class _AgentPropertyDetailScreenState extends State<AgentProperteDetailScreen> {
  List<String> imageUrls = [];
  FirebaseStorage storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    fetchPropertyImages();
  }

  Future<void> fetchPropertyImages() async {
    try {
      final ListResult result =
          await storage.ref('house/${widget.properteId}/images').listAll();

      final List<String> urls = [];
      for (final ref in result.items) {
        final imageUrl = await ref.getDownloadURL();
        urls.add(imageUrl);
      }

      setState(() {
        imageUrls = urls;
      });
    } catch (e) {
      print('Failed to fetch property images: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Property Detail'),
        actions: [
          IconButton(
            onPressed: () {
              // context.router.push(
              //   EditPropertyRoute(
              //     propertyId: widget.properteId,
              //   ),
              // );
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<Property>(
          future:
              context.read<PropertyService>().getProperty(widget.properteId),
          builder: (BuildContext context, AsyncSnapshot<Property> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error ${snapshot.error}'));
            }
            if (snapshot.data == null) {
              return const Center(child: Text('No data'));
            }
            final Property property = snapshot.data!;
            return ListView(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    height: 200,
                    viewportFraction: 1.0,
                    enableInfiniteScroll: true,
                    autoPlay: true,
                    aspectRatio: 2.0,
                  ),
                  items: imageUrls.map((url) {
                    return CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) {
                        log(error.toString());
                        return const Icon(Icons.error);
                      },
                      placeholder: (context, url) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    property.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Description:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(property.description),
                const SizedBox(height: 16),
                Text(
                  'Status: ${property.status}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Location:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: GoogleMap(
                    rotateGesturesEnabled: false,
                    scrollGesturesEnabled: false,
                    markers: {
                      Marker(
                        infoWindow: InfoWindow(
                          title: property.title,
                          snippet: property.description,
                        ),
                        markerId: MarkerId(property.propertyId),
                        position: LatLng(
                          property.location.latitude,
                          property.location.longitude,
                        ),
                      ),
                    },
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        property.location.latitude,
                        property.location.longitude,
                      ),
                      zoom: 14.4746,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Size:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('${property.size} sq ft'),
                const SizedBox(height: 16),
                const Text(
                  'Room Count:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('${property.roomCount} rooms'),
                const SizedBox(height: 16),
                const Text(
                  'Type:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(property.type),
                const SizedBox(height: 16),
                const Text(
                  'Price:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('\$${property.price.round().toString()}'),
                const SizedBox(height: 16),
                const Text(
                  'Near by places:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(property.nearbyPlaces.toString()),
                const SizedBox(height: 16),
                const Text(
                  'Included Amenities:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(property.includedAmenities.toString()),
                const SizedBox(height: 16),
                const ElevatedButton(
                  onPressed:null,
                  child: Text(
                    'Virtual Tour',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
