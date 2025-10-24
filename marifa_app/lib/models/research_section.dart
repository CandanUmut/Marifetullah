class ResearchSection {
  final String id;
  final String title;
  final String summary;
  final List<String> bullets;

  ResearchSection({
    required this.id,
    required this.title,
    required this.summary,
    required this.bullets,
  });

  factory ResearchSection.fromJson(Map<String, dynamic> json) {
    return ResearchSection(
      id: json['id'] as String,
      title: json['title'] as String,
      summary: json['summary'] as String,
      bullets: (json['bullets'] as List<dynamic>).cast<String>(),
    );
  }
}
