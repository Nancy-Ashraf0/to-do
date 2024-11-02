import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/utils/app_styles.dart';

class Dialogue {
  static showLoading(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => const Center(child: CircularProgressIndicator()));
  }

  static hideLoading(BuildContext context) {
    Navigator.pop(context);
  }

  static void showErrorDialog(BuildContext context, String errorMessage) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text("Error"),
          content: Text(
            errorMessage,
            style: AppStyles.inter,
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Closes the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
