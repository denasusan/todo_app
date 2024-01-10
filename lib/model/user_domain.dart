class UserDomain {
  final String status;
  final String is_master;
  final String user_id;
  final String domain_id;
  UserDomain(
      {required this.status,
      required this.is_master,
      required this.user_id,
      required this.domain_id});
  factory UserDomain.fromJson(Map<String, dynamic>? json) {
    return UserDomain(
      status: json?["status"] as String,
      is_master: json?["is_master"] as String,
      user_id: json?["user_id"] as String,
      domain_id: json?["domain_id"] as String,
    );
  }
  Map<String, Object> toJson() {
    return {
      "status": this.status,
      "is_master": this.is_master,
      "user_id": this.user_id,
      "domain_id": this.domain_id,
    };
  }
}
