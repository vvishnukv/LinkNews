class Source {
  final String id;
  final String name;

  Source({
    required this.id,
    required this.name,
  });

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class NewsModel {
  final Source source;
  final String title;
  final String description;
  final String author;
  final String publishedAt;
  final String url;
  final String urlToImage;
  final String content;

  NewsModel({
    required this.source,
    required this.title,
    required this.description,
    required this.author,
    required this.publishedAt,
    required this.urlToImage,
    required this.url,
    required this.content,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      source: Source.fromJson(json['source'] ?? {}),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      author: json['author'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
      urlToImage: json['urlToImage'] ?? '',
      url: json['url'] ?? '',
      content: json['content'] ?? '',
    );
  }
}
