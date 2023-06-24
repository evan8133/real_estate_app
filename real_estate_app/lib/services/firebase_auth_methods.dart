import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:real_estate_app/utils/snack_bar.dart';

import '../router/router.gr.dart';

class FirebsaeAuthMethods {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  FirebsaeAuthMethods(this._auth);
  User get user => _auth.currentUser!;
  Stream<User?> get authState => _auth.authStateChanges();

  // SIGN UP
  Future<void> signUpWithEmail({
    required Map<String, dynamic> user,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(
        email: user['email'],
        password: password,
      )
          .then((value) {
        log('User created successfully');
        _firebaseFirestore.collection('users').doc(value.user!.uid).set(user);
      });
      await sendEmailVerification(context);
    } on FirebaseAuthException catch (e) {
      // if you want to display your own custom error message
      if (e.code == 'weak-password') {
        showSnackBar(context, 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        showSnackBar(context, 'The account already exists for that email.');
      }
      showSnackBar(
          context, e.message!); // Displaying the usual firebase error message
    }
  }

  // EMAIL LOGIN
  Future<void> loginWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (_auth.currentUser != null) {
        DocumentSnapshot userDocument = await firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .get();
        Map<String, dynamic> userData =
            userDocument.data() as Map<String, dynamic>;

        if (userData.containsKey('role')) {
          if (userData['role'] == 'admin') {
            // This is an admin user.
            // Navigate to the admin page.
            context.router.replace(const AdminNavigation());
          } else if (userData['role'] == 'agent') {
            context.router.replace(const AgentNavRoute());
          } else {
            // This is a regular user.
            // Navigate to the regular user page.
            context.router.replace(const UserNavigation());
          }
        } else {
          // The document did not contain a 'role' field.
          // Display an error message or handle it appropriately
          showSnackBar(context, "Error: No role found for this user");
        }
      } else {
        // Login failed
        // Display an error message or handle it appropriately
        showSnackBar(context, "Error: Could not login");
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Displaying the error message
    }
  }

  // EMAIL VERIFICATION
  Future<void> sendEmailVerification(BuildContext context) async {
    try {
      _auth.currentUser!.sendEmailVerification();
      showSnackBar(context, 'Email verification sent!');
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Display error message
    }
  }

  // SIGN OUT
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Displaying the error message
    }
  }

  // DELETE ACCOUNT
  Future<void> deleteAccount(BuildContext context) async {
    try {
      String uid = _auth.currentUser!.uid;
      await _firebaseFirestore.collection('users').doc(uid).delete();
      await _auth.currentUser!.delete();
      showSnackBar(context, "Account deleted successfully");
      context.router.replace(const LoginRoute());
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Displaying the error message
      // if an error of requires-recent-login is thrown, make sure to log
      // in user again and then delete account.
    } catch (e) {
      showSnackBar(context, "Error: Could not delete user data");
    }
  }

  // RESET PASSWORD
  Future<void> resetPassword({
    required String email,
    required BuildContext context,
  }) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      // ignore: use_build_context_synchronously
      showSnackBar(context, 'Password reset email sent!');
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Displaying the error message
    }
  }

  Future<List<DocumentSnapshot>> getUserProperties(String uid) async {
    DocumentSnapshot userDoc =
        await _firebaseFirestore.collection('users').doc(uid).get();
    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>? ??
        {}; // cast to Map<String, dynamic>
    List<String> propertyIds =
        List<String>.from(userData['listedProperties'] ?? []);
    List<DocumentSnapshot> propertyDocs = [];
    for (String id in propertyIds) {
      DocumentSnapshot propertyDoc =
          await _firebaseFirestore.collection('properties').doc(id).get();
      propertyDocs.add(propertyDoc);
    }
    return propertyDocs;
  }

  //update name
  Future<void> updateName(String name) async {
    try {
      await _auth.currentUser!.updateDisplayName(name).then((value) {
        // update name in firestore in collection users
        _firebaseFirestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .update({
          'name': name,
        });
      });
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  Future<void> updateAge(String age) async {
    // update age in firestore in collection users
    await _firebaseFirestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .update({
      'age': age,
    });
  }

  Future<void> updatePhone(String phone) async {
    await _firebaseFirestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .update({
      'phone': phone,
    });
  }

  Future<void>  updateGender(String gender) async{
    await _firebaseFirestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .update({
      'gender': gender,
    });
  }
}
