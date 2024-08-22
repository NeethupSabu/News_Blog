import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:one/Services/BookmarkService.dart';
import 'NewsDetail.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  final BookmarkService _bookmarkService = BookmarkService();
  String _sortOrder = 'publishedAt'; // Default sorting by date

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmark'),
        actions: [
          DropdownButton<String>(
            value: _sortOrder,
            icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
            dropdownColor: Colors.grey[800],
            underline: Container(),
            items: const [
              DropdownMenuItem(
                value: 'publishedAt',
                child: Text('Most Recent'),
              ),
              DropdownMenuItem(
                value: 'title',
                child: Text('Title (A-Z)'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _sortOrder = value!;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: _bookmarkService.getBookmarks(orderBy: _sortOrder),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              final bookmarks = snapshot.data!.docs;
              return ListView.separated(
                itemCount: bookmarks.length,
                separatorBuilder: (context, index) => const Divider(
                  color: Colors.black,
                ),
                itemBuilder: (context, index) {
                  final bookmark = bookmarks[index];
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        bookmark['urlToImage'] ??
                            'https://assets.iqonic.design/old-themeforest-images/prokit/images/newsBlog/nb_newsImage3.jpg',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'https://assets.iqonic.design/old-themeforest-images/prokit/images/newsBlog/nb_newsImage3.jpg', // Provide a local placeholder image
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                    title: Text(bookmark['title']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bookmark['category'],
                          style: TextStyle(
                            color: Colors.amber[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(bookmark['publishedAt']),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value == 'remove') {
                          await _bookmarkService
                              .removeBookmark(bookmark['title']);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Bookmark removed!')),
                          );
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'remove',
                          child: Text('Remove Bookmark'),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewsDetailPage(
                            category: bookmark['category'],
                            title: bookmark['title'],
                            imageUrl: bookmark['urlToImage'],
                            authorName: bookmark['author'],
                            authorImage:
                                'https://assets.iqonic.design/old-themeforest-images/prokit/images/newsBlog/nb_newsImage3.jpg',
                            publishedDate: bookmark['publishedAt'],
                            content: bookmark['description'],
                            article: bookmark.data() as Map<String, dynamic>,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            } else {
              return const Center(child: Text('No bookmarks available'));
            }
          },
        ),
      ),
    );
  }
}
