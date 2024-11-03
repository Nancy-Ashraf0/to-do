import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  static const String collectionName = "todos";
  late String id;
  late String title;
  late String description;
  late DateTime date;
  late bool isDone;

  TodoModel(
      {required this.id,
      required this.title,
      required this.description,
      required this.date,
      required this.isDone});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
      'isDone': isDone,
    };
  }

  TodoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    if (json['date'] is Timestamp) {
      date = (json['date'] as Timestamp).toDate();
    } else if (json['date'] is String) {
      date = DateTime.parse(json['date']);
    } else {
      throw Exception("Invalid date format in JSON");
    }
    isDone = json['isDone'];
  }
}
