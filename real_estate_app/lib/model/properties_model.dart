import 'package:cloud_firestore/cloud_firestore.dart';

class Property {
  final String propertyId;
  final String title;
  final String description;
  final GeoPoint location;
  final List<String> nearbyPlaces;
  final double size;
  final String roomCount;
  final String type;
  final String? floor;
  final String? apartmentName;
  final String? residentialProject;
  final List<String> includedAmenities;
  final bool forSale;
  final String status;
  final bool forRent;
  final double price;
  final String bedroomCount;
  final String agentId;
  List<String> imageUrls = [];

  Property({
    required this.propertyId,
    required this.title,
    required this.description,
    required this.location,
    required this.nearbyPlaces,
    required this.size,
    required this.roomCount,
    required this.type,
    this.floor,
    this.apartmentName,
    this.residentialProject,
    required this.includedAmenities,
    required this.status,
    required this.forSale,
    required this.forRent,
    required this.price,
    required this.bedroomCount,
    required this.agentId,
  });

  CollectionReference properties = FirebaseFirestore.instance.collection('properties');

  Future<void> addProperty(Property property) {
    return properties
      .add(property.toJson())
      .then((value) => print("Property Added"))
      .catchError((error) => print("Failed to add property: $error"));
  }

  Future<Property?> getProperty(String id) async {
    final doc = await properties.doc(id).get();
    return doc.exists ? Property.fromJson(doc.data() as Map<String, dynamic>) : null;
  }

  Future<void> updateProperty(Property property) async {
    await properties.doc(property.propertyId).update(property.toJson());
  }

  Future<void> deleteProperty(Property prop) async {
    await properties.doc(prop.propertyId).delete();
  }

  Stream<QuerySnapshot> getPropertiesStream() {
    return properties.snapshots();
  }

  Future<List<Property>> queryProperties({
    String? title,
    String? type,
    bool? forSale,
    bool? forRent,
  }) async {
    Query query = properties;
    
    if (title != null) {
      query = query.where('title', isEqualTo: title);
    }
    if (type != null) {
      query = query.where('type', isEqualTo: type);
    }
    if (forSale != null) {
      query = query.where('forSale', isEqualTo: forSale);
    }
    if (forRent != null) {
      query = query.where('forRent', isEqualTo: forRent);
    }

    final querySnapshot = await query.get();
    return querySnapshot.docs.map((doc) => Property.fromJson(doc.data() as Map<String, dynamic>)).toList();
  }

  Future<void> runTransaction(Property updatedProperty) async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.update(properties.doc(updatedProperty.propertyId), updatedProperty.toJson());
    });
  }

  static Property fromJson(Map<String, dynamic> json) => Property(
    propertyId: json['propertyId'],
    title: json['title'],
    description: json['description'],
    location: json['location'],
    nearbyPlaces: List<String>.from(json['nearbyPlaces']),
    size: json['size'].toDouble(),
    roomCount: json['roomCount'],
    type: json['type'],
    status: json['status'],
    floor: json['floor'],
    apartmentName: json['apartmentName'],
    residentialProject: json['residentialProject'],
    includedAmenities: List<String>.from(json['includedAmenities']),
    forSale: json['forSale'],
    forRent: json['forRent'],
    price: json['price'].toDouble(),
    bedroomCount: json['bedroomCount'],
    agentId: json['agentId'],
  );

  Map<String, dynamic> toJson() => {
    'propertyId': propertyId,
    'title': title,
    'description': description,
    'location': location,
    'nearbyPlaces': nearbyPlaces,
    'size': size,
    'roomCount': roomCount,
    'type': type,
    'floor': floor,
    'apartmentName': apartmentName,
    'residentialProject': residentialProject,
    'includedAmenities': includedAmenities,
    'forSale': forSale,
    'forRent': forRent,
    'status': status,
    'price': price,
    'bedroomCount': bedroomCount,
    'agentId': agentId,
  };
}