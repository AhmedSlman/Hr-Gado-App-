class CompanyRuleModel {
  final int id;
  final String content;

  const CompanyRuleModel({
    required this.id,
    required this.content,
  });

  factory CompanyRuleModel.fromJson(Map<String, dynamic> json) {
    return CompanyRuleModel(
      id: (json['id'] ?? 0) as int,
      content: (json['content'] ?? '') as String,
    );
  }
}

