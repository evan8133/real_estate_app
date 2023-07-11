import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:auto_route/auto_route.dart';

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
    Future.delayed(const Duration(seconds: 3)).then((value) async {
      if (currentUser != null && currentUser.uid.isNotEmpty) {
        DocumentSnapshot userDocument =
            await firestore.collection('users').doc(currentUser.uid).get();
        Map<String, dynamic> userData =
            userDocument.data() as Map<String, dynamic>;
        log(userData.toString());
        if (userData.containsKey('role')) {
          if (userData['role'] == 'admin') {
            context.router.replace(const AdminNavigation());
          } else if (userData['role'] == 'agent') {
            context.router.replace(const AgentNavRoute());
          } else {
            context.router.replace(const UserNavigation());
          }
        } else {
          context.router.replace(const LoginRoute());
        }
      } else {
        context.router.replace(const LoginRoute());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: Future.delayed(const Duration(seconds: 4)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return const Text('Splash Screen');
            }
            return const SpinKitCircle(
              color: Colors.blue,
              size: 50.0,
            );
          },
        ),
      ),
    );
  }
}
