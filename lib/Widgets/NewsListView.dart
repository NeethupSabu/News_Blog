import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:one/Screens/NewsDetail.dart';
import 'package:one/Services/NewsServices.dart';

class NewsListView extends StatelessWidget {
  final String category;

  const NewsListView({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: NewsService().fetchNews(category),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final articles = snapshot.data!;
          return ListView.builder(
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return Column(
                children: [
                  ListTile(
                    trailing: Container(
                      width: 90.0,
                      height: 150.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: article['urlToImage'] != null
                              ? CachedNetworkImageProvider(
                                  article['urlToImage'])
                              : const AssetImage(
                                      'assets/close-up-reporter-taking-interview.jpg')
                                  as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article['source']
                              ['name'], // Display category or source name
                          style: const TextStyle(
                            color: Color(0xFFFD5530), // Category text color
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          article['title'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    subtitle: Text(article['publishedAt']),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewsDetailPage(
                            category: article['category'] ?? 'General',
                            title: article['title'] ?? 'No Title',
                            imageUrl: article['urlToImage'] ?? '',
                            authorName: article['author'] ?? 'Unknown',
                            authorImage:
                                'https://via.placeholder.com/150', // Replace with actual author image URL
                            publishedDate: article['publishedAt'] ?? 'No Date',
                            content: article['description'] ?? 'No Content',
                            article: const {},
                          ),
                        ),
                      );
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 10.0, left: 10.0),
                    child: Divider(
                      color: Colors.black,
                    ),
                  ), // Add a divider after each item
                ],
              );
            },
          );
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }
}
