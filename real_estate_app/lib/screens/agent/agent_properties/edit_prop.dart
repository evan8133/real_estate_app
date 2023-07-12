import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:multi_image_picker_plus/multi_image_picker_plus.dart';

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
  void _submitForm() async {
    // if (_formKey.currentState!.validate()) {
    //   var pageContext = context; // Save the current context

    //   showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return AlertDialog(
    //         title: const Text('Confirmation'),
    //         content: const Text('Are you sure you want to submit the form?'),
    //         actions: <Widget>[
    //           ElevatedButton(
    //             child: const Text('Cancel'),
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //             },
    //           ),
    //           ElevatedButton(
    //             child: const Text('OK'),
    //             onPressed: () async {
    //               setState(() {
    //                 isLoading = true;
    //               });
    //               Navigator.of(context).pop();
    //               final propId = FirebaseFirestore.instance
    //                   .collection('properties')
    //                   .doc()
    //                   .id;

    //               Property newProperty = Property(
    //                 propertyId: propId,
    //                 title: title,
    //                 description: description,
    //                 location: selectedLocation,
    //                 nearbyPlaces: places.map((place) => place.type).toList(),
    //                 size: size,
    //                 roomCount: roomCount.toString(),
    //                 type: propertyType,
    //                 floor: floor,
    //                 apartmentName: apartmentName == ' ' ? null : apartmentName,
    //                 residentialProject:
    //                     residentialProject == ' ' ? null : residentialProject,
    //                 includedAmenities: includedAmenities,
    //                 forSale: forSale,
    //                 forRent: forRent,
    //                 status: 'available',
    //                 price: price,
    //                 bedroomCount: bedroomCount.toString(),
    //                 agentId: pageContext.read<FirebsaeAuthMethods>().user.uid,
    //               );

    //               // Create a map to hold the changed fields only
    //               final changedData = <String, dynamic>{};
    //               changedData['properteId'] = widget.properteId;

    //               changedData['title'] = newProperty.title;

    //               changedData['description'] = newProperty.description;

    //               changedData['size'] = newProperty.size;

    //               changedData['roomCount'] = newProperty.roomCount;

    //               changedData['type'] = newProperty.type;

    //               changedData['floor'] = newProperty.floor;

    //               changedData['apartmentName'] = newProperty.apartmentName;

    //               changedData['residentialProject'] =
    //                   newProperty.residentialProject;

    //               changedData['includedAmenities'] =
    //                   newProperty.includedAmenities;

    //               changedData['forSale'] = newProperty.forSale;

    //               changedData['forRent'] = newProperty.forRent;

    //               changedData['bedroomCount'] = newProperty.bedroomCount;

    //               changedData['agentId'] = newProperty.agentId;

    //               print(changedData);
    //               // Pass the changed data to the updateSingleProperty method
    //               await pageContext
    //                   .read<PropertyService>()
    //                   .updateSingleProperty(changedData)
    //                   .then((value) {
    //                 log('Property updated');
    //                 setState(() {
    //                   isLoading = false;
    //                 });
    //                 pageContext.router.pop();
    //               });
    //             },
    //           ),
    //         ],
    //       );
    //     },
    //   );
    // }
  }

  @override
  void dispose() {}

  @override
  void initState() {
    super.initState();
    titleController.text = widget.prop.title;
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
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              Text(
                'Property Title',
              ),
              TextInput(
                hideInput: false,
                textInputType: TextInputType.text,
                hint: 'Title',
                textEditingController: titleController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
