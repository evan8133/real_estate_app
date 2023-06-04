import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:auto_route/auto_route.dart';
import 'package:provider/provider.dart';
import 'package:real_estate_app/services/firebase_auth_methods.dart';

import '../../router/router.gr.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserStatusAndNavigate();
  }

  Future<void> _checkUserStatusAndNavigate() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? currentUser = auth.currentUser;
    Future.delayed(Duration(seconds: 3)).then((value) async {
      if (currentUser != null && currentUser.uid.isNotEmpty) {
        DocumentSnapshot userDocument =
            await firestore.collection('users').doc(currentUser.uid).get();
        Map<String, dynamic> userData =
            userDocument.data() as Map<String, dynamic>;
        print(userData);
        if (userData.containsKey('role')) {
          if (userData['role'] == 'admin') {
            // This is an admin user.
            // Navigate to the admin page.
            context.router.replace(const AdminNavigation());
          } else {
            // This is a regular user.
            // Navigate to the regular user page.
            context.router.replace(const UserNavigation());
          }
        } else {
          // The document did not contain a 'role' field.
          // Navigate to the login page.
          context.router.push(const LoginRoute());
        }
      } else {
        // No user is currently signed in.
        // Navigate to the login page.
        context.router.push(const LoginRoute());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: Future.delayed(Duration(seconds: 4)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Text('Splash Screen');
            }
            return SpinKitCircle(
              color: Colors.blue,
              size: 50.0,
            );
          },
        ),
      ),
    );
  }
}
