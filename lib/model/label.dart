class Label {
  final String label_id;
  final String label_name;
  final String label_color;
  Label({required this.label_id,required this.label_name, required this.label_color});
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
}
