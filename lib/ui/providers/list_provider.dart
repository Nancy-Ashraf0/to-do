import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/model/my_user.dart';

import '../../model/todo_model.dart';

class ListProvider extends ChangeNotifier {
  DateTime selectedDate = DateTime.now();
  List<TodoModel> todos = [];

  Future<void> getTodosFromFireStore() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(MyUser.collectionName)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(TodoModel.collectionName)
        .orderBy("date")
        .get();
    todos = querySnapshot.docs.map(
      (docSnapshot) {
        Map<String, dynamic> json = docSnapshot.data() as Map<String, dynamic>;
        return TodoModel.fromJson(json);
      },
    ).toList();
    todos = todos.where((todo) {
      return todo.date.day == selectedDate.day &&
          todo.date.month == selectedDate.month &&
          todo.date.year == selectedDate.year;
    }).toList();
    notifyListeners();
  }

  // getTodosFromFireStore() async {
  //   QuerySnapshot querySnapshot =await FirebaseFirestore.instance
  //       .collection(MyUser.collectionName)
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .collection(TodoModel.collectionName).orderBy("date").get();
  //   todos = querySnapshot.docs.map((docSnapShot) {
  //     Map<String, dynamic> json = docSnapShot.data() as Map<String, dynamic>;
  //     return TodoModel.fromJson(json);
  //   }).toList();
  //   todos.where((todo) {
  //     return todo.date.day == selectedDate.day &&
  //         todo.date.month == selectedDate.month &&
  //         todo.date.year == selectedDate.year;
  //   }).toList();
  //   notifyListeners();
  // }

  Future<void> deleteDocument(String collectionName, String documentId) async {
    await FirebaseFirestore.instance
        .collection(MyUser.collectionName)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(collectionName)
        .doc(documentId)
        .delete();

    getTodosFromFireStore();
  }
}
