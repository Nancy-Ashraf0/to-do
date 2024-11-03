import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/model/my_user.dart';
import 'package:to_do_app/model/todo_model.dart';
import 'package:to_do_app/ui/providers/list_provider.dart';
import 'package:to_do_app/ui/providers/theme_provider.dart';
import 'package:to_do_app/utils/app_colors.dart';
import 'package:to_do_app/utils/extensions.dart';

import '../../../../../utils/app_styles.dart';
import '../../edit/edit.dart';

class Todo extends StatefulWidget {
  TodoModel item;

  Todo({super.key, required this.item});

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  late ListProvider provider;
  late ThemeProvider themeProvider;
  @override
  Widget build(BuildContext context) {
    provider = Provider.of(context);
    themeProvider = Provider.of(context);
    Color stateColor = widget.item.isDone ? AppColors.green : AppColors.primary;
    return Container(
      height: 115,
      margin: const EdgeInsets.only(left: 30, right: 28, bottom: 40),
      decoration: BoxDecoration(
          color: themeProvider.containerBackGround,
          borderRadius: BorderRadius.circular(15)),
      child: Slidable(
        startActionPane: ActionPane(
          extentRatio: .5,
          motion: const ScrollMotion(),
          children: [
            buildEditSlidableAction(context),
            buildDeleteSlidableAction(context),
          ],
        ),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 32, right: 24),
              height: 62,
              width: 4,
              decoration: BoxDecoration(
                color: stateColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.item.title,
                  style: AppStyles.task.copyWith(color: stateColor),
                ),
                Text(widget.item.description,
                    style: Theme.of(context).textTheme.labelSmall)
              ],
            ),
            const Spacer(),
            todoState(),
          ],
        ),
      ),
    );
  }

  SlidableAction buildDeleteSlidableAction(BuildContext context) {
    return SlidableAction(
      onPressed: (context) {
        provider.deleteDocument(TodoModel.collectionName, widget.item.id);
      },
      backgroundColor: Colors.red,
      foregroundColor: Colors.white,
      icon: Icons.delete,
      label: context.localization.delete,
    );
  }

  SlidableAction buildEditSlidableAction(BuildContext context) {
    return SlidableAction(
      onPressed: (context) {
        Navigator.pushReplacementNamed(context, Edit.routeName,
            arguments: widget.item.id);
      },
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
      backgroundColor: const Color(0xffb6b0b0),
      foregroundColor: Colors.white,
      icon: Icons.edit,
      label: context.localization.edit,
    );
  }

  Widget todoState() {
    return InkWell(
        onTap: () {
          DocumentReference documentReference = FirebaseFirestore.instance
              .collection(MyUser.collectionName)
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection(TodoModel.collectionName)
              .doc(widget.item.id);
          documentReference.update({"isDone": !widget.item.isDone});
          provider.getTodosFromFireStore();
        },
        child: !widget.item.isDone
            ? Container(
                margin: const EdgeInsets.only(right: 20),
                width: 68,
                height: 34,
                decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10)),
                child: const Icon(
                  Icons.check,
                  color: AppColors.white,
                  size: 24,
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(
                  right: 32,
                ),
                child: Text(
                  context.localization.done,
                  style: AppStyles.appBar.copyWith(color: AppColors.green),
                ),
              ));
  }
}
