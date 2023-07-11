import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:real_estate_app/model/properties_model.dart';

class PropertyDetailsScreen extends StatefulWidget {
  PropertyDetailsScreen({
    Key? key,
    required this.property,
  }) : super(key: key);

  final Property property;

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Property Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                enlargeCenterPage: true,
                height: 250.0,
                viewportFraction: 1.0,
                enableInfiniteScroll: false,
              ),
              items: widget.property.imageUrls.map((imageUrl) {
                return Builder(
                  builder: (BuildContext context) {
                    return CachedNetworkImage(
                      imageUrl: imageUrl,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fit: BoxFit.cover,
                    );
                  },
                );
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.property.title,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Price: \$${widget.property.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Type: ${widget.property.type}',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Size: ${widget.property.size.toStringAsFixed(2)} sq.m.',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Bedrooms: ${widget.property.bedroomCount}',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    'Description:',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.property.description,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 8.0),
                  SizedBox(
                    width: double.infinity,
                    height: 200,
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
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    'Nearby Places:',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Wrap(
                    spacing: 8.0,
                    children: widget.property.nearbyPlaces.map((place) {
                      return Chip(
                        label: Text(place),
                        padding: const EdgeInsets.all(8.0),
                      );
                    }).toList(),
                  ),
                  const Text(
                    'Included Amenities:',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Wrap(
                    spacing: 8.0,
                    children: widget.property.includedAmenities.map((place) {
                      return Chip(
                        label: Text(place),
                        padding: const EdgeInsets.all(8.0),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
