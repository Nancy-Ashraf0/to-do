import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/utils/app_colors.dart';
import 'package:to_do_app/utils/extensions.dart';

import '../../../utils/app_styles.dart';
import '../../../utils/dialogue_utils/dialogue.dart';
import '../register/register.dart';
import '../splash/splash.dart';

class Login extends StatefulWidget {
  static const routeName = "login";
  String email = "";
  String password = "";

  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isHidden = false;
  final _passKey = GlobalKey<FormState>();
  final _mailKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              context.localization.welcomeBackToToDoApp,
              style: AppStyles.appBar,
            ),
            const SizedBox(
              height: 20,
            ),
            buildMailContainer(context),
            const SizedBox(
              height: 20,
            ),
            buildPassContainer(context),
            const SizedBox(
              height: 30,
            ),
            const SizedBox(
              height: 10,
            ),
            buildloginButton(context),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.localization.createAccount,
                      style: AppStyles.inter,
                    ),
                    const Icon(
                      Icons.arrow_forward,
                      color: AppColors.black,
                    )
                  ],
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, Register.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }

  ElevatedButton buildloginButton(BuildContext context) {
    return ElevatedButton(
        style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(AppColors.primary)),
        onPressed: () {
          if (_passKey.currentState!.validate() &&
              _mailKey.currentState!.validate()) {
            loginWithMailAndPassword();
            if (FirebaseAuth.instance.currentUser != null &&
                !FirebaseAuth.instance.currentUser!.emailVerified) {
              Dialogue.showErrorDialog(
                  context, "verify Your E-mail before log in ...");
              Timer.periodic(const Duration(seconds: 6), (timer) {
                FirebaseAuth.instance.currentUser!.reload();
                if (FirebaseAuth.instance.currentUser!.emailVerified) {
                  Navigator.pushReplacementNamed(context, Splash.routeName);
                  timer.cancel();
                }
              });
            } else {
              Navigator.pushReplacementNamed(context, Splash.routeName);
            }
          }
        },
        child: Text(
          context.localization.login,
          style: const TextStyle(color: AppColors.white, fontSize: 18),
        ));
  }

  Container buildPassContainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.green)),
      child: Row(
        children: [
          const Icon(
            Icons.password_outlined,
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
                  widget.password = newPassword;
                },
                decoration: InputDecoration(
                    hintText: context.localization.enterYourPassword,
                    suffix: InkWell(
                      onTap: () {
                        isHidden = !isHidden;
                        setState(() {});
                      },
                      child: Icon(
                        isHidden ? (Icons.visibility_off) : (Icons.visibility),
                        color: AppColors.black,
                      ),
                    )),
                obscureText: isHidden,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container buildMailContainer(BuildContext context) {
    return Container(
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
                  widget.email = newEmail;
                },
                decoration: InputDecoration(
                  hintText: context.localization.enterYourEmail,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void loginWithMailAndPassword() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: widget.email, password: widget.password);
    } on FirebaseAuthException catch (e) {
      Dialogue.showErrorDialog(
          context, context.localization.wrongEmailOrPassword);

      if (e.code == 'user-not-found') {
        Dialogue.showErrorDialog(
            context, context.localization.wrongEmailOrPassword);
      } else if (e.code == 'wrong-password') {
        Dialogue.showErrorDialog(
            context, context.localization.wrongEmailOrPassword);
      }
    }
  }
}
