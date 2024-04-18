class Article {
  final String id;
  final String userId;
  final String title;
  final String category;
  final String description;

  Article(
      {required this.id,
        required this.userId,
        required this.title,
        required this.description,
        required this.category,
      });

  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
        id: map['id'],
        userId: map['userId'],
        title: map['title'],
        description: map['description'],
        category: map['category'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "userId": userId,
      "title": title,
      "description": description,
      "category": category,
    };
  }
}



