import 'package:flutter/material.dart';
import 'package:one/Widgets/NewsListView.dart';

class AllNewsPage extends StatelessWidget {
  const AllNewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All News'),
      ),
      body: const NewsListView(category: ''),
    );
  }
}
