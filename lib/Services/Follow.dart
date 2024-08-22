import 'package:cloud_firestore/cloud_firestore.dart';

class FollowService {
  final CollectionReference _followCollection =
      FirebaseFirestore.instance.collection('follows');

  Future<void> followAuthor(String userId, String authorName) async {
    await _followCollection.doc(userId).set({
      'authors': FieldValue.arrayUnion([authorName])
    }, SetOptions(merge: true));
  }

  Future<void> unfollowAuthor(String userId, String authorName) async {
    await _followCollection.doc(userId).set({
      'authors': FieldValue.arrayRemove([authorName])
    }, SetOptions(merge: true));
  }

  Future<bool> isFollowing(String userId, String authorName) async {
    DocumentSnapshot doc = await _followCollection.doc(userId).get();
    if (doc.exists) {
      List authors = doc['authors'] ?? [];
      return authors.contains(authorName);
    }
    return false;
  }

  Stream<List<String>> getFollowedAuthors(String userId) {
    return _followCollection.doc(userId).snapshots().map((doc) {
      if (doc.exists) {
        List<String> authors = List<String>.from(doc['authors'] ?? []);
        print('Authors in Stream: $authors'); // Debugging output
        return authors;
      }
      return [];
    });
  }
}
