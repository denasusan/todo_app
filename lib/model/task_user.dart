class TaskUser {
  final int task_id;
  final int user_id;
  TaskUser({required this.task_id, required this.user_id});
  factory TaskUser.fromJson(Map<String, dynamic>? json) {
    return TaskUser(
      task_id: json?["task_id"] as int,
      user_id: json?["user_id"] as int,
    );
  }
  Map<String, Object> toJson() {
    return {
      "task_id": this.task_id,
      "user_id": this.user_id,
    };
  }
}
