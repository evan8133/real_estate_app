import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:multi_image_picker_plus/multi_image_picker_plus.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:real_estate_app/model/properties_model.dart';
import 'package:real_estate_app/services/firestore_user_methods.dart';
import '../../../services/firestore_properties_methods.dart';

class AgentAddPropertyScreen extends StatefulWidget {
  @override
  _AgentAddPropertyScreenState createState() => _AgentAddPropertyScreenState();
}

class _AgentAddPropertyScreenState extends State<AgentAddPropertyScreen> {
  final _formKey = GlobalKey<FormState>();

  String title = '';
  String description = '';
  GeoPoint selectedLocation = const GeoPoint(0, 0);
  List<Asset> selectedImages = [];
  List<String> imageUrls = [];
  String propertyType = '';
  int? floor;
  String? apartmentName;
  String? residentialProject;
  bool forSale = false;
  bool forRent = false;
  double price = 0.0;
  double size = 0.0;
  int roomCount = 0;
  int bedroomCount = 0;

  Future<void> _selectLocation() async {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlacePicker(
          apiKey: 'AIzaSyAjaGWBMTQuFityWuHRB5lokimKetelTEE',
          onPlacePicked: (result) { 
            Navigator.of(context).pop();
          },
          initialPosition: const LatLng(37.42796133580664, -122.085749655962),
          useCurrentLocation: true,
          resizeToAvoidBottomInset: false, // only works in page mode, less flickery, remove if wrong offsets
        ),
      ),
    );
}


  Future<void> _selectImages() async {
    List<Asset> resultList = await MultiImagePicker.pickImages();

    if (resultList != null) {
      setState(() {
        selectedImages = resultList;
      });
    }
  }

  Future<void> _uploadImages() async {
    FirebaseStorage storage = FirebaseStorage.instance;

    for (var image in selectedImages) {
      ByteData byteData = await image.getByteData();
      DateTime now = DateTime.now();
      String filePath =
          'images/${now.year}_${now.month}_${now.day}/${now.microsecondsSinceEpoch}.png';
      UploadTask uploadTask =
          storage.ref().child(filePath).putData(byteData.buffer.asUint8List());

      final TaskSnapshot downloadUrl = (await uploadTask);
      final String url = await downloadUrl.ref.getDownloadURL();

      imageUrls.add(url);
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      await _uploadImages();

      // Create property object
      Property newProperty = Property(
        propertyId: 'generate id',
        title: title,
        description: description,
        location: selectedLocation,
        nearbyPlaces: [],
        size: 0.0,
        roomCount: 0,
        type: propertyType,
        floor: floor,
        apartmentName: apartmentName,
        residentialProject: residentialProject,
        includedAmenities: imageUrls,
        forSale: forSale,
        forRent: forRent,
        status: 'available',
        price: price,
        bedroomCount: 0,
        agentId: 'get agent id',
      );

      // Save to Firestore
      //await context.read<PropertyService>().addProperty(newProperty);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Property'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                onChanged: (value) => title = value,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                onChanged: (value) => description = value,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a description' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Property Type'),
                onChanged: (value) => propertyType = value,
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a property type' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Apartment Name'),
                onChanged: (value) => apartmentName = value,
              ),
              const SizedBox(height: 16),

              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Residential Project'),
                onChanged: (value) => residentialProject = value,
              ),
              const SizedBox(height: 16),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Floor'),
                onChanged: (value) => floor = int.parse(value),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a floor' : null,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Size'),
                onChanged: (value) => size = double.parse(value),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a size' : null,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Room Count'),
                onChanged: (value) => roomCount = int.parse(value),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter room count' : null,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Bedroom Count'),
                onChanged: (value) => bedroomCount = int.parse(value),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter bedroom count' : null,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              CheckboxListTile(
                title: const Text('For Sale'),
                value: forSale,
                onChanged: (bool? value) => setState(() => forSale = value!),
              ),
              const SizedBox(height: 16),

              CheckboxListTile(
                title: const Text('For Rent'),
                value: forRent,
                onChanged: (bool? value) => setState(() => forRent = value!),
              ),
              const SizedBox(height: 16),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Price'),
                onChanged: (value) => price = double.parse(value),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a price' : null,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selectLocation,
                  child: const Text('Select Location'),
                ),
              ),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selectImages,
                  child: const Text('Select Images'),
                ),
              ),
              const SizedBox(height: 16),
              const Divider(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Save Property'),
                ),
              ),
              const SizedBox(height: 16),

            ],
          ),
        ),
      ),
    );
  }
}
