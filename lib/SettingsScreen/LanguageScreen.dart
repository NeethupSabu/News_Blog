import 'package:flutter/material.dart';
//import 'package:easy_localization/easy_localization.dart';

class LanguageSelectionPage extends StatefulWidget {
  const LanguageSelectionPage({super.key});

  @override
  _LanguageSelectionPageState createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  Locale? selectedLocale;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Language'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: [
          buildLanguageTile(
              'Chinese', const Locale('zh', 'CN'), 'assets/icons/china.png'),
          buildLanguageTile(
              'English', const Locale('en', 'US'), 'assets/icons/uk.png'),
          buildLanguageTile(
              'French', const Locale('fr', 'FR'), 'assets/icons/france.png'),
          buildLanguageTile(
              'Melayu', const Locale('ms', 'MY'), 'assets/icons/malaysia.png'),
          buildLanguageTile(
              'Spanish', const Locale('es', 'ES'), 'assets/icons/spain.png'),
        ],
      ),
    );
  }

  Widget buildLanguageTile(String language, Locale locale, String flagPath) {
    return ListTile(
      leading: Image.asset(
        flagPath,
        width: 30,
        height: 30,
      ),
      title: Text(language),
      trailing: selectedLocale == locale
          ? const Icon(
              Icons.check_circle,
              color: Colors.orange,
            )
          : null,
      onTap: () {
        // changeLanguage(locale);
      },
    );
  }
}
