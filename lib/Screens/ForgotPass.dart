import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:one/Screens/SignInScreen.dart';
import 'package:one/Widgets/Button.dart';
import 'package:one/Widgets/ShowSnackBar.dart';
import 'package:one/Widgets/TextField.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'forgot_password'.tr(),
            style: const TextStyle(fontSize: 18),
          ),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignInScreen(),
                    ));
              },
              icon: const Icon(Icons.arrow_back_ios)),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Container(
            child: Column(
              children: [
                TextFieldInput(
                    textEditingController: emailController,
                    hintText: 'email_address'.tr()),
                MyButton(
                    onTab: () async {
                      await auth
                          .sendPasswordResetEmail(email: emailController.text)
                          .then((value) {
                        showSnackBar(context, 'password_reset_link_sent'.tr());
                      }).onError((error, stackTrace) {
                        showSnackBar(context, 'error_occurred'.tr());
                      });
                      Navigator.pop(context);
                      emailController.clear();
                    },
                    text: 'send_password'.tr()),
              ],
            ),
          ),
        ));
  }
}
