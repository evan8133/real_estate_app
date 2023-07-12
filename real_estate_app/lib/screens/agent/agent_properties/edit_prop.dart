import 'package:auto_route/auto_route.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:multi_image_picker_plus/multi_image_picker_plus.dart';
import 'package:provider/provider.dart';
import 'package:real_estate_app/services/firestore_properties_methods.dart';

import '../../../model/properties_model.dart';
import '../../login/widget/text_input.dart';

class EditProperty extends StatefulWidget {
  final Property prop;

  const EditProperty({super.key, required this.prop});
  @override
  _EditPropertyState createState() => _EditPropertyState();
}

class _EditPropertyState extends State<EditProperty> {
  final _formKey = GlobalKey<FormState>();
  var isLoading = false;
  final titleController = TextEditingController();
  final discreptionController = TextEditingController();
  final priceController = TextEditingController();
  final sizeController = TextEditingController();
  final status = TextEditingController();
  bool isApartment = false;
  bool isVilla = false;
  bool isHouse = false;
  bool forSale = false;
  bool forRent = false;
  double price = 0.0;
  double size = 0.0;
  int roomCount = 0;
  int bedroomCount = 0;
  String propertyType = '';
  String? floor;
  String? apartmentName;
  String? residentialProject;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      var pageContext = context; // Save the current context

      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
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
                  context.read<PropertyService>().updateSingleProperty({
                    'propertyId': widget.prop.propertyId,
                    'title': titleController.text,
                    'description': discreptionController.text,
                    'price': double.parse(priceController.text),
                    'size': double.parse(sizeController.text),
                    'type': propertyType,
                    'forSale': forSale,
                    'forRent': forRent,
                    'bedroomCount': bedroomCount.toString(),
                    'roomCount': roomCount.toString(),
                    'floor': floor,
                    'apartmentName': apartmentName,
                    'residentialProject': residentialProject,
                  }).then((value) {
                    ScaffoldMessenger.of(pageContext).showSnackBar(
                      const SnackBar(
                        content: Text('Property updated successfully'),
                      ),
                    );
                    context.router.popUntilRouteWithPath('/agenthome');
                  });
                  setState(() {
                    isLoading = false;
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
    titleController.dispose();
    discreptionController.dispose();
    priceController.dispose();
    sizeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    titleController.text = widget.prop.title;
    discreptionController.text = widget.prop.description;
    priceController.text = widget.prop.price.toString();
    sizeController.text = widget.prop.size.toString();
    forSale = widget.prop.forSale;
    forRent = widget.prop.forRent;
    bedroomCount = int.parse(widget.prop.bedroomCount);
    roomCount = int.parse(widget.prop.roomCount);
    propertyType = widget.prop.type;
    isApartment = propertyType == 'Apartment';
    isVilla = propertyType == 'Villa';
    isHouse = propertyType == 'House';
    floor = widget.prop.floor;
    apartmentName = widget.prop.apartmentName;
    residentialProject = widget.prop.residentialProject;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Property'),
        actions: [
          IconButton(
            onPressed: () {
              _submitForm();
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: ModalProgressHUD(
        blur: 0.5,
        opacity: 0.6,
        progressIndicator: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator.adaptive(),
            SizedBox(height: 8),
            Text('Please wait...')
          ],
        ),
        inAsyncCall: isLoading,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextInput(
                    hideInput: false,
                    textInputType: TextInputType.text,
                    hint: 'Title',
                    textEditingController: titleController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a title';
                      }
                      if (value.length < 5) {
                        return 'Title must be at least 5 characters long';
                      }
                      return null;
                    },
                    label: 'Title',
                  ),
                  const SizedBox(height: 8),
                  TextInput(
                    hideInput: false,
                    textInputType: TextInputType.text,
                    hint: 'Description',
                    textEditingController: discreptionController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a description';
                      }
                      if (value.length < 10) {
                        return 'descrption must be at least 10 characters long';
                      }
                      return null;
                    },
                    label: 'Description',
                  ),
                  const SizedBox(height: 8),
                  TextInput(
                    hideInput: false,
                    textInputType: TextInputType.number,
                    hint: 'Price',
                    textEditingController: priceController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a price';
                      }
                      return null;
                    },
                    label: 'Price',
                  ),
                  const SizedBox(height: 8),
                  TextInput(
                    hideInput: false,
                    textInputType: TextInputType.number,
                    hint: 'Size',
                    textEditingController: sizeController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a size';
                      }
                      return null;
                    },
                    label: 'Size',
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    decoration:
                        const InputDecoration(labelText: 'Property Type'),
                    value: propertyType,
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
                  const SizedBox(height: 8),
                  Visibility(
                    visible: isApartment,
                    child: TextFormField(
                      initialValue: apartmentName,
                      decoration:
                          const InputDecoration(labelText: 'Apartment Name'),
                      onChanged: (value) => apartmentName = value,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Visibility(
                    visible: isApartment,
                    child: TextFormField(
                      initialValue: floor,
                      decoration: const InputDecoration(labelText: 'Floor'),
                      onChanged: (value) => floor = value,
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter a floor' : null,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Visibility(
                    visible: isApartment || isVilla || isHouse,
                    child: TextFormField(
                      initialValue: residentialProject,
                      decoration: const InputDecoration(
                          labelText: 'Residential Project (Optional)'),
                      onChanged: (value) => residentialProject = value,
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  const SizedBox(height: 8),
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
                  const SizedBox(height: 8),
                  CheckboxListTile(
                    title: const Text('For Sale'),
                    value: forSale,
                    onChanged: (bool? value) =>
                        setState(() => forSale = value!),
                  ),
                  const SizedBox(height: 8),
                  CheckboxListTile(
                    title: const Text('For Rent'),
                    value: forRent,
                    onChanged: (bool? value) =>
                        setState(() => forRent = value!),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
