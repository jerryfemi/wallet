class NewsArticleEntity {
  final String title;
  final String source;
  final String url;
  final String imageUrl;
  final DateTime publishedAt;
  final String sentiment;

  NewsArticleEntity({
    required this.title,
    required this.source,
    required this.url,
    required this.imageUrl,
    required this.publishedAt,
    required this.sentiment,
  });
}
