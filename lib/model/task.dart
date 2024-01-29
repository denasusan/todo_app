import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String task_id;
  final String task_name;
  final String task_description;
  final String task_status;
  final DocumentReference user_id;
  final DocumentReference label_id;
  final bool is_visible;
  final DateTime start_date;
  final DateTime due_date;
  final List<dynamic> sharedWith;

  Task({
    required this.task_id,
    required this.task_name,
    required this.task_description,
    required this.task_status,
    required this.user_id,
    required this.label_id,
    required this.is_visible,
    required this.start_date,
    required this.due_date,
    required this.sharedWith,
  });
  factory Task.fromJson(Map<String, dynamic>? json) {
    return Task(
      task_id: json?['task_id'] as String,
      task_name: json?["task_name"] as String,
      task_description: json?["task_description"] as String,
      task_status: json?["task_status"] as String,
      user_id: json?["user_id"] as DocumentReference,
      label_id: json?["label_id"] as DocumentReference,
      is_visible: json?["is_visible"] as bool,
      start_date: json?["start_date"] as DateTime,
      due_date: json?["due_date"] as DateTime,
      sharedWith: json?["sharedWith"] as List<dynamic>,
    );
  }
  Map<String, Object> toJson() {
    return {
      "task_name": this.task_name,
      "task_description": this.task_description,
      "task_status": this.task_status,
      "user_id": this.user_id,
      "label_id": this.label_id,
      "is_visible": this.is_visible,
      "start_date": this.start_date,
      "due_date": this.due_date,
      "sharedWith": this.sharedWith,
    };
  }

  factory Task.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Task(
      task_id: data?["task_id"],
      task_name: data?["task_name"],
      task_description: data?["task_description"],
      task_status: data?["task_status"],
      user_id: data?["user_id"],
      label_id: data?["label_id"],
      is_visible: data?["is_visible"],
      start_date: data?["start_date"],
      due_date: data?["due_date"],
      sharedWith: data?['sharedWith'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "task_name": this.task_name,
      "task_description": this.task_description,
      "task_status": this.task_status,
      "user_id": this.user_id,
      "label_id": this.label_id,
      "is_visible": this.is_visible,
      "start_date": this.start_date,
      "due_date": this.due_date,
      "sharedWith": this.sharedWith,
    };
  }
}
