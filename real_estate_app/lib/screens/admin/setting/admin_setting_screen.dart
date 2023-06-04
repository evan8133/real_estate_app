import 'package:auto_route/auto_route.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../router/router.gr.dart';
import '../../../services/firebase_auth_methods.dart';
import '../../../services/firestore_user_methods.dart';
import '../../../utils/theme_provider.dart';

class AdminSettingScreen extends StatefulWidget {
  const AdminSettingScreen({super.key});

  @override
  State<AdminSettingScreen> createState() => _AdminSettingScreenState();
}

class _AdminSettingScreenState extends State<AdminSettingScreen> {
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
        final _user = snapshot.data!.data() as Map<String, dynamic>;
        return Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              // User card
              BigUserCard(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                settingColor: Theme.of(context).colorScheme.primaryContainer,
                userName: _user['name'],
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
                    print("OK");
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
                      context
                          .read<FirebsaeAuthMethods>()
                          .deleteAccount(context);
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
