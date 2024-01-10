class Domain {
  final String domain_name;
  Domain({required this.domain_name});
  factory Domain.fromJson(Map<String, dynamic>? json) {
    return Domain(domain_name: json?["domain_name"] as String);
  }
  Map<String, Object> toJson() {
    return {"domain_name": this.domain_name};
  }
}
