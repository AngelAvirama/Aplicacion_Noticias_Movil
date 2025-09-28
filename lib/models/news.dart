class News {
  final int id;
  final String title;
  final String body;
  final String category;

  News({required this.id, required this.title, required this.body, required this.category});

  factory News.fromJson(Map<String, dynamic> json) => News(
    id: json['id'],
    title: json['title'],
    body: json['body'],
    category: json['category'] ?? 'General',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'category': category,
  };
}
