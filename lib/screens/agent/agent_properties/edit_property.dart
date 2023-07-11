import 'dart:convert';
import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:multi_image_picker_plus/multi_image_picker_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../model/properties_model.dart';
import '../../../services/firebase_auth_methods.dart';
import '../../../services/firestore_properties_methods.dart';
import 'model/Place.dart';

class EditProperty extends StatefulWidget {
  final String properteId;

  const EditProperty({super.key, required this.properteId});
  @override
  _EditPropertyState createState() => _EditPropertyState();
}

class _EditPropertyState extends State<EditProperty> {
  final _formKey = GlobalKey<FormState>();
  List<Place> places = [];
  final amenityController = TextEditingController();
  List<String> includedAmenities = [];
  bool isLoading = false;
  final List<String> types = const [
    'atm',
    'bakery',
    'bank',
    'gas_station',
    'book_store',
    'cafe',
    'clothing_store',
    'convenience_store',
    'department_store',
    'drugstore',
    'electronics_store',
    'hospital',
    'jewelry_store',
    'movie_theater',
    'park',
    'pharmacy',
    'primary_school',
    'restaurant',
    'secondary_school',
    'shopping_mall',
    'supermarket',
    'tourist_attraction',
    'university'
  ];
  bool isApartment = false;
  bool isVilla = false;
  bool isHouse = false;
  String title = '';
  String description = '';
  GeoPoint selectedLocation = const GeoPoint(0, 0);
  String propertyType = '';
  String? floor;
  String? apartmentName;
  String? residentialProject;
  bool forSale = false;
  bool forRent = false;
  double price = 0.0;
  double size = 0.0;
  int roomCount = 0;
  int bedroomCount = 0;

  List<String> imageUrls = [];
  List<Asset> selectedImages = [];
  List<String> selectedImageUrls = [];
  FirebaseStorage storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    final property =
        await context.read<PropertyService>().getProperty(widget.properteId);

    setState(() {
      title = property.title;
      description = property.description;
      selectedLocation = property.location;
      propertyType = property.type;
      floor = property.floor;
      apartmentName = property.apartmentName;
      residentialProject = property.residentialProject;
      forSale = property.forSale;
      forRent = property.forRent;
      price = property.price;
      size = property.size;
      roomCount = int.parse(property.roomCount);
      bedroomCount = int.parse(property.bedroomCount);
      includedAmenities = property.includedAmenities;
      isLoading = false;
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      var pageContext = context; // Save the current context

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirmation'),
            content: const Text('Are you sure you want to submit the form?'),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  Navigator.of(context).pop();
                  final propId = FirebaseFirestore.instance
                      .collection('properties')
                      .doc()
                      .id;

                  Property newProperty = Property(
                    propertyId: propId,
                    title: title,
                    description: description,
                    location: selectedLocation,
                    nearbyPlaces: places.map((place) => place.type).toList(),
                    size: size,
                    roomCount: roomCount.toString(),
                    type: propertyType,
                    floor: floor,
                    apartmentName: apartmentName == ' ' ? null : apartmentName,
                    residentialProject:
                        residentialProject == ' ' ? null : residentialProject,
                    includedAmenities: includedAmenities,
                    forSale: forSale,
                    forRent: forRent,
                    status: 'available',
                    price: price,
                    bedroomCount: bedroomCount.toString(),
                    agentId: pageContext.read<FirebsaeAuthMethods>().user.uid,
                  );

                  // Create a map to hold the changed fields only
                  final changedData = <String, dynamic>{};
                  changedData['properteId'] = widget.properteId;

                  changedData['title'] = newProperty.title;

                  changedData['description'] = newProperty.description;

                  changedData['size'] = newProperty.size;

                  changedData['roomCount'] = newProperty.roomCount;

                  changedData['type'] = newProperty.type;

                  changedData['floor'] = newProperty.floor;

                  changedData['apartmentName'] = newProperty.apartmentName;

                  changedData['residentialProject'] =
                      newProperty.residentialProject;

                  changedData['includedAmenities'] =
                      newProperty.includedAmenities;

                  changedData['forSale'] = newProperty.forSale;

                  changedData['forRent'] = newProperty.forRent;

                  changedData['bedroomCount'] = newProperty.bedroomCount;

                  changedData['agentId'] = newProperty.agentId;

                  print(changedData);
                  // Pass the changed data to the updateSingleProperty method
                  await pageContext
                      .read<PropertyService>()
                      .updateSingleProperty(changedData)
                      .then((value) {
                    log('Property updated');
                    setState(() {
                      isLoading = false;
                    });
                    pageContext.router.pop();
                  });
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void dispose() {
    amenityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Property'),
      ),
      body: ModalProgressHUD(
        blur: 0.5,
        opacity: 0.6,
        progressIndicator: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator.adaptive(),
            SizedBox(height: 16),
            Text('Please wait...')
          ],
        ),
        inAsyncCall: isLoading,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Title'),
                  initialValue: title,
                  onChanged: (value) => title = value,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a title' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  initialValue: description,
                  onChanged: (value) => description = value,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a description' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Property Type'),
                  value: propertyType,
                  items: const <DropdownMenuItem<String>>[
                    DropdownMenuItem<String>(
                      value: 'Apartment',
                      child: Text('Apartment'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'Villa',
                      child: Text('Villa'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'House',
                      child: Text('House'),
                    ),
                  ],
                  onChanged: (String? value) {
                    setState(() {
                      propertyType = value!;
                      isApartment = propertyType == 'Apartment';
                      isVilla = propertyType == 'Villa';
                      isHouse = propertyType == 'House';
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please select a property type' : null,
                ),
                const SizedBox(height: 16),
                if (isApartment)
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Apartment Name'),
                    initialValue: apartmentName,
                    onChanged: (value) => apartmentName = value,
                  ),
                const SizedBox(height: 16),
                if (isApartment)
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Floor'),
                    initialValue: floor,
                    onChanged: (value) => floor = value,
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a floor' : null,
                    keyboardType: TextInputType.number,
                  ),
                const SizedBox(height: 16),
                if (isApartment || isVilla || isHouse)
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Residential Project (Optional)'),
                    initialValue: residentialProject,
                    onChanged: (value) => residentialProject = value,
                    keyboardType: TextInputType.text,
                  ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Size'),
                  initialValue: size.toString(),
                  onChanged: (value) => size = double.parse(value),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a size' : null,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                Text('Bedroom Count: $bedroomCount'),
                Slider(
                  value: bedroomCount.toDouble(),
                  min: 0.0,
                  max: 10.0,
                  divisions: 10,
                  label: bedroomCount.toString(),
                  onChanged: (double value) {
                    setState(() {
                      bedroomCount = value.round();
                    });
                  },
                ),
                Text('Room Count: $roomCount'),
                Slider(
                  value: roomCount.toDouble(),
                  min: 0.0,
                  max: 15.0,
                  divisions: 10,
                  label: roomCount.toString(),
                  onChanged: (double value) {
                    setState(() {
                      roomCount = value.round();
                    });
                  },
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
                  initialValue: price.toString(),
                  onChanged: (value) => price = double.parse(value),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a price' : null,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: amenityController,
                  decoration: InputDecoration(
                    labelText: 'Included Amenities',
                    suffixIcon: IconButton(
                      onPressed: () {
                        if (amenityController.text.isNotEmpty) {
                          setState(() {
                            includedAmenities.add(amenityController.text);
                            amenityController.clear();
                          });
                        }
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        includedAmenities.add(value);
                        amenityController.clear();
                      });
                    }
                  },
                ),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: includedAmenities.map((amenity) {
                    return InputChip(
                      label: Text(amenity),
                      onDeleted: () {
                        setState(() {
                          includedAmenities.remove(amenity);
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                if (selectedImages.isNotEmpty)
                  CarouselSlider.builder(
                    itemCount: selectedImages.length,
                    itemBuilder: (context, index, realIndex) {
                      final image = selectedImages[index];
                      return Stack(
                        children: [
                          AssetThumb(
                            asset: image,
                            width: 200,
                            height: 200,
                          ),
                          Positioned(
                            top: 5,
                            right: 5,
                            child: CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              child: IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    selectedImages.removeAt(index);
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    options: CarouselOptions(
                      height: 230,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: false,
                    ),
                  ),
                const SizedBox(height: 16),
                const Divider(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _submitForm();
                    },
                    child: const Text('Save Property'),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
