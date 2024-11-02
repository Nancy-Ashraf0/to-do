import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyUser {
  String id;
  String email;
  String name;
  static const String collectionName = "users"; // Made static for consistency

  MyUser({required this.id, required this.email, required this.name});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
    };
  }

  factory MyUser.fromJson(Map<String, dynamic> json) {
    return MyUser(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
    );
  }

  Future<void> saveUserInFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      id = user.uid;
      FirebaseFirestore.instance
          .collection(collectionName)
          .doc(id)
          .set(toJson());
      print("User saved successfully with UID: $id");
    } else {
      print("Error: User is not authenticated.");
    }
  }
}
