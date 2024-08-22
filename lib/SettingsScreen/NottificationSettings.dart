import 'package:flutter/material.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  _NotificationSettingsPageState createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _appNotification = false;
  bool _recommendedArticle = false;
  bool _promotion = false;
  bool _latestNews = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Setting'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('App Notification'),
            trailing: Switch(
              value: _appNotification,
              onChanged: (bool value) {
                setState(() {
                  _appNotification = value;
                });
              },
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('Recommended Article'),
            trailing: Switch(
              value: _recommendedArticle,
              onChanged: (bool value) {
                setState(() {
                  _recommendedArticle = value;
                });
              },
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('Promotion'),
            trailing: Switch(
              value: _promotion,
              onChanged: (bool value) {
                setState(() {
                  _promotion = value;
                });
              },
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('Latest News'),
            trailing: Switch(
              value: _latestNews,
              onChanged: (bool value) {
                setState(() {
                  _latestNews = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
