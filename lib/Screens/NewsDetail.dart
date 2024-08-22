import 'package:flutter/material.dart';
import 'package:one/Services/BookMarkService.dart';
import 'package:one/Services/Follow.dart';
import 'package:share_plus/share_plus.dart'; // For sharing functionality

class NewsDetailPage extends StatefulWidget {
  final String category;
  final String title;
  final String imageUrl;
  final String authorName;
  final String authorImage;
  final String publishedDate;
  final String content;

  const NewsDetailPage({
    super.key,
    required this.category,
    required this.title,
    required this.imageUrl,
    required this.authorName,
    required this.authorImage,
    required this.publishedDate,
    required Map article,
    required this.content,
  });

  @override
  _NewsDetailPageState createState() => _NewsDetailPageState();
}

class _NewsDetailPageState extends State<NewsDetailPage> {
  final BookmarkService _bookmarkService = BookmarkService();
  final FollowService _followService = FollowService();
  bool isBookmarked = false;
  bool _isFollowed = false;

  @override
  void initState() {
    super.initState();
    checkIfBookmarked();
    checkIfFollowing();
  }

  Future<void> checkIfBookmarked() async {
    final isAlreadyBookmarked =
        await _bookmarkService.isBookmarked(widget.title);
    setState(() {
      isBookmarked = isAlreadyBookmarked;
    });
  }

  Future<void> toggleBookmark() async {
    final article = {
      'category': widget.category,
      'title': widget.title,
      'imageUrl': widget.imageUrl,
      'authorName': widget.authorName,
      'publishedAt': widget.publishedDate,
      'description': widget.content,
    };

    if (isBookmarked) {
      await _bookmarkService.removeBookmark(widget.title);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bookmark removed!')),
      );
    } else {
      await _bookmarkService.addBookmark(article);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bookmarked successfully!')),
      );
    }

    setState(() {
      isBookmarked = !isBookmarked;
    });
  }

  Future<void> checkIfFollowing() async {
    final isAlreadyFollowing =
        await _followService.isFollowing('userId', widget.authorName);
    setState(() {
      _isFollowed = isAlreadyFollowing;
    });
  }

  void _toggleFollow() async {
    if (_isFollowed) {
      await _followService.unfollowAuthor('userId', widget.authorName);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unfollowed ${widget.authorName}')),
      );
    } else {
      await _followService.followAuthor('userId', widget.authorName);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Followed ${widget.authorName}')),
      );
    }

    setState(() {
      _isFollowed = !_isFollowed;
    });
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle categoryTextStyle = TextStyle(
      color: Colors.redAccent,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.2,
    );

    const TextStyle titleTextStyle = TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    );

    final TextStyle contentTextStyle = TextStyle(
      fontSize: 18,
      height: 1.5,
      color: Colors.grey[800],
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: Colors.black87,
            ),
            onPressed: toggleBookmark,
          ),
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black87),
            onPressed: () {
              Share.share('${widget.title} \n\nRead more at: [Your App Link]');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // News Image with Gradient Overlay
            Stack(
              children: [
                Hero(
                  tag: widget.imageUrl,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.network(
                        widget.imageUrl,
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            width: double.infinity,
                            height: 250,
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: double.infinity,
                            height: 250,
                            color: Colors.grey[200],
                            child: const Icon(Icons.broken_image,
                                size: 100, color: Colors.grey),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12.0),
                        bottomRight: Radius.circular(12.0),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Text(
                    widget.category.toUpperCase(),
                    style: categoryTextStyle.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                widget.title,
                style: titleTextStyle,
              ),
            ),
            const SizedBox(height: 20),
            // Author Information
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(widget.authorImage),
                    backgroundColor: Colors.grey[200],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.authorName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.verified,
                              color: Colors.blueAccent,
                              size: 16,
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.publishedDate,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _toggleFollow,
                    icon: Icon(
                        _isFollowed ? Icons.person_remove : Icons.person_add),
                    label: Text(_isFollowed ? 'Following' : 'Follow'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _isFollowed ? Colors.grey[300] : Colors.redAccent,
                      foregroundColor:
                          _isFollowed ? Colors.black87 : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                widget.content,
                style: contentTextStyle,
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
