

import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/properties_model.dart';

class PropertyService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Retrieve all properties
  Future<List<Property>> getProperties() async {
    QuerySnapshot snapshot = await _db.collection('properties').get();
    return snapshot.docs.map((doc) => Property.fromJson(doc.data() as Map<String, dynamic>)).toList();
  }

  // Retrieve a single property
  Future<Property> getProperty(String propertyId) async {
    DocumentSnapshot snapshot = await _db.collection('properties').doc(propertyId).get();
    if (snapshot.exists) {
      return Property.fromJson(snapshot.data()! as Map<String, dynamic>);
    } else {
      throw Exception('Property not found');
    }
  }

  // Add a new property
  Future<void> setProperty(Property property) async {
    await _db.collection('properties').doc(property.propertyId).set(property.toJson());
  }

  // Update an existing property
  Future<void> updateProperty(Property property) async {
    await _db.collection('properties').doc(property.propertyId).update(property.toJson());
  }

  // Delete a property
  Future<void> deleteProperty(String propertyId) async {
    await _db.collection('properties').doc(propertyId).delete();
  }
}
