import 'package:cloud_firestore/cloud_firestore.dart';

class Label {
  final String label_id;
  final String label_name;
  final String label_color;
  Label(
      {required this.label_id,
      required this.label_name,
      required this.label_color});
  factory Label.fromJson(Map<String, dynamic>? json) {
    return Label(
        label_id: json?["label_id"] as String,
        label_name: json?["label_name"] as String,
        label_color: json?["label_color"] as String);
  }
  Map<String, Object> toJson() {
    return {
      "label_id": this.label_id,
      "label_name": this.label_name,
      "label_color": this.label_color,
    };
  }

  factory Label.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Label(
        label_id: data?["label_id"],
        label_name: data?["label_name"],
        label_color: data?["label_color"]);
  }

  Map<String, dynamic> toFirestore() {
    return {
      "label_id": label_id,
      "label_name": label_name,
      "label_color": label_color,
    };
  }

  @override
  String toString() {
    return '{label_color: $label_color, label_name: $label_name}';
  }
}
