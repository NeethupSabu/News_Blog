import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookmarkService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addBookmark(Map<String, dynamic> article) async {
    final User? user = _auth.currentUser;
    if (user != null) {
      String imageUrl = article['urlToImage']?.isNotEmpty == true
          ? article['urlToImage']
          : 'https://assets.iqonic.design/old-themeforest-images/prokit/images/newsBlog/nb_newsImage3.jpg'; // Fallback to placeholder if the URL is empty or null
      print("Final Image URL: $imageUrl");
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('bookmarks')
          .doc(article['title'])
          .set({
        'title': article['title'],
        'author': article['author'] ?? 'Unknown Author',
        'urlToImage': imageUrl,
        'publishedAt': article['publishedAt'],
        'description': article['description'] ?? 'No Description',
        'category': article['category'] ?? 'General',
      });
    }
  }

  // Method to remove a bookmark
  Future<void> removeBookmark(String title) async {
    final User? user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('bookmarks')
          .doc(title)
          .delete();
    }
  }

  Stream<QuerySnapshot> getBookmarks({String orderBy = 'publishedAt'}) {
    final User? user = _auth.currentUser;
    if (user != null) {
      return _firestore
          .collection('users')
          .doc(user.uid)
          .collection('bookmarks')
          .orderBy(orderBy, descending: true)
          .snapshots();
    } else {
      throw Exception('User not logged in');
    }
  }

  Future<bool> isBookmarked(String title) async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final bookmark = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('bookmarks')
          .doc(title)
          .get();

      return bookmark.exists;
    }
    return false;
  }
}
