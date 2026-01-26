class About {
  final int id;
  final String title;
  final String content;
  final String? imageUrl;

  About({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
  });

  factory About.fromJson(Map<String, dynamic> json) {
    return About(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      imageUrl: json['image_url'],
    );
  }
}
