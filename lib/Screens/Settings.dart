import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:one/SettingsScreen/ChangePassword.dart';
import 'package:one/SettingsScreen/EditProfile.dart';

import 'package:one/SettingsScreen/NottificationSettings.dart';
import 'package:one/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadDarkModeSetting();
  }

  Future<void> _loadDarkModeSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('darkMode') ?? false;
    });
  }

  Future<void> _saveDarkModeSetting(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
  }

  void _toggleDarkMode(bool value) {
    setState(() {
      _isDarkMode = value;
      _saveDarkModeSetting(value);
    });

    // Apply dark mode theme
    final ThemeData theme = _isDarkMode ? ThemeData.dark() : ThemeData.light();
    ThemeMode mode = _isDarkMode ? ThemeMode.dark : ThemeMode.light;

    MyApp.setTheme(context, theme, mode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'setting'.tr(),
          style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          ListTile(
            title: Text(
              'language'.tr(),
              style:
                  const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            trailing: PopupMenuButton<String>(
              onSelected: (String selectedLanguage) {
                // Update the app's locale based on the selected language
                if (selectedLanguage == 'English') {
                  context.setLocale(const Locale('en', 'US'));
                } else if (selectedLanguage == 'Melayu') {
                  context.setLocale(const Locale('ms', 'MY'));
                } else if (selectedLanguage == 'Chinese') {
                  context.setLocale(const Locale('zh', 'CN'));
                } else if (selectedLanguage == 'Spanish') {
                  context.setLocale(const Locale('es', 'ES'));
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'English',
                  child: Text('English'),
                ),
                const PopupMenuItem<String>(
                  value: 'Melayu',
                  child: Text('Melayu'),
                ),
                const PopupMenuItem<String>(
                  value: 'Chinese',
                  child: Text('Chinese'),
                ),
                const PopupMenuItem<String>(
                  value: 'Spanish',
                  child: Text('Spanish'),
                ),
              ],
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.language, color: Colors.red, size: 16.0),
                  SizedBox(width: 4),
                  Text('Select Language', style: TextStyle(fontSize: 12.0)),
                  Icon(Icons.arrow_forward_ios, size: 16.0),
                ],
              ),
            ),
          ),
          const Divider(thickness: 1, color: Colors.black),
          ListTile(
            title: Text(
              'edit_profile'.tr(), // Localized text
              style:
                  const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16.0),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const EditProfileScreen()),
              );
            },
          ),
          const Divider(thickness: 1, color: Colors.black),
          ListTile(
            title: Text(
              'change_password'.tr(), // Localized text
              style:
                  const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16.0),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ChangePasswordPage()),
              );
            },
          ),
          const Divider(thickness: 1, color: Colors.black),
          ListTile(
            title: Text(
              'notification_setting'.tr(), // Localized text
              style:
                  const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16.0),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NotificationSettingsPage()),
              );
            },
          ),
          const Divider(thickness: 1, color: Colors.black),
          ListTile(
            title: Text(
              'dark_mode'.tr(), // Localized text
              style:
                  const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            trailing: Switch(
              value: _isDarkMode,
              onChanged: _toggleDarkMode,
            ),
          ),
        ],
      ),
    );
  }
}
