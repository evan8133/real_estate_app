import 'package:auto_route/auto_route.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:real_estate_app/router/router.gr.dart';
import 'package:real_estate_app/services/firebase_auth_methods.dart';

import '../../../services/firestore_user_methods.dart';
import '../../../utils/theme_provider.dart';
import '../../profile/profile_model.dart';

class SettingScreen extends StatefulWidget {
  SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool themMode = false;

  @override
  Widget build(BuildContext context) {
    final current = context.read<FirebsaeAuthMethods>().user;
    final themeProvider = Provider.of<ThemeProvider>(context);
    return FutureBuilder(
      future: context.read<FirestoreMethodsUsers>().getUser(current.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text('Error'),
          );
        }
        var user =
            (snapshot.data as DocumentSnapshot).data() as Map<String, dynamic>;

        Profile profile = Profile.fromJson(user);
        return Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              // User card
              BigUserCard(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                settingColor: Theme.of(context).colorScheme.primaryContainer,
                userName: '${profile.role}\n${profile.name}',
                userProfilePic: const AssetImage("assets/user.png"),
                cardActionWidget: SettingsItem(
                  icons: Icons.edit,
                  iconStyle: IconStyle(
                    withBackground: true,
                    borderRadius: 50,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  title: "Modify",
                  subtitle: "Tap to change your data",
                  titleStyle: Theme.of(context).textTheme.headlineMedium,
                  subtitleStyle: Theme.of(context).textTheme.bodySmall,
                  onTap: () {
                    context.router.push(
                      ProfileRoute(
                        profile: profile,
                      ),
                    );
                  },
                ),
              ),
              SettingsGroup(
                items: [
                  SettingsItem(
                    onTap: () {},
                    icons: Icons.dark_mode_rounded,
                    iconStyle: IconStyle(
                      iconsColor: Colors.white,
                      withBackground: true,
                      backgroundColor: Colors.red,
                    ),
                    title: 'Dark mode',
                    subtitle: "Automatic",
                    trailing: Switch.adaptive(
                      value: themMode,
                      onChanged: (value) {
                        setState(() {
                          themMode = value;
                        });
                        final newThemeMode =
                            value ? ThemeModeType.dark : ThemeModeType.light;
                        themeProvider.setThemeMode(newThemeMode);
                      },
                    ),
                  ),
                ],
              ),
              SettingsGroup(
                items: [
                  SettingsItem(
                    onTap: () {},
                    icons: Icons.info_rounded,
                    iconStyle: IconStyle(
                      backgroundColor: Colors.purple,
                    ),
                    title: 'About',
                    subtitle: "Learn more about My Real Estate",
                  ),
                ],
              ),
              // You can add a settings title
              SettingsGroup(
                settingsGroupTitle: "Account",
                items: [
                  SettingsItem(
                    onTap: () {
                      context.read<FirebsaeAuthMethods>().signOut(context).then(
                          (value) =>
                              context.router.replace(const LoginRoute()));
                    },
                    icons: Icons.exit_to_app_rounded,
                    title: "Sign Out",
                  ),
                  SettingsItem(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Confirmation"),
                            content: Text(
                                "Are you sure you want to delete your account? This action cannot be undone."),
                            actions: <Widget>[
                              TextButton(
                                child: Text("Cancel"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text("Delete"),
                                onPressed: () {
                                  context
                                      .read<FirebsaeAuthMethods>()
                                      .deleteAccount(context);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icons: CupertinoIcons.delete_solid,
                    title: "Delete account",
                    titleStyle: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
