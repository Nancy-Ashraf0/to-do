import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/model/my_user.dart';
import 'package:to_do_app/model/todo_model.dart';
import 'package:to_do_app/ui/providers/theme_provider.dart';
import 'package:to_do_app/utils/extensions.dart';

import '../../../../utils/app_colors.dart';
import '../../../providers/list_provider.dart';
import '../home.dart';

class Edit extends StatefulWidget {
  Edit({super.key});

  static const routeName = "edit";

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  late String taskId;
  late ListProvider provider;
  late ThemeProvider themeProvider;
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    taskId = ModalRoute.of(context)!.settings.arguments as String;
    provider = Provider.of(context);
    themeProvider = Provider.of(context);

    return Scaffold(
      appBar: buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                buildBackground(),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 34.0, left: 34, right: 34, bottom: 100),
                  child: Container(
                    width: MediaQuery.sizeOf(context).width * .88,
                    height: MediaQuery.sizeOf(context).height * .71,
                    decoration: BoxDecoration(
                        color: themeProvider.containerBackGround,
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              context.localization.editTask,
                              style: Theme.of(context).textTheme.bodySmall,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 52,
                            ),
                            TextField(
                              style: Theme.of(context).textTheme.bodySmall,
                              controller: titleController,
                              decoration: InputDecoration(
                                  hintStyle:
                                      Theme.of(context).textTheme.bodySmall,
                                  hintText: context.localization.enterYourTask),
                            ),
                            TextField(
                              style: Theme.of(context).textTheme.bodySmall,
                              controller: descriptionController,
                              decoration: InputDecoration(
                                  hintStyle:
                                      Theme.of(context).textTheme.bodySmall,
                                  hintText: context
                                      .localization.enterYourDescription),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              child: Text(
                                context.localization.selectDate,
                                style: Theme.of(context).textTheme.bodySmall,
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
                                  ?.copyWith(color: AppColors.darkGray),
                            ),
                            const SizedBox(
                              height: 150,
                            ),
                            buildElevatedButton(context)
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  ElevatedButton buildElevatedButton(BuildContext context) {
    return ElevatedButton(
        style: const ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(AppColors.primary)),
        onPressed: () {
          editTask(taskId);
        },
        child: Text(
          context.localization.saveChanges,
          style: const TextStyle(color: AppColors.white, fontSize: 18),
        ));
  }

  Column buildBackground() {
    return Column(
      children: [
        Expanded(
          flex: 20,
          child: Container(
            color: AppColors.primary,
          ),
        ),
        Expanded(
            flex: 80,
            child: Container(
              color: Colors.transparent,
            ))
      ],
    );
  }

  void myDatePicker() async {
    selectedDate = (await showDatePicker(
            context: context,
            initialDate: provider.selectedDate,
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 365)))) ??
        selectedDate;
    setState(() {});
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Row(
        children: [
          InkWell(
              onTap: () {
                Navigator.pushReplacementNamed(context, Home.routeName);
              },
              child: const Icon(Icons.arrow_back)),
          const SizedBox(
            width: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 26),
            child: Text(
              "To Do List",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        ],
      ),
    );
  }

  void editTask(String taskId) async {
    TodoModel todoModel = TodoModel(
        id: taskId,
        title: titleController.text,
        description: descriptionController.text,
        date: selectedDate,
        isDone: false);
    FirebaseFirestore.instance
        .collection(MyUser.collectionName)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(TodoModel.collectionName)
        .doc(taskId)
        .set(todoModel.toJson());
    Navigator.pushReplacementNamed(context, Home.routeName);
  }
}
