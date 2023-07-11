import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:real_estate_app/model/properties_model.dart';
import 'package:real_estate_app/services/firestore_properties_methods.dart';

class ViewPorpertyDetialScreen extends StatefulWidget {
  final Property property;

  ViewPorpertyDetialScreen({Key? key, required this.property})
      : super(key: key);

  @override
  State<ViewPorpertyDetialScreen> createState() =>
      _ViewPropertyDetailScreenState();
}

class _ViewPropertyDetailScreenState extends State<ViewPorpertyDetialScreen> {
  List<String> imageUrls = [];
  FirebaseStorage storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    fetchPropertyImages();
  }

  Future<void> fetchPropertyImages() async {
    try {
      final ListResult result = await storage
          .ref('house/${widget.property.propertyId}/images')
          .listAll();

      final List<String> urls = [];
      for (final ref in result.items) {
        final imageUrl = await ref.getDownloadURL();
        urls.add(imageUrl);
      }

      setState(() {
        imageUrls = urls;
      });
    } catch (e) {
      log('Failed to fetch property images: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Property Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext dialogContext) {
                  return AlertDialog(
                    title: const Text('Confirm Deletion'),
                    content: const Text(
                        'Are you sure you want to delete this property?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(dialogContext).pop(); // Close the dialog
                        },
                      ),
                      TextButton(
                        child: const Text('Delete'),
                        onPressed: () async {
                          Navigator.of(dialogContext).pop(); // Close the dialog
                          await context
                              .read<PropertyService>()
                              .deleteProperty(widget.property);
                          context.router.popUntilRouteWithPath('/adminhome');
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  widget.property.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
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
              SizedBox(
                width: double.infinity,
                child: CardInfoItem(
                  icon: Icons.description,
                  title: 'Description',
                  value: widget.property.description,
                ),
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                height: 200,
                child: GoogleMapView(widget: widget),
              ),
              const SizedBox(height: 16.0),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: CardInfoItem(
                        icon: Icons.square_foot,
                        title: 'Size',
                        value: '${widget.property.size} sqft',
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: CardInfoItem(
                        icon: Icons.bed,
                        title: 'Bedroom Count',
                        value: widget.property.bedroomCount,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: CardInfoItem(
                        icon: Icons.home,
                        title: 'Type',
                        value: widget.property.type,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: CardInfoItem(
                        icon: Icons.sensor_door,
                        title: 'Room Count',
                        value: widget.property.roomCount,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: CardInfoItem(
                        icon: Icons.menu,
                        title: 'Floor',
                        value: widget.property.floor ?? 'N/A',
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: CardInfoItem(
                        icon: Icons.apartment,
                        title: 'Apartment Name',
                        value: widget.property.apartmentName ?? 'N/A',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: CardInfoItem(
                        icon: Icons.business,
                        title: 'Residential Project',
                        value: widget.property.residentialProject ?? 'N/A',
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: CardInfoItem(
                        icon: Icons.check,
                        title: 'Included Amenities',
                        value: widget.property.includedAmenities.join(', '),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: CardInfoItem(
                        icon: Icons.monetization_on,
                        title: 'Price',
                        value: '${widget.property.price} USD',
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: CardInfoItem(
                        icon: Icons.near_me,
                        title: 'Agent ID',
                        value: widget.property.nearbyPlaces.join(', '),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GoogleMapView extends StatelessWidget {
  const GoogleMapView({
    super.key,
    required this.widget,
  });

  final ViewPorpertyDetialScreen widget;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      child: GoogleMap(
        rotateGesturesEnabled: false,
        scrollGesturesEnabled: false,
        markers: {
          Marker(
            infoWindow: InfoWindow(
              title: widget.property.title,
              snippet: widget.property.description,
            ),
            markerId: MarkerId(widget.property.propertyId),
            position: LatLng(
              widget.property.location.latitude,
              widget.property.location.longitude,
            ),
          ),
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.property.location.latitude,
            widget.property.location.longitude,
          ),
          zoom: 14.4746,
        ),
      ),
    );
  }
}

class CardInfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const CardInfoItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 40.0,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 8.0),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              value,
              style: const TextStyle(fontSize: 14.0),
            ),
          ],
        ),
      ),
    );
  }
}
