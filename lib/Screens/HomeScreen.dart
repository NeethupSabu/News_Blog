import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:one/Widgets/Drawer.dart';
import 'package:one/Widgets/NewsListView.dart';
import 'package:one/Widgets/TabNews.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('news_blog'.tr()),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: const Color(0xFFFD5530),
          indicatorWeight: 3,
          tabs: [
            Padding(
              padding: const EdgeInsets.only(left: 1.0, right: 2),
              child: Tab(text: 'all_news'.tr()),
            ),
            Tab(text: 'technology'.tr()),
            Tab(text: 'fashion'.tr()),
            Tab(text: 'sports'.tr()),
            Tab(text: 'science'.tr()),
          ],
        ),
      ),
      drawer: MyDrawer(),
      body: TabBarView(
        controller: _tabController,
        children: const [
          AllNewsTab(),
          NewsListView(category: 'technology'),
          NewsListView(category: 'fashion'),
          NewsListView(category: 'sports'),
          NewsListView(category: 'science'),
        ],
      ),
    );
  }
}
