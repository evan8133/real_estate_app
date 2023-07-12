import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:real_estate_app/model/properties_model.dart';
import 'package:real_estate_app/router/router.gr.dart';

import '../../../services/firestore_properties_methods.dart';

class AgentProperteDetailScreen extends StatefulWidget {
  final Property prop;
  final bool isEditable;

  const AgentProperteDetailScreen(
      {Key? key, required this.prop, this.isEditable = true})
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
          await storage.ref('house/${widget.prop.propertyId}/images').listAll();

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
        title: const Text('Property Detail'),
        actions: [
          Visibility(
            visible: widget.isEditable,
            child: IconButton(
              onPressed: () {
                context.router.push(
                  EditpropertyRoute(
                    prop: widget.prop,
                  ),
                );
              },
              icon: const Icon(Icons.edit),
            ),
          ),
          Visibility(
            visible: widget.isEditable,
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      title: const Text('Confirmation'),
                      content: const Text(
                          'Are you sure you want to delete this property?'),
                      actions: [
                        ElevatedButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(dialogContext)
                                .pop(); // Close the dialog
                          },
                        ),
                        ElevatedButton(
                          child: const Text('Delete'),
                          onPressed: () {
                            // Perform the deletion
                            Navigator.of(dialogContext)
                                .pop(); // Close the dialog
                            context
                                .read<PropertyService>()
                                .deleteProperty(widget.prop);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.delete),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
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
                widget.prop.title,
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
            Text(widget.prop.description),
            const SizedBox(height: 16),
            Text(
              'Status: ${widget.prop.status}',
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
                      title: widget.prop.title,
                      snippet: widget.prop.description,
                    ),
                    markerId: MarkerId(widget.prop.propertyId),
                    position: LatLng(
                      widget.prop.location.latitude,
                      widget.prop.location.longitude,
                    ),
                  ),
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    widget.prop.location.latitude,
                    widget.prop.location.longitude,
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
            Text('${widget.prop.size} sq ft'),
            const SizedBox(height: 16),
            const Text(
              'Room Count:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('${widget.prop.roomCount} rooms'),
            const SizedBox(height: 16),
            const Text(
              'Type:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(widget.prop.type),
            const SizedBox(height: 16),
            const Text(
              'Price:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('\$${widget.prop.price.round().toString()}'),
            const SizedBox(height: 16),
            const Text(
              'Near by places:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(widget.prop.nearbyPlaces.toString()),
            const SizedBox(height: 16),
            const Text(
              'Included Amenities:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(widget.prop.includedAmenities.toString()),
            const SizedBox(height: 16),
            FutureBuilder(
              future: context.read<PropertyService>().getVirtualTourUrl(
                    propertyId: widget.prop.propertyId,
                  ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Virtual Tour not available'),
                  );
                }
                if (snapshot.data == null) {
                  return const Center(
                    child: Text('No data'),
                  );
                }
                var url = snapshot.data as String;
                return ElevatedButton(
                  onPressed: () {
                    context.router.push(
                      VirtualviewRoute(
                        url: url,
                      ),
                    );
                  },
                  child: const Text(
                    'Virtual Tour',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
