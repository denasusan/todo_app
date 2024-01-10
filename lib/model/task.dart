class Task {
  final String task_name;
  final String task_description;
  final String task_status;
  final int user_id;
  final int label_id;
  final bool is_visible;
  final DateTime start_date;
  final DateTime due_date;
  Task(
      {required this.task_name,
      required this.task_description,
      required this.task_status,
      required this.user_id,
      required this.label_id,
      required this.is_visible,
      required this.start_date,
      required this.due_date});
  factory Task.fromJson(Map<String, dynamic>? json) {
    return Task(
      task_name: json?["task_name"] as String,
      task_description: json?["task_description"] as String,
      task_status: json?["task_status"] as String,
      user_id: json?["user_id"] as int,
      label_id: json?["label_id"] as int,
      is_visible: json?["is_visible"] as bool,
      start_date: json?["start_date"] as DateTime,
      due_date: json?["due_date"] as DateTime,
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
      "due_date": this.due_date
    };
  }
}
