import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart'; // Import easy_localization
import 'package:one/Screens/NewsDetail.dart';

class NewsListPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  NewsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('news_articles'.tr()), // Use the translation key
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('articles')
            .orderBy('publishedAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
                child: Text(
                    'error_fetching_articles'.tr())); // Use the translation key
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
                child: Text(
                    'no_articles_available'.tr())); // Use the translation key
          }

          final articles = snapshot.data!.docs;

          return ListView.separated(
            itemCount: articles.length,
            separatorBuilder: (context, index) => const Padding(
              padding: EdgeInsets.all(8.0),
              child: Divider(
                color: Colors.black, // Customize the divider color here
                thickness: 1, // Optional: customize the thickness
              ),
            ),
            itemBuilder: (context, index) {
              final article = articles[index].data() as Map<String, dynamic>;

              return ListTile(
                leading: Image.network(
                  article['imageUrl'] ?? '',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
                title: Text(
                  article['title'],
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  article['category'],
                  style: const TextStyle(color: Color(0xFFFD5530)),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewsDetailPage(
                        category: article['category'],
                        title: article['title'],
                        imageUrl: article['imageUrl'],
                        authorName: article['authorName'] ?? 'Unknown',
                        authorImage: article['authorImage'] ?? '',
                        publishedDate:
                            article['publishedAt'].toDate().toString(),
                        content: article['content'],
                        article: const {},
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
