import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../model/properties_model.dart';
import '../../../../services/firestore_properties_methods.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Map<MarkerId, Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    final propertyService = Provider.of<PropertyService>(context);
    return FutureBuilder<List<Property>>(
      future: propertyService.getProperties(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final properties = snapshot.data ?? [];
        properties.forEach((property) {
          final markerId = MarkerId(property.propertyId);
          final marker = Marker(
            markerId: markerId,
            icon: BitmapDescriptor.defaultMarker,
            position:
                LatLng(property.location.latitude, property.location.longitude),
            infoWindow: InfoWindow(
              title: property.title,
              snippet: 'Size: ${property.size}, Price: ${property.price}',
              onTap: () {},
            ),
          );
          _markers[markerId] = marker;
        });

        return GoogleMap(
          markers: Set<Marker>.of(_markers.values),
          initialCameraPosition: CameraPosition(
            target: LatLng(properties.first.location.latitude,
                properties.first.location.longitude),
            zoom: 14.0,
          ),
          mapToolbarEnabled: true,
          myLocationEnabled: true,
        );
      },
    );
  }
}
