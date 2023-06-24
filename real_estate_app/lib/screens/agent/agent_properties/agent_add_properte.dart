import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:multi_image_picker_plus/multi_image_picker_plus.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:real_estate_app/model/properties_model.dart';
import 'package:real_estate_app/services/firebase_auth_methods.dart';
import '../../../services/firestore_properties_methods.dart';
import 'model/Place.dart';

class AgentAddPropertyScreen extends StatefulWidget {
  @override
  _AgentAddPropertyScreenState createState() => _AgentAddPropertyScreenState();
}

class _AgentAddPropertyScreenState extends State<AgentAddPropertyScreen> {
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
  List<Asset> selectedImages = [];
  List<String> imageUrls = [];
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

  Future<List<Place>> fetchUniqueNearbyPlaces(
      {required LatLng location, required List<String> types}) async {
    const String baseUrl =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json';
    const String apiKey = 'AIzaSyAjaGWBMTQuFityWuHRB5lokimKetelTEE';
    const String radius = '500'; // Radius in meters

    List<Place> placesList = [];

    for (String type in types) {
      final response = await http.get(Uri.parse(
          '$baseUrl?location=${location.latitude},${location.longitude}&radius=$radius&type=$type&key=$apiKey'));
      log('Response status: ${response.statusCode} searching...');
      if (response.statusCode == 200) {
        Map<String, dynamic> placesResponse = json.decode(response.body);
        List<dynamic> places = placesResponse['results'];

        if (places.isNotEmpty) {
          placesList.add(
              Place.fromJson(places[0])); // Add the first place of this type
        }
      } else {
        throw Exception('Failed to load nearby places');
      }
    }
    return placesList;
  }

  Future<void> _selectLocation() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlacePicker(
          apiKey: 'AIzaSyAjaGWBMTQuFityWuHRB5lokimKetelTEE',
          onPlacePicked: (result) {
            setState(() {
              selectedLocation = GeoPoint(
                result.geometry!.location.lat,
                result.geometry!.location.lng,
              );
            });
            Navigator.of(context).pop();
          },
          initialPosition: const LatLng(37.42796133580664, -122.085749655962),
          useCurrentLocation: true,
          resizeToAvoidBottomInset:
              false, // only works in page mode, less flickery, remove if wrong offsets
        ),
      ),
    );
  }

  Future<void> _selectImages() async {
    List<Asset> resultList = await MultiImagePicker.pickImages(
      cupertinoOptions: const CupertinoOptions(
        settings: CupertinoSettings(
          previewEnabled: true,
        ),
      ),
      materialOptions: const MaterialOptions(),
    );

    if (resultList != null) {
      setState(() {
        selectedImages = resultList;
      });
    }
  }

  Future<void> _uploadImages(String propertyId) async {
    FirebaseStorage storage = FirebaseStorage.instance;

    for (var image in selectedImages) {
      ByteData byteData = await image.getByteData();
      DateTime now = DateTime.now();
      String filePath =
          'house/$propertyId/images/${now.microsecondsSinceEpoch}.jpg';
      UploadTask uploadTask =
          storage.ref().child(filePath).putData(byteData.buffer.asUint8List());

      final TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      final String url = await snapshot.ref.getDownloadURL();

      imageUrls.add(url);
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (selectedImages.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Please select both location and images.'),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        return;
      }

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
                  await _uploadImages(propId).then((value) async {
                    log('Images uploaded');
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
                      apartmentName:
                          apartmentName == ' ' ? null : apartmentName,
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
                    await pageContext // Use pageContext instead of context
                        .read<PropertyService>()
                        .setProperty(
                          newProperty,
                          pageContext.read<FirebsaeAuthMethods>().user.uid,
                        )
                        .then((value) {
                      log('Property added');
                      setState(() {
                        isLoading = false;
                      });
                      pageContext.router.pop();
                    });
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
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Property Type'),
                  items: <String>['Apartment', 'Villa', 'House']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
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
                    onChanged: (value) => apartmentName = value,
                  ),
                const SizedBox(height: 16),
                if (isApartment)
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Floor'),
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
                    onChanged: (value) => residentialProject = value,
                    keyboardType: TextInputType.text,
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
                const SizedBox(height: 16),
                Column(
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _selectLocation,
                        child: const Text('Select Location'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (selectedLocation.latitude != 0 &&
                        selectedLocation.longitude != 0)
                      Card(
                        child: ListTile(
                          leading: const Icon(Icons.location_on),
                          title: const Text('Selected Location'),
                          subtitle: Text(
                              'Latitude: ${selectedLocation.latitude}, Longitude: ${selectedLocation.longitude}'),
                        ),
                      ),
                    const SizedBox(height: 16),
                    FutureBuilder<List<Place>>(
                      future: fetchUniqueNearbyPlaces(
                        location: LatLng(
                          selectedLocation.latitude,
                          selectedLocation.longitude,
                        ),
                        types: types,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else {
                          places = snapshot.data!;
                          return Column(
                            children: [
                              Wrap(
                                spacing: 8.0,
                                runSpacing: 4.0,
                                children: places
                                    .map((place) => Chip(
                                          label: Text(place.type),
                                        ))
                                    .toList(),
                              ),
                              const SizedBox(height: 16),
                            ],
                          );
                        }
                      },
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
                    if (selectedImages.isNotEmpty)
                      Card(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: selectedImages.map((Asset image) {
                              return FutureBuilder<ByteData>(
                                future: image.getThumbByteData(200, 200),
                                builder: (BuildContext context,
                                    AsyncSnapshot<ByteData> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.memory(snapshot
                                              .data!.buffer
                                              .asUint8List()),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                selectedImages.remove(image);
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return const CircularProgressIndicator();
                                  }
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                  ],
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
