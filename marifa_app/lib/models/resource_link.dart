class ResourceLink {
  final String titleEn;
  final String titleTr;
  final String url;

  ResourceLink({
    required this.titleEn,
    required this.titleTr,
    required this.url,
  });

  factory ResourceLink.fromJson(Map<String, dynamic> json) {
    return ResourceLink(
      titleEn: json['title_en'] as String,
      titleTr: json['title_tr'] as String,
      url: json['url'] as String,
    );
  }
}
