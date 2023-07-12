import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../model/properties_model.dart';

class PropertyService {
  final _firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  CollectionReference properties =
      FirebaseFirestore.instance.collection('properties');

  // Retrieve all properties
  Future<List<Property>> getProperties() async {
    QuerySnapshot snapshot = await _db.collection('properties').get();
    return snapshot.docs
        .map((doc) => Property.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  // Retrieve a single property
  Future<Property> getProperty(String propertyId) async {
    DocumentSnapshot snapshot =
        await _db.collection('properties').doc(propertyId).get();
    if (snapshot.exists) {
      return Property.fromJson(snapshot.data()! as Map<String, dynamic>);
    } else {
      throw Exception('Property not found');
    }
  }

  // Add a new property
  Future<void> setProperty(Property property, String userId) async {
    await _db
        .collection('properties')
        .doc(property.propertyId)
        .set(property.toJson())
        .then((value) {
      _db.collection('users').doc(userId).update({
        'listedProperties': FieldValue.arrayUnion([property.propertyId])
      });
    });
  }

  // Update an existing property
  Future<void> updateProperty(Property property) async {
    await _db
        .collection('properties')
        .doc(property.propertyId)
        .update(property.toJson());
  }

  // Delete a property
  Future<void> deleteProperty(Property prop) async {
    // Delete the property document
    await _db.collection('properties').doc(prop.propertyId).delete();

    // Remove the property ID from the user's listedProperties array
    await _db.collection('users').doc(prop.agentId).update({
      'listedProperties': FieldValue.arrayRemove([prop.propertyId])
    });
    //delete all fiels inside a folder in storage
    try {
      final ListResult result = await _firebaseStorage
          .ref('house/${prop.propertyId}/images')
          .listAll();
      for (final ref in result.items) {
        await ref.delete();
      }
    } catch (e) {
      log('Failed to delete property images: $e');
    }
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
    return querySnapshot.docs
        .map((doc) => Property.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<String> getVirtualTourUrl({required String propertyId}) {
    if (propertyId.isEmpty) {
      throw Exception('Property ID is empty');
    }

    return _firebaseStorage.ref('house/$propertyId/img.jpg').getDownloadURL();
  }

  Future<void> updateSingleProperty(Map<String, dynamic> changedData) {
    return _db.collection('properties').doc(changedData['propertyId']).set(
          changedData,
          SetOptions(merge: true),
        );
  }
}
