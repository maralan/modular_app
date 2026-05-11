class Post {
  final int id;
  final String title;
  final String content;
  final String excerpt;
  final String? imageUrl;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.excerpt,
    this.imageUrl,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title']['rendered'],
      content: json['content']['rendered'],
      excerpt: json['excerpt']['rendered'],
      imageUrl: json['_embedded']?['wp:featuredmedia']?[0]?['source_url'],
    );
  }
}