class ComplaintRequest {
  final String content;

  const ComplaintRequest({required this.content});

  Map<String, dynamic> toFormMap() {
    return {'content': content};
  }
}
