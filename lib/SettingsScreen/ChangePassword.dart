import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:one/Widgets/Button.dart';
import 'package:one/Widgets/ShowSnackBar.dart';
import 'package:one/Widgets/TextField.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _auth = FirebaseAuth.instance;
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _changePassword() async {
    final user = _auth.currentUser;
    final oldPassword = _oldPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword != confirmPassword) {
      print("New password and confirm password do not match.");
      return;
    }

    if (user != null) {
      try {
        // Reauthenticate the user
        final cred = EmailAuthProvider.credential(
          email: user.email!,
          password: oldPassword,
        );

        await user.reauthenticateWithCredential(cred);

        // Update the password
        await user.updatePassword(newPassword);
        print("Password updated successfully.");
        showSnackBar(context, 'Password Updated Succesfully');

        // Optionally, sign the user out or notify them of the change
        await _auth.signOut();
        showSnackBar(
            context, "User signed out. Please log in with your new password.");
      } catch (e) {
        showSnackBar(context, "Failed to update password: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Change Password',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Column(
          children: [
            SizedBox(
              height: 70,
              child: TextFieldInput(
                  textEditingController: _oldPasswordController,
                  hintText: 'Old Password'),
            ),
            SizedBox(
              height: 70,
              child: TextFieldInput(
                textEditingController: _newPasswordController,
                hintText: 'New Password',
              ),
            ),
            SizedBox(
              height: 70,
              child: TextFieldInput(
                  textEditingController: _confirmPasswordController,
                  hintText: 'Confirm Password'),
            ),
            const SizedBox(height: 8),
            MyButton(
              onTab: _changePassword,
              text: 'Submit',
            ),
          ],
        ),
      ),
    );
  }
}
