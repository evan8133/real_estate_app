import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'package:real_estate_app/screens/profile/profile_model.dart';
import 'package:real_estate_app/services/firebase_auth_methods.dart';

class ProfileScreen extends StatefulWidget {
  final Profile profile;

  const ProfileScreen(this.profile, {super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfileScreen> {
  late final String _defaultImageUrl;
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _ageController;

  @override
  void initState() {
    super.initState();
    _defaultImageUrl = 'assets/user.png'; // Your default image path

    _nameController = TextEditingController(text: widget.profile.name);
    _phoneController = TextEditingController(text: widget.profile.phone);
    _ageController = TextEditingController(text: widget.profile.age);
    _getImageUrl(widget.profile.name);
  }

  void _getImageUrl(String name) async {
    var url = '';
    try {
      url = await FirebaseStorage.instance
          .ref('profiles/$name/profile_pic.jpg')
          .getDownloadURL();
    } catch (e) {
      url = _defaultImageUrl;
    }

    setState(() {
      widget.profile.image = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(_defaultImageUrl),
              ),
            ),
            _editableField(
              'Name',
              _nameController,
              (name) async {
                // Your update name logic here
                context.read<FirebsaeAuthMethods>().updateName(name);
              },
            ),
            _editableField(
              'Phone',
              _phoneController,
              (phone) {
                // Your update phone logic here
                context.read<FirebsaeAuthMethods>().updatePhone(phone);
              },
            ),
            _editableField(
              'Age',
              _ageController,
              (age) {
                // Your update age logic here
                context.read<FirebsaeAuthMethods>().updateAge(age);
              },
            ),
            _editableField(
              'Gender',
              _ageController,
              (gender) {
                // Your update age logic here
                context.read<FirebsaeAuthMethods>().updateGender(gender);
              },
            ),
            ListTile(
              title: const Text('Role'),
              subtitle: Text(widget.profile.role),
            ),
            ListTile(
              title: const Text('Email'),
              subtitle: Text(widget.profile.email),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: const Text('Reset Password'),
                onPressed: () {
                  context.read<FirebsaeAuthMethods>().resetPassword(
                        email: widget.profile.email,
                        context: context,
                      );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _editableField(String title, TextEditingController controller,
      Function(String name) onPressed) {
    return ListTile(
      title: Text(title),
      subtitle: Text(controller.text),
      trailing: IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () {
          final formKey = GlobalKey<FormState>();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Edit $title'),
              content: Form(
                key: formKey,
                child: TextFormField(
                  controller: controller,
                  validator: (value) {
                    // Your validation logic here
                    return null;
                  },
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: const Text('Save'),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      onPressed.call(controller.text);
                      setState(() {});
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
