import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:one/Screens/Profil.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:one/Widgets/Button.dart';
import 'package:one/Widgets/ShowSnackBar.dart';
import 'package:one/Widgets/TextField.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isLoading = false;
  bool _obscureText = true;

  void _togglePasswordView() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  File? _profileImage;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
  }

  Future<void> updateProfile() async {
    setState(() {
      isLoading = true;
    });

    try {
      User? user = _auth.currentUser;

      if (emailController.text.isNotEmpty) {
        await user?.verifyBeforeUpdateEmail(emailController.text);
      }
      if (passwordController.text.isNotEmpty) {
        await user?.updatePassword(passwordController.text);
      }
      if (usernameController.text.isNotEmpty) {
        await _firestore.collection('users').doc(user?.uid).update({
          'name': usernameController.text,
        });
      }
      if (_profileImage != null) {
        // Upload image to Firebase Storage and get the URL
        String imageUrl = await uploadImageToStorage(_profileImage!);
        await _firestore.collection('users').doc(user?.uid).update({
          'profilePic': imageUrl,
        });
      }

      // Fetch updated user data
      await user?.reload();
      user = _auth.currentUser;

      // Navigate to another screen to display the updated info
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ProfileScreen(),
        ),
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<String> uploadImageToStorage(File image) async {
    try {
      // Create a unique file name for the image
      String fileName =
          'profile_pics/${DateTime.now().millisecondsSinceEpoch}.png';

      // Upload the file to Firebase Storage
      UploadTask uploadTask =
          FirebaseStorage.instance.ref().child(fileName).putFile(image);

      // Wait for the upload to complete
      TaskSnapshot snapshot = await uploadTask;

      // Get the download URL of the uploaded image
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }

  Future<void> pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _profileImage = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: pickImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : const AssetImage('assets/placeholder.png'),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      height: 70,
                      child: TextFieldInput(
                          textEditingController: usernameController,
                          hintText: 'Change UserName'),
                    ),
                    SizedBox(
                      height: 70,
                      child: TextFieldInput(
                          textEditingController: emailController,
                          hintText: 'Change Email '),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10.0, right: 20.0, left: 20.0),
                      child: TextField(
                        controller: passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: const TextStyle(color: Colors.black45),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 20),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: _togglePasswordView,
                            ),
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Colors.grey.withOpacity(0.1),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(20)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 1, color: Color(0xFFFD5530)),
                                borderRadius: BorderRadius.circular(20))),
                      ),
                    ),
                    MyButton(onTab: updateProfile, text: 'Save '),
                  ],
                ),
              ),
      ),
    );
  }
}
