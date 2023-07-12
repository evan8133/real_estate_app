import 'package:flutter/material.dart';
import 'package:panorama/panorama.dart';

class VirtualScreen extends StatefulWidget {
  String url;
  VirtualScreen({Key? key, required this.url}) : super(key: key);

  @override
  State<VirtualScreen> createState() => _VirtualScreenState();
}

class _VirtualScreenState extends State<VirtualScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Virtual View'),
      ),
      body: Center(
        child: Panorama(
          child: Image.network(widget.url),
        ),
      ),
    );
  }
}
