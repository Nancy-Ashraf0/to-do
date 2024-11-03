import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/model/my_user.dart';
import 'package:to_do_app/model/todo_model.dart';
import 'package:to_do_app/ui/providers/list_provider.dart';
import 'package:to_do_app/ui/providers/theme_provider.dart';
import 'package:to_do_app/utils/extensions.dart';

import '../../../utils/app_colors.dart';

class MyBottomSheet extends StatefulWidget {
  const MyBottomSheet({super.key});

  @override
  State<MyBottomSheet> createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  late ListProvider provider;
  late ThemeProvider themeProvider;
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    provider = Provider.of(context);
    themeProvider = Provider.of(context);
    return FloatingActionButton(
        isExtended: true,
        backgroundColor: AppColors.primary,
        shape: StadiumBorder(
            side: BorderSide(
                width: 4,
                color: themeProvider.borderSide,
                style: BorderStyle.solid)),
        onPressed: () {
          showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) {
                return showBottomSheet(context);
              });
        },
        child: const Icon(Icons.add));
  }

  Padding showBottomSheet(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SizedBox(
        height: 400,
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.localization.addNewTask,
                textAlign: TextAlign.center,
              ),
              TextField(
                style: Theme.of(context).textTheme.bodySmall,
                controller: titleController,
                decoration: InputDecoration(
                    hintText: context.localization.enterYourTask),
              ),
              TextField(
                style: Theme.of(context).textTheme.bodySmall,
                controller: descriptionController,
                decoration: InputDecoration(
                    hintText: context.localization.enterYourDescription),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                child: Text(
                  context.localization.selectDate,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: AppColors.gray),
                ),
                onTap: () {
                  myDatePicker();
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: AppColors.gray),
              ),
              const Spacer(),
              ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(AppColors.primary)),
                  onPressed: () async {
                    await addTodoToFirebase();
                    Navigator.pop(context);
                    descriptionController.text = "";
                    titleController.text = "";
                  },
                  child: Text(
                    context.localization.add,
                    style:
                        const TextStyle(color: AppColors.white, fontSize: 18),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void myDatePicker() async {
    selectedDate = (await showDatePicker(
            context: context,
            initialDate: selectedDate,
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 365)))) ??
        selectedDate;
    setState(() {});
  }

  Future<void> addTodoToFirebase() async {
    DocumentReference document = FirebaseFirestore.instance
        .collection(MyUser.collectionName)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(TodoModel.collectionName)
        .doc();
    TodoModel todoModel = TodoModel(
        id: document.id,
        title: titleController.text,
        description: descriptionController.text,
        date: selectedDate,
        isDone: false);
    await document.set(todoModel.toJson());
    await provider.getTodosFromFireStore();
  }
}
