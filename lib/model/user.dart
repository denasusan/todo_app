import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String user_name;
  final String user_email;

  User({required this.user_name, required this.user_email});
  factory User.fromJson(Map<String, dynamic>? json) {
    return User(
        user_name: json?["user_name"] as String,
        user_email: json?["user_email"] as String);
  }
  Map<String, Object> toJson() {
    return {
      "user_name": this.user_name,
      "user_email": this.user_email,
    };
  }

  factory User.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return User(
      user_name: data?['user_name'],
      user_email: data?['user_email'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "user_name": user_name,
      "user_email": user_email,
    };
  }
}
