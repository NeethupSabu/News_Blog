import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart'; // Import easy_localization

import 'package:one/Screens/AddedNews.dart';

class CreateNewArticlePage extends StatefulWidget {
  const CreateNewArticlePage({super.key});

  @override
  _CreateNewArticlePageState createState() => _CreateNewArticlePageState();
}

class _CreateNewArticlePageState extends State<CreateNewArticlePage> {
  File? _imageFile;
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String _selectedCategory = 'General';
  bool _isAudioArticle = false;
  bool _isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage storage =
      FirebaseStorage.instanceFor(bucket: 'gs://just-8c35a.appspot.com');

  Future<String> _getUserName() async {
    final user = _auth.currentUser;
    if (user != null) {
      final docSnapshot =
          await _firestore.collection('users').doc(user.uid).get();
      if (docSnapshot.exists) {
        return docSnapshot.data()!['name'] ?? 'Unknown';
      }
    }
    return 'Unknown';
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadArticle() async {
    if (_titleController.text.isEmpty ||
        _contentController.text.isEmpty ||
        _imageFile == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('please_fill_all_fields'.tr())));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authorName = await _getUserName();
      // Upload image to Firebase Storage
      final ref = storage
          .ref()
          .child('article_images')
          .child('${DateTime.now().toIso8601String()}.jpg');
      await ref.putFile(_imageFile!);
      final imageUrl = await ref.getDownloadURL();

      // Save article to Firestore
      await _firestore.collection('articles').add({
        'title': _titleController.text,
        'content': _contentController.text,
        'category': _selectedCategory,
        'imageUrl': imageUrl,
        'authorName': authorName,
        'isAudioArticle': _isAudioArticle,
        'publishedAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('article_published_successfully'.tr())));
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => NewsListPage()),
      ); // Go back after publishing
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text('failed_to_publish_article'.tr(args: [error.toString()]))));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('create_new_article'.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.article),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => NewsListPage()),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black54),
                      ),
                      child: _imageFile != null
                          ? Image.file(_imageFile!, fit: BoxFit.cover)
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.add_photo_alternate, size: 50),
                                Text('add_article_cover'.tr()),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'title'.tr(),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _contentController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: 'write_article'.tr(),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'categories'.tr(),
                      border: const OutlineInputBorder(),
                    ),
                    items: [
                      'General',
                      'Technology',
                      'Science',
                      'Fashion',
                      'Sports'
                    ]
                        .map((category) => DropdownMenuItem(
                            value: category, child: Text(category.tr())))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text('audio_article'.tr()),
                      const Spacer(),
                      Switch(
                        value: _isAudioArticle,
                        onChanged: (value) {
                          setState(() {
                            _isAudioArticle = value;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _uploadArticle,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.amber[800],
                    ),
                    child: Text('publish'.tr()),
                  ),
                ],
              ),
            ),
    );
  }
}
