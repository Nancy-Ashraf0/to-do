import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/model/my_user.dart';
import 'package:to_do_app/ui/providers/theme_provider.dart';
import 'package:to_do_app/utils/extensions.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_styles.dart';
import '../../../utils/dialogue_utils/dialogue.dart';
import '../home/home.dart';

class Register extends StatefulWidget {
  Register({super.key});

  static const routeName = "register";

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String name = "";
  String email = "";
  String password = "";
  late String errorMessage;
  bool isHidden = false;
  late ThemeProvider themeProvider;
  final _passKey = GlobalKey<FormState>();
  final _mailKey = GlobalKey<FormState>();
  final _userKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of(context);
    errorMessage = context.localization.somethingWentWrongPleaseTryAgainLater;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              context.localization.welcomeToToDoApp,
              style: AppStyles.appBar,
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.green)),
              child: Row(
                children: [
                  const Icon(
                    Icons.person,
                    color: AppColors.black,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Expanded(
                    child: Form(
                      key: _userKey,
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Username can't be empty... ";
                          }
                          return null;
                        },
                        onChanged: (newName) {
                          name = newName;
                        },
                        decoration: InputDecoration(
                            hintText: context.localization.enterYourUserName),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.green)),
              child: Row(
                children: [
                  const Icon(
                    Icons.email_rounded,
                    color: AppColors.black,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Expanded(
                    child: Form(
                      key: _mailKey,
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Email can't be empty... ";
                          }
                          return null;
                        },
                        onChanged: (newEmail) {
                          email = newEmail;
                        },
                        decoration: InputDecoration(
                            hintText: context.localization.enterYourEmail),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.green)),
              child: Row(
                children: [
                  const Icon(
                    Icons.password,
                    color: AppColors.black,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Expanded(
                    child: Form(
                      key: _passKey,
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password can't be empty... ";
                          }
                          return null;
                        },
                        onChanged: (newPassword) {
                          password = newPassword;
                        },
                        decoration: InputDecoration(
                            hintText: context.localization.enterYourPassword,
                            suffix: InkWell(
                              onTap: () {
                                isHidden = !isHidden;
                                setState(() {});
                              },
                              child: Icon(
                                isHidden
                                    ? (Icons.visibility_off)
                                    : (Icons.visibility),
                                color: AppColors.black,
                              ),
                            )),
                        obscureText: isHidden,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(AppColors.primary)),
                onPressed: () {
                  if (_passKey.currentState!.validate() &&
                      _mailKey.currentState!.validate() &&
                      _userKey.currentState!.validate()) {
                    createAccount();
                  }
                },
                child: Text(
                  context.localization.create,
                  style: const TextStyle(color: AppColors.white, fontSize: 20),
                )),
          ],
        ),
      ),
    );
  }

  createAccount() async {
    try {
      Dialogue.showLoading(context);
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Dialogue.showErrorDialog(context, errorMessage);
      Dialogue.hideLoading(context);
      MyUser myUser =
          MyUser(id: credential.user!.uid, email: email, name: name);
      myUser.saveUserInFirestore();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.localization.registrationSuccessful)),
      );
      Navigator.pushReplacementNamed(context, Home.routeName);
    } on FirebaseAuthException catch (e) {
      Dialogue.hideLoading(context);
      if (e.code == 'weak-password') {
        Dialogue.showErrorDialog(context, e.code);
      } else if (e.code == 'email-already-in-use') {
        Dialogue.showErrorDialog(context, e.code);
      }
    } catch (e) {
      Dialogue.showErrorDialog(context, errorMessage);
    }
  }
}
